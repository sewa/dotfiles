(defvar ansi-color-pre-extensions
  '(
    ;; pre extension ansi-colors go here
    )
  "List of all extensions to load before the packages.")

(defvar ansi-color-post-extensions
  '(
    compilation
    )
  "List of all extensions to load after the packages.")

(defun ansi-color/init-compilation ()
  "Initialize my extension"
  (require 'ansi-color)
  (defun colorize-compilation-buffer ()
    (toggle-read-only)
    (ansi-color-apply-on-region (point-min) (point-max))
    (toggle-read-only))
  (add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
  )
