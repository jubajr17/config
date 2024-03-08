(defun goto-configs ()
  "Go to emacs configs."
  (interactive)
  (find-file (locate-user-emacs-file "init.el")))

(defun project-copy-relative-file-name ()
  "Copy file path of current buffer relative to project directory."
  (interactive)
  (kill-new (project-relative-file-name)))

(defun rails-compile ()
  (interactive)
  (setq compile-command
        (cond ((string-match-p "_test.rb\\'" (buffer-file-name))
               (let ((linum (number-to-string (line-number-at-pos)))
                     (file-name (project-relative-file-name)))
                 (if (< (line-number-at-pos) 5)
                     (string-join (list "rails t " file-name))
                   (string-join (list "rails t " (s-concat file-name ":" linum))))))
              (t compile-command)))
  (call-interactively #'project-compile))

(defun rails-comint ()
  (interactive)
  (universal-argument)
  (command-execute #'rails-compile))

(defun comint ()
  (interactive)
  (universal-argument)
  (command-execute #'compile))

(defun project-directory ()
  "Current project directory."
  (project-root (project-current)))

(defun project-relative-file-name ()
  "Relative project path to file."
  (file-relative-name (buffer-file-name) (project-directory)))

(defun project-expand-path (file-name)
  (f-join (project-directory) file-name))