(package-initialize)

;; TODO Fix github / issues on gui
;; TODO treemacs https://github.com/Alexander-Miller/treemacs
;; TODO lsp-treemacs https://github.com/emacs-lsp/lsp-treemacs/tree/master

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("elpa" . "https://elpa.gnu.org/packages/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))

(setq use-package-always-ensure t)

(use-package emacs
  :hook
  (before-save . delete-trailing-whitespace)
  :config
  (set-face-font 'default "-*-Hack Nerd Font-normal-normal-normal-*-13-*-*-*-p-0-iso10646-1")
  (add-to-list 'default-frame-alist '(height . 60))
  (add-to-list 'default-frame-alist '(width . 120))

  (setq-default
   cursor-type 'bar
   display-line-numbers 'relative
   frame-title-format '("%b")
   truncate-lines nil
   indent-tabs-mode nil
   display-fill-column-indicator-column 80)

  (setq
   confirm-kill-emacs 'y-or-n-p
   require-final-newline t
   apropos-do-all t
   create-lockfiles nil
   global-auto-revert-non-file-buffers t
   inhibit-startup-message t
   initial-scratch-message ""
   make-backup-files nil
   read-process-output-max (* 1024 1024) ;; 1mb
   ring-bell-function 'ignore
   vc-follow-symlinks t)

  (fido-vertical-mode 1)
  (delete-selection-mode 1)
  (fset 'yes-or-no-p 'y-or-n-p)
  (global-auto-revert-mode t)
  (menu-bar-mode -1)
  (recentf-mode 1)
  (savehist-mode 1)
  (save-place-mode 1)
  (scroll-bar-mode -1)
  (show-paren-mode 1)
  (tool-bar-mode -1))

(use-package general
  :config
  (general-define-key
   "<escape>" '(keyboard-escape-quit :wk "Quit")
   "M-/" '(hippie-expand :wk "Autocomplete"))

  (general-create-definer rune/leader-key-def
    :keymaps '(normal insert visual emacs)
    :prefix "SPC")

  (rune/leader-key-def 'normal 'override
    "." '(find-file :wk "Find file")

    "f" '(:ignore t :wk "File")

    "c" '(:ignore t :wk "Code")
    "c c" '(my/go-to-config-file :wk "Open config")
    "c C" '(my/reload-configs :wk "Reload config")
    "c x" '(compile :wk "Compile")
    "c r" '(recompile :wk "Recompile")
    "c f" '(lsp-format-buffer :wk "Format code")

    "h" '(:ignore t :wk "Help")
    "h v" 'describe-variable
    "h f" 'describe-function
    "h k" 'describe-key
    "h a" 'apropos-documentation
    "h m" 'describe-mode
    "h x" 'describe-command))


(use-package evil
  :demand t
  :init
  ;; https://evil.readthedocs.io/en/latest/settings.html?highlight=evil-want#settings
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-u-delete t)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-shift-width 2)
  (setq evil-search-module 'evil-search)
  (setq evil-insert-state-cursor 'bar)
  (setq evil-normal-state-cursor 'box)
  (setq evil-motion-state-cursor 'hollow)
  (setq evil-visual-state-cursor 'hollow)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package lsp-mode
  :init
  (rune/leader-key-def 'normal 'override
    :keymaps 'lsp-mode-map
    "l" '(:ignore t :wk "LSP")
    "l d" 'lsp-find-definition
    "l r" 'lsp-find-references
    "l f" 'lsp-format-buffer)
  :hook
  (lsp-mode . lsp-enable-which-key-integration)
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-headerline-breadcrumb-enable nil))

(use-package company
  :config (general-define-key
   :keymaps 'company-active-map
   "TAB" 'company-complete-common-or-cycle
   "C-l" 'company-complete-selection
   "RET" nil ;; terminal mode
   "<return>" nil) ;; window mode

  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0)

  (global-company-mode 1))

(use-package flycheck
  :config
  (rune/leader-key-def 'normal 'override
    :keymaps 'flycheck-mode-map
    "x" '(:ignore t :wk "Flycheck")
    "x t" '(flycheck-mode :wk "Toggle flycheck")
    "x T" '(global-flycheck-mode :wk "Toggle global flycheck")
    "x l" '(flycheck-list-errors :wk "List errors"))
  (global-flycheck-mode))

(use-package ruby-mode
  :hook
  (ruby-mode . lsp-deferred)
  (ruby-mode . display-fill-column-indicator-mode))

(use-package projectile
  :config
  (defun my/copy-relative-file-name ()
    "Copy file path of current buffer relative to project directory."
    (interactive)
    (kill-new
     (file-relative-name (buffer-file-name) (projectile-project-root))))
  (setq projectile-completion-system 'default)
  (setq projectile-project-search-path '("~/workspace/"))
  (projectile-mode 1)
  (rune/leader-key-def 'normal 'override
    ;; "p" 'projectile-command-map
    "SPC" '(projectile-find-file :wk "Find project file")
    "f ." '(dired-jump :wk "Dired")
    "f f" '(find-file :wk "Find file")
    "f d" '(projectile-find-dir :wk "Find project dir")
    "f r" '(projectile-recentf :wk "Find recent file")
    "f s" '(projectile-ripgrep :wk "Word search")
    "f t" '(projectile-find-test-file :wk "Find test")
    "f p" '(projectile-switch-project :wk "Switch project")
    "f b" '(projectile-switch-to-buffer :wk "Find buffer")
    "f y" '(my/copy-relative-file-name :wk "Copy relative filename")
    "f B" '(projectile-ibuffer :wk "Ibuffer")))

(use-package ripgrep)

(use-package which-key
  :init
  (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(when (memq window-system '(mac ns))
  (use-package exec-path-from-shell
    :config
    (dolist (var '("SSH_AUTH_SOCK" "SSH_AGENT_PID" "GPG_AGENT_INFO" "LANG" "LC_CTYPE" "NIX_SSL_CERT_FILE" "NIX_PATH"))
      (add-to-list 'exec-path-from-shell-variables var))
    (exec-path-from-shell-initialize)))

(use-package magit
  :config
  (rune/leader-key-def 'normal 'override
    "g" '(:ignore t :wk "Git")
    "g g" '(magit-status :wk "Git status")
    "g B" '(magit-blame-addition :wk "Show blame")
    "g b" '(magit-blame :wk "Git blame")))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold nil)
  (setq doom-themes-enable-italic nil)
  (load-theme 'doom-rouge t))

(use-package doom-modeline
  :config
  (setq doom-modeline-icon nil)
  (setq doom-modeline-minor-modes nil)
  (setq doom-modeline-indent-info nil)
  (setq doom-modeline-buffer-encoding nil)
  (setq doom-modeline-vcs-max-length 20)
  (setq doom-modeline-display-misc-in-all-mode-lines nil)
  (setq doom-modeline-env-version nil)
  (doom-modeline-mode 1))

(use-package xclip
  :unless window-system
  :config
  (xclip-mode 1))

(use-package yaml-mode)

(use-package elixir-mode)

(use-package tree-sitter
  :hook
  (tree-sitter-after-on . tree-sitter-hl-mode)
  :config
  (global-tree-sitter-mode 1))

(use-package tree-sitter-langs
  :after tree-sitter)
