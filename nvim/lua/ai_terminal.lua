-------------------------------------------------------------------------------
-- Terminal Management for Neovim
-------------------------------------------------------------------------------
--
-- This module provides integrated terminal management with:
--
--   1. AI Terminal Stack - Multiple AI terminals (Claude, Codex) sharing a
--      single right-side window. Only one is visible at a time; cycle with
--      <leader>mn to swap between them.
--   2. Shell - General purpose terminal (bottom, 15 lines)
--
-- Both terminals have $NVIM set automatically, allowing tools like Claude Code
-- to interact with the Neovim instance.
--
-------------------------------------------------------------------------------
-- KEYBINDINGS
-------------------------------------------------------------------------------
--
-- Normal mode:
--   <leader>mc  Toggle AI terminal (current)
--   <leader>mo  Open AI terminal
--   <leader>md  Close AI terminal
--   <leader>mf  Focus AI terminal (opens if not exists)
--   <leader>mn  Cycle to next AI terminal
--   <leader>mt  Toggle shell terminal
--   <leader>mz  Zoom/unzoom AI terminal (full screen toggle)
--   <leader>ms  Send visual selection to current AI terminal with file context
--   <leader>mr  Send visual selection to other AI terminal (relay)
--
-- Window navigation (works in normal and terminal mode):
--   <C-h>       Navigate to window on the left
--   <C-j>       Navigate to window below
--   <C-k>       Navigate to window above
--   <C-l>       Navigate to window on the right
--
-- Terminal mode:
--   <Esc>       Passes to terminal app (Claude menus, etc.)
--   <C-\><C-n>  Exit to normal mode (auto-returns to insert on cursor move)
--   <C-s>       Enter scroll mode (stay in normal mode for scrolling)
--   q           Close terminal window (press <C-\><C-n> first)
--
-- Normal mode (in terminal buffer scroll mode):
--   i           Exit scroll mode and return to insert
--
-- All terminals auto-enter insert mode when focused.
-- Windows auto-close when the terminal process exits.
--
-------------------------------------------------------------------------------
-- LAYOUT
-------------------------------------------------------------------------------
--
--   ┌─────────────────────────┬──────────────────┐
--   │                         │                  │
--   │                         │  Claude / Codex  │
--   │      Code Buffer        │   (50% width)    │
--   │                         │                  │
--   │                         │                  │
--   ├─────────────────────────┴──────────────────┤
--   │   Shell / Test Output (15 lines)           │
--   └────────────────────────────────────────────┘
--
-------------------------------------------------------------------------------

local M = {}

-- AI terminal stack
local ai_terminals = {
    { name = "Claude", cmd = "claude" },
    { name = "Codex",  cmd = "codex" },
}
local ai_bufs = {}        -- indexed by name
local ai_win = nil        -- shared window
local ai_current = 1      -- index into ai_terminals

-- Shell terminal state
local shell_buf = nil
local shell_win = nil

-- Zoom state
local zoom_state = {
    is_zoomed = false,
    prev_width = nil,
}

-- Configuration
local config = {
    claude_width_percent = 0.5,
    shell_height = 15,
}

-------------------------------------------------------------------------------
-- Utilities
-------------------------------------------------------------------------------

-- Find git root directory, fallback to cwd
local function get_project_root()
    local git_root = vim.fn.systemlist('git rev-parse --show-toplevel 2>/dev/null')[1]
    if vim.v.shell_error == 0 and git_root and git_root ~= '' then
        return git_root
    end
    return vim.fn.getcwd()
end

