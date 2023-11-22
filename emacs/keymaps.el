;; TODO
;; Keybindgs of org / modes to 'm'

(keymap-global-set "ESC" '("Quit" . keyboard-escape-quit))
(keymap-global-set "C-x h" '("Previous buffer" . previous-buffer))
(keymap-global-set "C-x l" '("Next buffer" . next-buffer))
(keymap-global-set "ESC" '("Quit" . keyboard-escape-quit))
(keymap-global-set "<remap> <dabbrev-expand>" 'hippie-expand)

(keymap-set corfu-map "RET" nil)

(defvar my-note-taking-keymap
  (let ((m (make-sparse-keymap)))
    (keymap-set m "c" '("Capture" . org-roam-capture))
    (keymap-set m "f" '("Find" . org-roam-node-find))
    (keymap-set m "i" '("Insert" . org-roam-node-insert))
    (keymap-set m "j" '("Today" . org-roam-dailies-goto-date))
    (keymap-set m "l" '("Toggle" . org-roam-buffer-toggle))
    (keymap-set m "t" '("Template" . org-insert-structure-template))
    m)
  "Note-taking")

(defvar my-editor-keymap
  (let ((m (make-sparse-keymap)))
    (keymap-set m "I" '("Reload init.el" . my/reload-init))
    (keymap-set m "p" '("packages.el" . my/go-to-packages-file))
    (keymap-set m "k" '("keymaps.el" . my/go-to-keymaps-file))
    (keymap-set m "i" '("init.el" . my/go-to-init-file))
    (keymap-set m "R" '("Restart Emacs" . restart-emacs))
    m)
  "Emacs")

(defvar my-search-keymap
  (let ((m (make-sparse-keymap)))
    (keymap-set m "i" '("Imenu" . consult-imenu))
    (keymap-set m "j" '("Jump" . avy-goto-char-timer))
    (keymap-set m "g" '("Occur" . occur))
    (keymap-set m "s" '("Search" . consult-line))
    m)
  "Local Search")

(defvar my-find-keymap
  (let ((m (make-sparse-keymap)))
    (keymap-set m "B" '("All buffers" . consult-buffer))
    (keymap-set m "b" '("Buffer" . consult-project-buffer))
    (keymap-set m "d" '("Dir" . project-find-dir))
    (keymap-set m "g" '("Grep" . project-find-regexp))
    (keymap-set m "i" '("Imenus" . consult-imenu-multi))
    (keymap-set m "p" '("Project" . project-switch-project))
    (keymap-set m "r" '("Recentf" . consult-recent-file))
    (keymap-set m "s" '("Search" . consult-ripgrep))
    m)
  "Find")

(defvar my-code-keymap
  (let ((m (make-sparse-keymap)))
    (keymap-set m "C" '("Project compile" . project-compile))
    (keymap-set m "c" '("Compile" . my/compile))
    (keymap-set m "r" '("Recompile" . recompile))
    (keymap-set m "y" '("Yank filename" . my/project-copy-relative-file-name))
    m)
  "Code")

(defvar my-git-keymap
  (let ((m (make-sparse-keymap)))
    (keymap-set m "B" '("Show blame" . magit-blame-addition))
    (keymap-set m "G" '("Git dispatch buffer" . magit-file-dispatch))
    (keymap-set m "b" '("Git blame" . magit-blame))
    (keymap-set m "d" '("Git diff" . magit-diff-buffer-file))
    (keymap-set m "g" '("Git status" . magit-status))
    (keymap-set m "l" '("Git logs" . magit-log-buffer-file))
    (keymap-set m "y" '("Git link" . git-link))
    m)
  "Git")

(defvar my-leader-keymap
  (let ((m (make-sparse-keymap)))
    (keymap-set m "SPC" '("Find file" . project-find-file))
    (keymap-set m "." '("Dired" . project-dired))
    (keymap-set m "T" '("Terminal" . vterm))
    (keymap-set m "t" '("Terminal other" . vterm-other-window))

    (keymap-set m "n" (cons "Note-taking"  my-note-taking-keymap))
    (keymap-set m "e" (cons "Emacs" my-editor-keymap))
    (keymap-set m "f" (cons "Find (global)" my-find-keymap))
    (keymap-set m "c" (cons "Code" my-code-keymap))
    (keymap-set m "g" (cons "Git" my-git-keymap))
    (keymap-set m "s" (cons "Search (local)" my-search-keymap))
    m)
  "Leader")

(keymap-set evil-normal-state-map "SPC" my-leader-keymap)
(keymap-set evil-visual-state-map "SPC" my-leader-keymap)

;; Hooks

(defun set-my-leader-bindings ()
  "Inject leader keymap of SPC."
  (local-set-key "SPC" my-leader-keymap))
(add-hook 'magit-mode-hook 'set-my-leader-bindings)

(defun set-eglot-bindings ()
  "Inject eglot bindings."
  (keymap-set evil-motion-state-local-map "g = =" 'eglot-format-buffer)
  (keymap-set evil-motion-state-local-map "g R" 'eglot-rename))
(add-hook 'eglot-managed-mode-hook 'set-eglot-bindings)

(defun set-lsp-bindings ()
  "Inject lsp bindings."
  (keymap-set evil-motion-state-local-map "g r" 'lsp-find-references)
  (keymap-set evil-motion-state-local-map "g = =" 'lsp-format-buffer)
  (keymap-set evil-motion-state-local-map "g = r" 'lsp-format-region)
  (keymap-set evil-motion-state-local-map "g R" 'lsp-rename)
  (keymap-set evil-motion-state-local-map "g d" 'lsp-find-definition))
(add-hook 'lsp-mode-hook 'set-lsp-bindings)