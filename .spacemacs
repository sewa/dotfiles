;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

;; Configuration Layers
;; --------------------

(setq-default
 ;; List of additional paths where to look for configuration layers.
 ;; Paths must have a trailing slash (ie. `~/.mycontribs/')
 dotspacemacs-configuration-layer-path '()
 ;; List of configuration layers to load.
 dotspacemacs-configuration-layers '(html javascript themes-megapack git osx ruby erlang-elixir haskell rspec osx-ext dash)
 ;; A list of packages and/or extensions that will not be install and loaded.
 dotspacemacs-excluded-packages '()
)

;; Settings
;; --------

(setq-default
 ;; Default theme applied at startup
 dotspacemacs-themes '(solarized-dark)
 ;; The leader key
 dotspacemacs-leader-key "SPC"
 ;; Major mode leader key is a shortcut key which is the equivalent of
 ;; pressing `<leader> m`
 dotspacemacs-major-mode-leader-key ","
 ;; The command key used for Evil commands (ex-commands) and
 ;; Emacs commands (M-x).
 ;; By default the command key is `:' so ex-commands are executed like in Vim
 ;; with `:' and Emacs commands are executed with `<leader> :'.
 dotspacemacs-command-key ":"
 ;; Guide-key delay in seconds. The Guide-key is the popup buffer listing
 ;; the commands bound to the current keystrokes.
 dotspacemacs-guide-key-delay 0.4
 ;; If non nil the frame is fullscreen when Emacs starts up (Emacs 24.4+ only).
 dotspacemacs-fullscreen-at-startup t
 ;; If non nil unicode symbols are displayed in the mode line (e.g. for lighters)
 dotspacemacs-mode-line-unicode-symbols t
 ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth scrolling
 ;; overrides the default behavior of Emacs which recenters the point when
 ;; it reaches the top or bottom of the screen
 dotspacemacs-smooth-scrolling t
 ;; If non nil pressing 'jk' in insert state, ido or helm will activate the
 ;; evil leader.
 dotspacemacs-feature-toggle-leader-on-jk nil
 ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
 dotspacemacs-smartparens-strict-mode t
 ;; If non nil advises quit functions to keep server open when quitting.
 dotspacemacs-persistent-server nil
 ;; The default package repository used if no explicit repository has been
 ;; specified with an installed package.
 ;; Not used for now.
 dotspacemacs-default-package-repository nil
)

(setq paradox-github-token '4eb74fbc41e0405fbe156e08a68644e7ffb4d579)

;; Initialization Hooks
;; --------------------

(defun dotspacemacs/init ()
 "User initialization for Spacemacs. This function is called at the very
 startup."
 (global-set-key (kbd "C-j") 'open-line)

 (setq-default ruby-version-manager 'rvm)

 (setq-default ruby-on-rails-support t)

 (setq scss-compile-at-save nil)
 (setq web-mode-markup-indent-offset 2) 
 (setq web-mode-css-indent-offset 2) 
 (setq web-mode-code-indent-offset 2)
 (setq web-mode-extra-snippets
       '(("erb" . (("e" . "<%= | %>")
                   ("t"  . "<%= t(|) %>")
                   ("c"  . "<%# | %>")
                   ))
         ))
)

;; Custom variables
;; ----------------

;; Do not write anything in this section. This is where Emacs will
;; auto-generate custom variable definitions.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-ispell-requires 4)
 '(ahs-case-fold-search nil)
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(ahs-idle-interval 0.25)
 '(ahs-idle-timer 0 t)
 '(ahs-inhibit-face-list nil)
 '(magit-use-overlays nil)
 '(ring-bell-function (quote ignore) t)
 '(safe-local-variable-values (quote ((encoding . utf-8)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
