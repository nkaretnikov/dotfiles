(defconst nix-site-lisp
  "/var/run/current-system/sw/share/emacs/site-lisp/")

(add-to-list 'load-path nix-site-lisp)

;;; ELPA.
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")))

;;; Font.
(set-face-attribute 'default nil :font "DejaVu Sans Mono-14")

;;; Color theme.
(add-to-list 'custom-theme-load-path "/var/run/current-system/sw/share/emacs/site-lisp/")
(load-theme 'solarized-dark t)

;;; No tabs.
(setq-default ident-tabs-mode nil)
(setq-default tab-width 4)

;;; Highlight matching parens.
;; XXX: Makes proofgeneral return the following error when I'm typing
;; the dot to end an expression, like [Check 2.]:
;; Error running timer `show-paren-function': (wrong-type-argument characterp nil)
;; (show-paren-mode 1)
;; (setq show-paren-delay 0)

;;; Windows-like copy/paste using X clipboard.
(setq x-select-enable-clipboard t)

;;; Hidden scroll.
(set-scroll-bar-mode 'nil)

;;; Hidden toolbar.
(tool-bar-mode -1)

;;; Hidden menubar.
(menu-bar-mode -1)

;;; Disable blinking cursor.
(blink-cursor-mode 0)

;;; align-regexp, mainly for Haskell.
(global-set-key (kbd "C-x a r") 'align-regexp)

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;;; Show trailing whitespace, long lines, etc.
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(setq whitespace-line-column 79)
(global-whitespace-mode t)

;;; ERC.
(require 'erc)
;; (setq erc-auto-reconnect nil)
;; Do not open a new buffer when someone sends you a PM.
(setq erc-auto-query 'bury)

;;; TLS.
(require 'tls)
(setq tls-program '("gnutls-cli --strict-tofu --priority=PFS -p %p %h"))

;;; Ispell.
(setq-default ispell-program-name "aspell")
(setq ispell-dictionary "american")

;;; Flyspell.
;; XXX: Make it work in the Lisp mode and for strings in the shell.
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;;; Haskell mode.
(require 'haskell-mode-autoloads)
(add-to-list 'Info-default-directory-list nix-site-lisp)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;;; Proof General, for Coq.
(load-file (concat nix-site-lisp "ProofGeneral/generic/proof-site.el"))
