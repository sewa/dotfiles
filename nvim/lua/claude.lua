-------------------------------------------------------------------------------
-- Terminal Management for Neovim
-------------------------------------------------------------------------------
--
-- This module provides integrated terminal management with two dedicated
-- terminals:
--
--   1. Claude Code - AI assistant terminal (right side, 40% width)
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
--   <leader>mc  Toggle Claude Code terminal
--   <leader>mo  Open Claude Code terminal
--   <leader>md  Close Claude Code terminal
--   <leader>mf  Focus Claude Code terminal (opens if not exists)
--   <leader>mt  Toggle shell terminal
--   <leader>mz  Zoom/unzoom Claude Code terminal (full screen toggle)
--   <leader>ms  Send visual selection to Claude with file context
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
--   │                         │   Claude Code    │
--   │      Code Buffer        │   (40% width)    │
--   │                         │                  │
--   │                         │                  │
--   ├─────────────────────────┴──────────────────┤
--   │   Shell / Test Output (15 lines)           │
--   └────────────────────────────────────────────┘
--
-------------------------------------------------------------------------------

local M = {}

-- Terminal state
local claude_buf = nil
local claude_win = nil
local shell_buf = nil
local shell_win = nil

-- Zoom state
local zoom_state = {
    is_zoomed = false,
    prev_width = nil,
}

-- Configuration
local config = {
    claude_width_percent = 0.4,
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
-- Claude Code Terminal
-------------------------------------------------------------------------------

local function open_claude()
    -- Focus existing window if valid
    if claude_win and vim.api.nvim_win_is_valid(claude_win) then
        vim.api.nvim_set_current_win(claude_win)
        vim.cmd('startinsert')
        return
    end

    local width = math.floor(vim.o.columns * config.claude_width_percent)

    vim.cmd('botright vsplit')
    vim.cmd('vertical resize ' .. width)

    -- Reuse existing buffer or create new terminal
    if claude_buf and vim.api.nvim_buf_is_valid(claude_buf) then
        vim.api.nvim_set_current_buf(claude_buf)
    else
        -- Start in project root
        local project_root = get_project_root()
        vim.cmd('lcd ' .. vim.fn.fnameescape(project_root))
        vim.cmd('terminal claude')
        claude_buf = vim.api.nvim_get_current_buf()
        vim.bo[claude_buf].buflisted = false

        -- Clean up and auto-close when terminal exits
        vim.api.nvim_create_autocmd('TermClose', {
            buffer = claude_buf,
            callback = function()
                -- Schedule to avoid issues with closing during event
                vim.schedule(function()
                    if claude_buf and vim.api.nvim_buf_is_valid(claude_buf) then
                        vim.api.nvim_buf_delete(claude_buf, { force = true })
                    end
                    claude_buf = nil
                    claude_win = nil
                    zoom_state.is_zoomed = false
                end)
            end,
        })
    end

    claude_win = vim.api.nvim_get_current_win()

    -- Terminal window options
    vim.wo[claude_win].number = false
    vim.wo[claude_win].relativenumber = false
    vim.wo[claude_win].signcolumn = 'no'

    vim.cmd('startinsert')
end

local function close_claude()
    if claude_win and vim.api.nvim_win_is_valid(claude_win) then
        vim.api.nvim_win_close(claude_win, false)
        claude_win = nil
        zoom_state.is_zoomed = false
    end
end

local function toggle_claude()
    if claude_win and vim.api.nvim_win_is_valid(claude_win) then
        close_claude()
    else
        open_claude()
    end
end

local function focus_claude()
    if claude_win and vim.api.nvim_win_is_valid(claude_win) then
        vim.api.nvim_set_current_win(claude_win)
        vim.cmd('startinsert')
    else
        open_claude()
    end
end

local function zoom_claude()
    if not claude_win or not vim.api.nvim_win_is_valid(claude_win) then
        open_claude()
        return
    end

    if zoom_state.is_zoomed then
        -- Restore previous width
        local width = zoom_state.prev_width or math.floor(vim.o.columns * config.claude_width_percent)
        vim.api.nvim_win_set_width(claude_win, width)
        zoom_state.is_zoomed = false
    else
        -- Save current width and maximize
        zoom_state.prev_width = vim.api.nvim_win_get_width(claude_win)
        vim.api.nvim_win_set_width(claude_win, vim.o.columns)
        zoom_state.is_zoomed = true
    end

    vim.api.nvim_set_current_win(claude_win)
    vim.cmd('startinsert')
end

-- Send visual selection to Claude with context
local function send_to_claude()
    local selection = get_visual_selection()
    if selection == '' then
        vim.notify('No selection', vim.log.levels.WARN)
        return
    end

    -- Get file context
    local filepath = vim.fn.expand('%:p')
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

    -- Open Claude if not open
    if not claude_win or not vim.api.nvim_win_is_valid(claude_win) then
        open_claude()
        -- Wait a bit for terminal to initialize
        vim.defer_fn(function()
            if claude_buf and vim.api.nvim_buf_is_valid(claude_buf) then
                -- Send the context to the terminal
                vim.api.nvim_chan_send(vim.bo[claude_buf].channel, context)
            end
        end, 100)
    else
        vim.api.nvim_set_current_win(claude_win)
        vim.api.nvim_chan_send(vim.bo[claude_buf].channel, context)
        vim.cmd('startinsert')
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

M.open = open_claude
M.close = close_claude
M.toggle = toggle_claude
M.focus = focus_claude
M.zoom = zoom_claude
M.send = send_to_claude
M.open_shell = open_shell
M.close_shell = close_shell
M.toggle_shell = toggle_shell

-------------------------------------------------------------------------------
-- Keybindings
-------------------------------------------------------------------------------

local options = { noremap = true, silent = true }

-- Claude Code
vim.keymap.set('n', '<leader>mc', toggle_claude, vim.tbl_extend('force', options, { desc = 'Toggle Claude Code' }))
vim.keymap.set('n', '<leader>mo', open_claude, vim.tbl_extend('force', options, { desc = 'Open Claude Code' }))
vim.keymap.set('n', '<leader>md', close_claude, vim.tbl_extend('force', options, { desc = 'Close Claude Code' }))
vim.keymap.set('n', '<leader>mf', focus_claude, vim.tbl_extend('force', options, { desc = 'Focus Claude Code' }))
vim.keymap.set('n', '<leader>mz', zoom_claude, vim.tbl_extend('force', options, { desc = 'Zoom Claude Code' }))
vim.keymap.set('v', '<leader>ms', send_to_claude, vim.tbl_extend('force', options, { desc = 'Send selection to Claude' }))

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
            if win == claude_win then
                claude_win = nil
                zoom_state.is_zoomed = false
            elseif win == shell_win then
                shell_win = nil
            end
        end, { buffer = buf, noremap = true, silent = true, desc = 'Close terminal window' })
    end,
})

return M
