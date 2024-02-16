;;-*- lexical-binding: t; -*-

;; Find file and open in other window

;; TODO: Move all gui settings to separate load-file.
;;       And then load file as first package.
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f") gcs-done)))

(setq apropos-do-all t)
(setq compilation-always-kill t)
(setq compilation-scroll-output t)
(setq compilation-max-output-line-length 200)
(setq confirm-kill-emacs 'y-or-n-p)
(setq create-lockfiles nil)
(setq eldoc-echo-area-use-multiline-p nil)
(setq gc-cons-percentage 0.1)
(setq gc-cons-threshold (* 16 1000 1000)) ;; 16 MB
(setq global-auto-revert-non-file-buffers t)
(setq hippie-expand-verbose t)
(setq inhibit-startup-message t)
(setq make-backup-files nil)
(setq read-process-output-max (* 1024 1024))
(setq require-final-newline t)
(setq tab-always-indent 'complete)
(setq ring-bell-function 'ignore)
(setq use-dialog-box nil)
(setq history-length 1000)
(setq history-delete-duplicates t)
(setq-default cursor-type 'bar)
(setq-default display-fill-column-indicator-column 90)
(setq-default display-line-numbers-type nil)
(setq-default fill-column 120)
(setq-default frame-title-format '("%f"))
(setq-default indent-tabs-mode nil)

(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-line
        try-expand-list
        try-complete-lisp-symbol-partially
        try-complete-file-name-partially
        try-complete-lisp-symbol
        try-complete-file-name
        try-expand-dabbrev-from-kill))

(add-hook 'before-save-hook #'whitespace-cleanup)
(add-hook 'compilation-filter #'ansi-color-compilation-filter)

(add-to-list 'default-frame-alist '(height . 60))
(add-to-list 'default-frame-alist '(width . 130))

(set-face-font 'default "-*-Hack Nerd Font-normal-normal-normal-*-14-*-*-*-p-0-iso10646-1")

(column-number-mode 1)
(delete-selection-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(global-auto-revert-mode t)
(menu-bar-mode -1)
(recentf-mode 1)
(save-place-mode 1)
(savehist-mode 1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(window-divider-mode 1)
(global-hl-line-mode 1)
(desktop-save-mode -1)

(setq org-directory (expand-file-name "org" user-emacs-directory))
(unless (file-exists-p org-directory)
  (make-directory org-directory))

;; Install grammars
;; (mapc #'treesit-install-language-grammar (mapcar #'car treesit-language-source-alist)))
(with-eval-after-load 'treesit
  (setq treesit-language-source-alist
        '((bash "https://github.com/tree-sitter/tree-sitter-bash")
          (cmake "https://github.com/uyha/tree-sitter-cmake")
          (css "https://github.com/tree-sitter/tree-sitter-css")
          (elisp "https://github.com/Wilfred/tree-sitter-elisp")
          (go "https://github.com/tree-sitter/tree-sitter-go")
          (haskell "https://github.com/tree-sitter/haskell-tree-sitter")
          (html "https://github.com/tree-sitter/tree-sitter-html")
          (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
          (json "https://github.com/tree-sitter/tree-sitter-json")
          (make "https://github.com/alemuller/tree-sitter-make")
          (markdown "https://github.com/ikatyang/tree-sitter-markdown")
          (python "https://github.com/tree-sitter/tree-sitter-python")
          (toml "https://github.com/tree-sitter/tree-sitter-toml")
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
          (yaml "https://github.com/ikatyang/tree-sitter-yaml")
          (erlang "https://github.com/WhatsApp/tree-sitter-erlang")
          (elixir "https://github.com/elixir-lang/tree-sitter-elixir")
          (heex "https://github.com/phoenixframework/tree-sitter-heex")
          (ruby "https://github.com/tree-sitter/tree-sitter-ruby")
          (scheme "https://github.com/6cdh/tree-sitter-scheme")
          (sql "https://github.com/DerekStride/tree-sitter-sql"))))


;; COMMANDS

(defun my/go-to-config-file ()
  "Go to my config file."
  (interactive)
  (find-file (expand-file-name "init.el" user-emacs-directory)))

(defun my/project-copy-relative-file-name ()
  "Copy file path of current buffer relative to project directory."
  (interactive)
  (kill-new (my/project-relative-file-name)))

(defun rails-compile ()
  (interactive)
  (setq compile-command (my/rails-dwim-compile-command))
  (call-interactively #'project-compile))


;;;; HELPERS

(defun my/project-directory ()
  "Current project directory."
  (project-root (project-current)))

(defun my/project-relative-file-name ()
  "Relative project path to file."
  (file-relative-name (buffer-file-name) (my/project-directory)))

(defun my/project-expand (file-name)
  (f-join (my/project-directory) file-name))

(defun my/rails-buffer-test-file-p ()
  (string-match-p "_test.rb\\'" (buffer-file-name)))

(defun my/rails-buffer-ruby-file-p ()
  (string-match-p ".rb\\'" (buffer-file-name)))

(defun my/rails-test-file-compile-command ()
  (let ((linum (number-to-string (line-number-at-pos)))
        (file-name (my/project-relative-file-name)))
    (if (< (line-number-at-pos) 5)
        (string-join (list "rails t " file-name))
      (string-join (list "rails t " (s-concat file-name ":" linum))))))

(defun my/rails-test-file-exists-p ()
  (and (my/rails-buffer-ruby-file-p)
       (file-exists-p (my/project-expand (my/rails-generate-test-file-name)))))

(defun my/rails-generate-test-file-name ()
  (let* ((file-name (my/project-relative-file-name))
         (test-file-name (concat (f-base file-name) "_test.rb"))
         (folder-split (cdr (s-split "/" (f-dirname file-name)))))
    (f-join "test" (apply 'f-join  folder-split) test-file-name)))

(defun my/rails-dwim-compile-command ()
  (cond ((my/rails-buffer-test-file-p)
         (my/rails-test-file-compile-command))
        (t compile-command)))


;; INSTALL PACKAGE MANAGER
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq straight-use-package-by-default t)


;;;; PACKAGES

(use-package evil
  :demand t
  :init
  (defun my/set-eglot-bindings ()
    "Inject eglot bindings."
    (keymap-set evil-normal-state-local-map "g = =" 'eglot-format-buffer)
    (keymap-set evil-normal-state-local-map "g R" 'eglot-rename))
  (defun my/set-lsp-bindings ()
    "Inject lsp bindings."
    (keymap-set evil-normal-state-local-map "g = =" 'lsp-format-buffer)
    (keymap-set evil-normal-state-local-map "g r" 'lsp-find-references)
    (keymap-set evil-normal-state-local-map "g = r" 'lsp-format-region)
    (keymap-set evil-normal-state-local-map "g R" 'lsp-rename)
    (keymap-set evil-normal-state-local-map "g d" 'lsp-find-definition)
    (keymap-set evil-normal-state-local-map "K" 'eldoc))
  (defun my/set-ruby-bindings ()
    "Inject ruby specific keybindings"
    (keymap-set evil-normal-state-local-map "SPC c" 'rails-compile))
  (setq evil-disable-insert-state-bindings t)
  (setq evil-ex-search-persistent-highlight nil)
  (setq evil-insert-state-cursor 'bar)
  (setq evil-motion-state-cursor 'hollow)
  (setq evil-normal-state-cursor 'box)
  (setq evil-search-module 'evil-search)
  (setq evil-undo-system 'undo-tree)
  (setq evil-visual-state-cursor 'hollow)
  (setq evil-want-C-u-scroll nil)
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-w-in-emacs-state t)
  :bind (:map evil-normal-state-map
              ("SPC C-SPC" . consult-recent-file)
              ("SPC SPC" . project-find-file)

              ("SPC b" . magit-blame-addition)

              ("SPC c" . compile)
              ("SPC C" . recompile)

              ("SPC f" . consult-project-buffer)
              ("SPC F" . consult-buffer)

              ("SPC g" . magit-status)
              ("SPC G" . magit-file-dispatch)

              ("SPC i" . consult-imenu)
              ("SPC I" . consult-line)

              ("SPC j" . avy-goto-char-2)
              ("SPC J" . avy-goto-char-timer)

              ("SPC l" . magit-log-buffer-file)
              ("SPC L" . magit-diff-buffer-file)

              ("SPC m" . consult-bookmark)
              ("SPC M" . consult-register)

              ("SPC n" . consult-notes)
              ("SPC N" . consult-notes-search-in-all-notes)

              ("SPC p" . project-switch-project)

              ("SPC R" . restart-emacs)

              ("SPC s" . consult-ripgrep)
              ("SPC S" . rg-project)

              ("SPC t" . project-vterm)

              ("SPC y" . my/project-copy-relative-file-name)
              ("SPC Y" . git-link)

              ("SPC ;" . scratch-buffer)
              ("SPC :" . denote)

              ("SPC ." . my/go-to-config-file))
  :hook
  (eglot-managed-mode . my/set-eglot-bindings)
  (lsp-managed-mode . my/set-lsp-bindings)
  (ruby-ts-mode . my/set-ruby-bindings)
  :config
  (evil-select-search-module 'evil-search-module 'evil-search)
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package undo-tree
  :config
  (setq undo-tree-visualizer-timestamps t)
  (let ((undo-tree-history-directory (expand-file-name "undo-tree-history" user-emacs-directory)))
    (unless (file-exists-p undo-tree-history-directory)
      (make-directory undo-tree-history-directory))
    (setq undo-tree-history-directory-alist (list (cons "."  undo-tree-history-directory))))
  (global-undo-tree-mode 1))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :custom
  (exec-path-from-shell-warn-duration-millis 1000)
  :config
  (dolist (var '("SSH_AUTH_SOCK" "SSH_AGENT_PID" "GPG_AGENT_INFO" "GOPATH"
                 "LANG" "LC_CTYPE" "NIX_SSL_CERT_FILE" "NIX_PATH"))
    (add-to-list 'exec-path-from-shell-variables var))
  (exec-path-from-shell-initialize))

(use-package rg
  :defer t)

(use-package avy
  :defer t
  :bind (("C-c j" . avy-goto-char-timer)))

(use-package ace-window
  :defer t
  :bind ([remap other-window] . ace-window))

(use-package xclip
  :unless (display-graphic-p)
  :config
  (xclip-mode 1))

(use-package vertico
  :config
  (vertico-mode 1))

(use-package marginalia
  :config
  (marginalia-mode 1))

(use-package embark
  :bind
  (("C-c e" . embark-act)
   ("C-c E" . embark-export)))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package consult
  :defer t)

(use-package denote
  :defer t
  :init
  (setq denote-directory (expand-file-name "denote" user-emacs-directory))
  :config
  (unless (file-exists-p denote-directory)
    (make-directory denote-directory)))

(use-package consult-notes
  :after denote
  :config
  (consult-notes-denote-mode))

(use-package vterm
  :defer t
  :init
  (defun project-vterm ()
    (interactive)
    (let ((default-directory (or (and (project-current) (my/project-directory)) default-directory)))
      (call-interactively #'vterm)))
  (add-to-list 'display-buffer-alist
               '("\\*vterm\\*"
                 (display-buffer-at-bottom)
                 (window-height . 12)
                 (dedicated . t)))
  :bind (:map vterm-mode-map
              ("C-w" . evil-window-map))
  :custom
  (vterm-copy-mode-remove-fake-newlines t)
  (vterm-max-scrollback 10000))

(use-package magit
  :defer t)

(use-package git-link
  :defer t)

;; https://www.flycheck.org/en/latest/
(use-package flycheck
  :defer t
  :custom
  (flycheck-indication-mode 'right-fringe))

;; https://joaotavora.github.io/yasnippet/index.html
(use-package yasnippet
  :init
  (setq yas-snippet-dirs (list (expand-file-name "snippets" user-emacs-directory)))
  :config
  (yas-global-mode 1))

;; https://emacs-lsp.github.io/lsp-mode/
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :custom
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-completion-provider :none) ;; we use corfu
  (lsp-signature-auto-activate '(:on-trigger-char :on-server-request))
  (lsp-signature-render-documentation t)
  (lsp-eldoc-render-all t)
  :config
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]_build\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]deps\\'")
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]erl_crash.dump\\'"))

(use-package elm-mode
  :defer t
  :hook
  (elm-mode . eglot-ensure))

(use-package ruby-ts-mode
  :defer t
  :init
  (add-to-list 'major-mode-remap-alist '(ruby-mode . ruby-ts-mode))
  :hook
  (ruby-ts-mode . display-fill-column-indicator-mode)
  (ruby-ts-mode . display-line-numbers-mode)
  (ruby-ts-mode . lsp-deferred))

(use-package erlang
  :defer t
  :straight nil
  :load-path "/opt/homebrew/lib/erlang/lib/tools-3.6/emacs/"
  :init
  (setq erlang-root-dir "/opt/homebrew/lib/erlang")
  (add-to-list 'exec-path "/opt/homebrew/lib/erlang/bin")
  :hook
  (erlang-mode . lsp-deferred)
  :mode
  (("\\.erl?$" . erlang-mode)
   ("rebar\\.config$" . erlang-mode)
   ("relx\\.config$" . erlang-mode)
   ("sys\\.config\\.src$" . erlang-mode)
   ("sys\\.config$" . erlang-mode)
   ("\\.config\\.src?$" . erlang-mode)
   ("\\.config\\.script?$" . erlang-mode)
   ("\\.hrl?$" . erlang-mode)
   ("\\.app?$" . erlang-mode)
   ("\\.app.src?$" . erlang-mode)
   ("\\Emakefile" . erlang-mode))
  :config
  (require 'erlang-start))

(use-package lsp-haskell
  :defer t
  :hook
  (haskell-mode . lsp-deferred)
  (haskell-mode . display-line-numbers-mode)
  (haskell-cabal-mode . display-line-numbers-mode)
  (haskell-literal-mode . lsp-deferred))

(use-package elixir-ts-mode
  :defer t
  :init
  (add-to-list 'exec-path "~/.bin/elixir-ls")
  :custom
  (lsp-elixir-suggest-specs nil)
  :hook
  (elixir-ts-mode . lsp-deferred)
  (heex-ts-mode . lsp-deferred)
  (elixir-ts-mode . display-line-numbers-mode)
  (heex-ts-mode . display-line-numbers-mode))

(use-package yaml-ts-mode
  :defer t
  :mode "\\(\\.yaml\\|.yml\\)\\'"
  :hook
  (yaml-ts-mode . lsp-deferred))

(use-package sqlformat
  :commands (sqlformat)
  :config
  (setq sqlformat-command 'pgformatter)
  (setq sqlformat-args '("-s2" "-g")))

(use-package geiser-guile
  :commands (geiser-mode))

;; http://pub.gajendra.net/src/paredit-refcard.pdf
(use-package paredit
  :disabled t
  :hook
  (scheme-mode . enable-paredit-mode)
  (emacs-lisp-mode . enable-paredit-mode))

(use-package corfu
  ;; Corfu enhances in-buffer completion with a small completion popup.
  :straight (corfu :files (:defaults "extensions/*.el") :includes (corfu-echo))
  :custom
  (corfu-cycle t) ; Allows cycling through candidates
  (corfu-auto t) ; Enable auto completion
  (corfu-auto-prefix 2) ; Enable auto completion
  (corfu-auto-delay 0.2) ; Enable auto completion
  (corfu-echo-delay '(1 . 0.5))
  (corfu-separator ?\s)
  :init
  (global-corfu-mode 1)
  (corfu-echo-mode)
  :config
  (keymap-set corfu-map "RET" nil)) ;; Prevent enter from auto-completing

(use-package corfu-terminal
  :unless (display-graphic-p)
  :after corfu
  :config
  (corfu-terminal-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package cape
  ;; Cape provides Completion At Point Extensions
  :after corfu
  :custom
  (completion-at-point-functions
   '(cape-dabbrev
     cape-keyword
     cape-dict
     cape-file)))

(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-right-bottom))

(use-package indent-guide
  :config
  (indent-guide-global-mode))

(use-package gruvbox-theme)
(use-package ef-themes)

(use-package modus-themes
  :config
  ;; https://protesilaos.com/emacs/modus-themes
  (when (display-graphic-p)
    (setq modus-vivendi-tritanopia-palette-overrides
          '((fringe unspecified)
            (bg-line-number-active unspecified)
            (bg-line-number-inactive unspecified)
            (border-mode-line-active unspecified)
            (border-mode-line-inactive unspecified)
            (fg-main "#d0d0d0")
            (bg-main "#14191e"))))
  (load-theme 'modus-vivendi-tritanopia t))

(use-package doom-modeline
  :custom
  (doom-modeline-icon nil)
  (doom-modeline-minor-modes nil)
  (doom-modeline-indent-info nil)
  (doom-modeline-buffer-encoding nil)
  (doom-modeline-vcs-max-length 20)
  (doom-modeline-display-misc-in-all-mode-lines nil)
  (doom-modeline-env-version nil)
  :init
  (doom-modeline-mode 1))


;; GLOBAL KEYMAP

(keymap-global-set "C-x h" #'previous-buffer)
(keymap-global-set "C-x l" #'next-buffer)
(keymap-global-set "C-O" #'previous-buffer)
(keymap-global-set "C-I" #'next-buffer)
(keymap-global-set "M-/" #'hippie-expand)


;; CUSTOM set and load file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)