-- Get visual selection text
local function get_visual_selection()
    local _, srow, scol, _ = unpack(vim.fn.getpos("'<"))
    local _, erow, ecol, _ = unpack(vim.fn.getpos("'>"))

    if srow > erow or (srow == erow and scol > ecol) then
        srow, erow = erow, srow
        scol, ecol = ecol, scol
    end

    local lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, false)
    if #lines == 0 then return '' end

    if #lines == 1 then
        lines[1] = string.sub(lines[1], scol, ecol)
    else
        lines[1] = string.sub(lines[1], scol)
        lines[#lines] = string.sub(lines[#lines], 1, ecol)
    end

    return table.concat(lines, '\n')
end

-------------------------------------------------------------------------------
-- AI Terminal Stack
-------------------------------------------------------------------------------

local function current_ai()
    return ai_terminals[ai_current]
end

local function current_ai_buf()
    return ai_bufs[current_ai().name]
end

local function open_ai_terminal()
    local ai = current_ai()

    -- Focus existing window if valid
    if ai_win and vim.api.nvim_win_is_valid(ai_win) then
        -- Swap to current terminal's buffer if needed
        local buf = ai_bufs[ai.name]
        if buf and vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_win_set_buf(ai_win, buf)
        end
        vim.api.nvim_set_current_win(ai_win)
        vim.cmd('startinsert')
        return
    end

    local width = math.floor(vim.o.columns * config.claude_width_percent)

    vim.cmd('botright vsplit')
    vim.cmd('vertical resize ' .. width)

    -- Reuse existing buffer or create new terminal
    local buf = ai_bufs[ai.name]
    if buf and vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_set_current_buf(buf)
    else
        -- Start in project root
        local project_root = get_project_root()
        vim.cmd('lcd ' .. vim.fn.fnameescape(project_root))
        vim.cmd('terminal ' .. ai.cmd)
        buf = vim.api.nvim_get_current_buf()
        ai_bufs[ai.name] = buf
        vim.bo[buf].buflisted = false

        -- Clean up and auto-close when terminal exits
        local name = ai.name
        vim.api.nvim_create_autocmd('TermClose', {
            buffer = buf,
            callback = function()
                vim.schedule(function()
                    if ai_bufs[name] and vim.api.nvim_buf_is_valid(ai_bufs[name]) then
                        vim.api.nvim_buf_delete(ai_bufs[name], { force = true })
                    end
                    ai_bufs[name] = nil
                    -- Clear tracked window when its terminal buffer exits
                    if ai_win then
                        if not vim.api.nvim_win_is_valid(ai_win) then
                            ai_win = nil
                            zoom_state.is_zoomed = false
                        else
                            -- Window is still valid but no longer has a terminal buffer
                            vim.api.nvim_win_close(ai_win, true)
                            ai_win = nil
                            zoom_state.is_zoomed = false
                        end
                    end
                end)
            end,
        })
    end

    ai_win = vim.api.nvim_get_current_win()

    -- Terminal window options
    vim.wo[ai_win].number = false
    vim.wo[ai_win].relativenumber = false
    vim.wo[ai_win].signcolumn = 'no'

    vim.cmd('startinsert')
end

local function close_ai_terminal()
    if ai_win and vim.api.nvim_win_is_valid(ai_win) then
        vim.api.nvim_win_close(ai_win, false)
        ai_win = nil
        zoom_state.is_zoomed = false
    end
end

local function toggle_ai_terminal()
    if ai_win and vim.api.nvim_win_is_valid(ai_win) then
        close_ai_terminal()
    else
        open_ai_terminal()
    end
end

local function focus_ai_terminal()
    if ai_win and vim.api.nvim_win_is_valid(ai_win) then
        vim.api.nvim_set_current_win(ai_win)
        vim.cmd('startinsert')
    else
        open_ai_terminal()
    end
end

local function cycle_ai_terminal()
    ai_current = (ai_current % #ai_terminals) + 1
    local ai = current_ai()

    if ai_win and vim.api.nvim_win_is_valid(ai_win) then
        -- Create buffer if needed
        local buf = ai_bufs[ai.name]
        if not buf or not vim.api.nvim_buf_is_valid(buf) then
            -- Need to create the terminal in the existing window
            vim.api.nvim_set_current_win(ai_win)
            local project_root = get_project_root()
            vim.cmd('lcd ' .. vim.fn.fnameescape(project_root))
            vim.cmd('terminal ' .. ai.cmd)
            buf = vim.api.nvim_get_current_buf()
            ai_bufs[ai.name] = buf
            vim.bo[buf].buflisted = false

            local name = ai.name
            vim.api.nvim_create_autocmd('TermClose', {
                buffer = buf,
                callback = function()
                    vim.schedule(function()
                        if ai_bufs[name] and vim.api.nvim_buf_is_valid(ai_bufs[name]) then
                            vim.api.nvim_buf_delete(ai_bufs[name], { force = true })
                        end
                        ai_bufs[name] = nil
                        if ai_win and not vim.api.nvim_win_is_valid(ai_win) then
                            ai_win = nil
                            zoom_state.is_zoomed = false
                        end
                    end)
                end,
            })
        else
            vim.api.nvim_win_set_buf(ai_win, buf)
        end
        vim.api.nvim_set_current_win(ai_win)
        vim.cmd('startinsert')
    else
        open_ai_terminal()
    end

    vim.notify('Switched to ' .. ai.name, vim.log.levels.INFO)
end

local function zoom_ai_terminal()
    if not ai_win or not vim.api.nvim_win_is_valid(ai_win) then
        open_ai_terminal()
        return
    end

    if zoom_state.is_zoomed then
        -- Restore previous width
        local width = zoom_state.prev_width or math.floor(vim.o.columns * config.claude_width_percent)
        vim.api.nvim_win_set_width(ai_win, width)
        zoom_state.is_zoomed = false
    else
        -- Save current width and maximize
        zoom_state.prev_width = vim.api.nvim_win_get_width(ai_win)
        vim.api.nvim_win_set_width(ai_win, vim.o.columns)
        zoom_state.is_zoomed = true
    end

    vim.api.nvim_set_current_win(ai_win)
    vim.cmd('startinsert')
end

-- Send visual selection to current AI terminal with context
local function send_to_ai_terminal()
    local selection = get_visual_selection()
    if selection == '' then
        vim.notify('No selection', vim.log.levels.WARN)
        return
    end

    -- Get file context
    local relative_path = vim.fn.expand('%:.')
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")

    -- Build context message
    local context = string.format(
        'From `%s` (lines %d-%d):\n```\n%s\n```',
        relative_path,
        start_line,
        end_line,
        selection
    )

    local buf = current_ai_buf()

    -- Open AI terminal if not open
    if not ai_win or not vim.api.nvim_win_is_valid(ai_win) then
        open_ai_terminal()
        -- Wait a bit for terminal to initialize
        vim.defer_fn(function()
            buf = current_ai_buf()
            if buf and vim.api.nvim_buf_is_valid(buf) then
                vim.api.nvim_chan_send(vim.bo[buf].channel, context)
            end
        end, 100)
    else
        vim.api.nvim_set_current_win(ai_win)
        if buf and vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_chan_send(vim.bo[buf].channel, context)
        end
        vim.cmd('startinsert')
    end
end

-- Send visual selection to the OTHER AI terminal (relay between AI tools)
local function send_to_other_ai_terminal()
    local selection = get_visual_selection()
    if selection == '' then
        vim.notify('No selection', vim.log.levels.WARN)
        return
    end

    -- Determine which terminal is "other"
    local current_buf = vim.api.nvim_get_current_buf()
    local other_idx = nil

    -- If current buffer is an AI terminal, pick the other one
    for i, ai in ipairs(ai_terminals) do
        if ai_bufs[ai.name] == current_buf then
            -- Current buffer is terminal i, so pick the other
            other_idx = (i % #ai_terminals) + 1
            break
        end
    end

    -- If not in an AI terminal buffer, pick whichever is NOT current
    if not other_idx then
        other_idx = (ai_current % #ai_terminals) + 1
    end

    local other = ai_terminals[other_idx]
    local buf = ai_bufs[other.name]

    -- Ensure the other terminal exists
    if not buf or not vim.api.nvim_buf_is_valid(buf) then
        -- Save state, cycle to create it, then cycle back
        local prev_current = ai_current
        ai_current = other_idx
        open_ai_terminal()
        buf = ai_bufs[other.name]
        -- Cycle back and restore previous window
        ai_current = prev_current
        if ai_win and vim.api.nvim_win_is_valid(ai_win) then
            local prev_buf = ai_bufs[current_ai().name]
            if prev_buf and vim.api.nvim_buf_is_valid(prev_buf) then
                vim.api.nvim_win_set_buf(ai_win, prev_buf)
            end
        end
    end

    if buf and vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_chan_send(vim.bo[buf].channel, selection)
        vim.notify('Sent to ' .. other.name, vim.log.levels.INFO)
    else
        vim.notify('Failed to open ' .. other.name, vim.log.levels.ERROR)
    end
end

-------------------------------------------------------------------------------
-- Shell Terminal
-------------------------------------------------------------------------------

local function open_shell()
    -- Focus existing window if valid
    if shell_win and vim.api.nvim_win_is_valid(shell_win) then
        vim.api.nvim_set_current_win(shell_win)
        vim.cmd('startinsert')
        return
    end

    vim.cmd('botright split')
    vim.cmd('resize ' .. config.shell_height)

    -- Reuse existing buffer or create new terminal
    if shell_buf and vim.api.nvim_buf_is_valid(shell_buf) then
        vim.api.nvim_set_current_buf(shell_buf)
    else
        -- Start in project root
        local project_root = get_project_root()
        vim.cmd('lcd ' .. vim.fn.fnameescape(project_root))
        vim.cmd('terminal')
        shell_buf = vim.api.nvim_get_current_buf()
        vim.bo[shell_buf].buflisted = false

        -- Clean up and auto-close when terminal exits
        vim.api.nvim_create_autocmd('TermClose', {
            buffer = shell_buf,
            callback = function()
                vim.schedule(function()
                    if shell_buf and vim.api.nvim_buf_is_valid(shell_buf) then
                        vim.api.nvim_buf_delete(shell_buf, { force = true })
                    end
                    shell_buf = nil
                    shell_win = nil
                end)
            end,
        })
    end

    shell_win = vim.api.nvim_get_current_win()

    -- Terminal window options
    vim.wo[shell_win].number = false
    vim.wo[shell_win].relativenumber = false
    vim.wo[shell_win].signcolumn = 'no'

    vim.cmd('startinsert')
end

local function close_shell()
    if shell_win and vim.api.nvim_win_is_valid(shell_win) then
        vim.api.nvim_win_close(shell_win, false)
        shell_win = nil
    end
end

local function toggle_shell()
    if shell_win and vim.api.nvim_win_is_valid(shell_win) then
        close_shell()
    else
        open_shell()
    end
end

-------------------------------------------------------------------------------
-- Public API
-------------------------------------------------------------------------------

M.open = open_ai_terminal
M.close = close_ai_terminal
M.toggle = toggle_ai_terminal
M.focus = focus_ai_terminal
M.cycle = cycle_ai_terminal
M.zoom = zoom_ai_terminal
M.send = send_to_ai_terminal
M.relay = send_to_other_ai_terminal
M.open_shell = open_shell
M.close_shell = close_shell
M.toggle_shell = toggle_shell

-------------------------------------------------------------------------------
-- Keybindings
-------------------------------------------------------------------------------

local options = { noremap = true, silent = true }

-- AI Terminal
vim.keymap.set('n', '<leader>mc', toggle_ai_terminal, vim.tbl_extend('force', options, { desc = 'Toggle AI terminal' }))
vim.keymap.set('n', '<leader>mo', open_ai_terminal, vim.tbl_extend('force', options, { desc = 'Open AI terminal' }))
vim.keymap.set('n', '<leader>md', close_ai_terminal, vim.tbl_extend('force', options, { desc = 'Close AI terminal' }))
vim.keymap.set('n', '<leader>mf', focus_ai_terminal, vim.tbl_extend('force', options, { desc = 'Focus AI terminal' }))
vim.keymap.set('n', '<leader>mz', zoom_ai_terminal, vim.tbl_extend('force', options, { desc = 'Zoom AI terminal' }))
vim.keymap.set('n', '<leader>mn', cycle_ai_terminal, vim.tbl_extend('force', options, { desc = 'Cycle to next AI terminal' }))
vim.keymap.set('v', '<leader>ms', send_to_ai_terminal, vim.tbl_extend('force', options, { desc = 'Send selection to AI terminal' }))
vim.keymap.set('v', '<leader>mr', send_to_other_ai_terminal, vim.tbl_extend('force', options, { desc = 'Send selection to other AI terminal' }))

-- Shell
vim.keymap.set('n', '<leader>mt', toggle_shell, vim.tbl_extend('force', options, { desc = 'Toggle shell terminal' }))

-------------------------------------------------------------------------------
-- Autocommands
-------------------------------------------------------------------------------

-- Auto-enter insert mode when focusing a terminal buffer
vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
    pattern = 'term://*',
    callback = function()
        if vim.bo.buftype == 'terminal' then
            vim.cmd('startinsert')
        end
    end,
})

-- Force insert mode on any cursor movement in terminal buffers
-- This catches mouse clicks and accidental escapes
-- Scroll mode can be enabled per-buffer to temporarily allow normal mode scrolling
vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    callback = function()
        local buf = vim.api.nvim_get_current_buf()

        -- Initialize scroll mode as disabled
        vim.b[buf].terminal_scroll_mode = false

        vim.api.nvim_create_autocmd('CursorMoved', {
            buffer = buf,
            callback = function()
                -- Skip if scroll mode is enabled
                if vim.b[buf].terminal_scroll_mode then
                    return
                end
                -- Defer check until after any pending window navigation completes
                vim.schedule(function()
                    if vim.api.nvim_get_current_buf() == buf and vim.bo[buf].buftype == 'terminal' then
                        vim.cmd('startinsert')
                    end
                end)
            end,
        })

        -- Enter scroll mode: <C-s> in terminal mode
        vim.keymap.set('t', '<C-s>', function()
            vim.b[buf].terminal_scroll_mode = true
            vim.cmd('stopinsert')
            vim.notify('Scroll mode (press i to exit)', vim.log.levels.INFO)
        end, { buffer = buf, noremap = true, silent = true, desc = 'Enter scroll mode' })

        -- Exit scroll mode: i in normal mode (for terminal buffers)
        vim.keymap.set('n', 'i', function()
            vim.b[buf].terminal_scroll_mode = false
            vim.cmd('startinsert')
        end, { buffer = buf, noremap = true, silent = true, desc = 'Exit scroll mode' })
    end,
})

-------------------------------------------------------------------------------
-- Terminal Navigation (works from both normal and terminal mode)
-------------------------------------------------------------------------------

-- Normal mode: consistent navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', options)
vim.keymap.set('n', '<C-j>', '<C-w>j', options)
vim.keymap.set('n', '<C-k>', '<C-w>k', options)
vim.keymap.set('n', '<C-l>', '<C-w>l', options)

-- Terminal mode: navigate away without escaping first
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', options)
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', options)
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', options)
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', options)

-------------------------------------------------------------------------------
-- Terminal Mode Convenience
-------------------------------------------------------------------------------

-- Escape passes through to terminal apps (no mapping needed)
-- Use <C-\><C-n> to exit to normal mode if needed

-- Close terminal window with q in normal mode (when in terminal buffer)
vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        vim.keymap.set('n', 'q', function()
            local win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_close(win, false)
            -- Reset tracked windows if this was one of ours
            if win == ai_win then
                ai_win = nil
                zoom_state.is_zoomed = false
            elseif win == shell_win then
                shell_win = nil
            end
        end, { buffer = buf, noremap = true, silent = true, desc = 'Close terminal window' })
    end,
})

return M
