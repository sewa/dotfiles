(defvar rspec-post-extensions
  '(
    mode
    )
  "List of all extensions to load after the packages.")

(defun rspec/init-mode ()
  "Initialize rspec"
  (defun* get-closest-gemfile-root (&optional (file "Gemfile"))
          (let ((root (expand-file-name "/")))
            (loop 
              for d = default-directory then (expand-file-name ".." d)
              if (file-exists-p (expand-file-name file d))
              return d
              if (equal d root)
              return nil)))

  (defun rspec-compile-file ()
    (interactive)
    (compile (format "cd %s;bin/rspec %s"
                     (get-closest-gemfile-root)
                     (file-relative-name (buffer-file-name) (get-closest-gemfile-root))
                     ) t))

  (defun rspec-compile-on-line ()
    (interactive)
    (compile (format "cd %s;bin/rspec %s -l %s"
                     (get-closest-gemfile-root)
                     (file-relative-name (buffer-file-name) (get-closest-gemfile-root))
                     (line-number-at-pos)
                     ) t))

  
  (evil-leader/set-key-for-mode 'enh-ruby-mode "kk" 'rspec-compile-on-line)
  (evil-leader/set-key-for-mode 'enh-ruby-mode "kf" 'rspec-compile-file)
  )
