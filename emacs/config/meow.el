;; Add kmacro bindings to meow
(use-package meow
  :custom
  (meow-use-clipboard t)
  (meow-visit-collect-min-length 2)
  (meow-keypad--self-insert-undefined nil)
  :init
  (defun meow-setup ()
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
    (meow-motion-overwrite-define-key
     '("<escape>" . ignore))
    (meow-normal-define-key
     '("0" . meow-expand-0)
     '("9" . meow-expand-9)
     '("8" . meow-expand-8)
     '("7" . meow-expand-7)
     '("6" . meow-expand-6)
     '("5" . meow-expand-5)
     '("4" . meow-expand-4)
     '("3" . meow-expand-3)
     '("2" . meow-expand-2)
     '("1" . meow-expand-1)
     '("-" . negative-argument)
     '("_" . meow-reverse)
     '("!" . meow-kmacro-lines)
     '("$" . meow-kmacro-matches)
     '("#" . meow-start-kmacro)
     '("@" . meow-end-or-call-kmacro)
     '("%" . meow-query-replace)
     '("," . meow-inner-of-thing)
     '("." . meow-bounds-of-thing)
     '("<" . beginning-of-buffer)
     '(">" . end-of-buffer)
     '("[" . meow-beginning-of-thing)
     '("]" . meow-end-of-thing)
     '("TAB" . meow-indent)
     '("a" . meow-append)
     '("A" . meow-open-below)
     '("b" . meow-back-word)
     '("B" . meow-back-symbol)
     '("c" . meow-change)
     '("d" . meow-kill)
     '("D" . meow-kill-whole-line)
     '("e" . meow-next-word)
     '("E" . meow-next-symbol)
     (cons "f" find-map)
     '("F" . consult-buffer)
     (cons "g" goto-map)
     '("G" . meow-grab)
     '("h" . meow-left)
     '("H" . meow-left-expand)
     '("i" . meow-insert)
     '("I" . meow-open-above)
     '("j" . meow-next)
     '("J" . meow-next-expand)
     '("k" . meow-prev)
     '("K" . meow-prev-expand)
     '("l" . meow-right)
     '("L" . meow-right-expand)
     '("m" . meow-join)
     '("M" . join-line)
     '("n" . meow-search)
     '("C-o" . meow-pop-marker)
     '("o" . meow-block)
     '("O" . meow-to-block)
     '("p" . meow-yank)
     '("P" . meow-yank-pop)
     '("q" . meow-cancel-selection)
     '("Q" . meow-quit)
     '("r" . meow-replace)
     (cons "s" search-map)
     '("t" . meow-find)
     '("T" . meow-swap-grab)
     '("u" . meow-undo)
     '("U" . undo-tree-redo)
     '("v" . meow-page-down)
     '("V" . meow-page-up)
     '("w" . meow-mark-word)
     '("W" . meow-mark-symbol)
     '("x" . meow-line)
     '("X" . meow-visual-line)
     '("y" . meow-save)
     '("Y" . meow-save-append)
     '("z" . meow-pop-selection)
     '("Z" . meow-sync-grab)
     '("'" . repeat)
     '("\"" . repeat-complex-command)
     '(";" . meow-comment)
     '(":" . meow-goto-line)
     '("/" . meow-visit)
     '("?" . meow-cheatsheet)
     '("<escape>" . ignore)))
  :config
  (meow-setup)
  (meow-global-mode t))