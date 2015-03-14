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
(erc-spelling-mode 1)
;; 'whitespace-mode' removes colors and other styles, so disable it.
(setq whitespace-global-modes '(not erc-mode))
;; (setq erc-auto-reconnect nil)
;; Do not open a new buffer when someone sends you a PM.
(setq erc-auto-query 'bury)

(setq erc-autoaway-idle-seconds 600)
(setq erc-autoaway-use-emacs-idle t)

(setq erc-autojoin-channels-alist
      '(("freenode.net" "#nixos" "#haskell" "#ghc" "#yesod"
         "#coq" "#snowdrift" "#replicant" "#libreboot")))
;; XXX: Doesn't work.
;; (setq erc-log-channels-directory "~/.erc/logs/")
;; (setq erc-save-buffer-on-part t)
;; ;; Auto-saving log files on Emacs exit.
;; ;; http://www.emacswiki.org/emacs/ErcLogging
;; (defadvice save-buffers-kill-emacs
;;  (before save-logs (arg) activate)
;;  (save-some-buffers t (lambda () (when (eq major-mode 'erc-mode) t))))

;; XXX: Disabled until logging works.
;; ;; Truncate buffers down to 30000 characters.
;; ;; http://www.emacswiki.org/emacs/ErcTruncation
;; (setq erc-max-buffer-size 30000)
;; (add-hook 'erc-insert-post-hookd 'erc-truncate-buffer)
;; (setq erc-truncate-buffer-on-save t)

;;; TLS.
(require 'tls)
;; Disable 'net/gnutls.el', so GNUtls can be run with the options I
;; need.
;; https://blogs.fsfe.org/jens.lechtenboerger/2014/03/23/certificate-pinning-for-gnu-emacs/
(if (fboundp 'gnutls-available-p)
    (fmakunbound 'gnutls-available-p))
(setq tls-program '("gnutls-cli --strict-tofu --priority=PFS -p %p %h"))

;;; Auto complete.
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)
(ac-flyspell-workaround)				; work nicely with flyspell
(setq ac-auto-start 2)
(setq ac-ignore-case nil)

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

;;; Enable 'erase-buffer'.
(put 'erase-buffer 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   (quote
	((haskell-indentation-where-post-offset . 2)
	 (haskell-indentation-where-pre-offset . 2)
	 (haskell-indentation-ifte-offset . 4)
	 (haskell-indentation-left-offset . 4)
	 (haskell-indentation-starter-offset . 1)
	 (haskell-indentation-layout-offset . 4)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coq-cheat-face ((t (:background "darkred"))))
 '(coq-solve-tactics-face ((t (:foreground "brown2"))))
 '(proof-eager-annotation-face ((t nil)))
 '(proof-error-face ((t nil)))
 '(proof-locked-face ((t (:background "#2f3f4f"))))
 '(proof-queue-face ((t (:background "purple4"))))
 '(proof-tactics-name-face ((t (:foreground "#6c71c4"))))
 '(proof-warning-face ((t (:background "brown4")))))
(put 'upcase-region 'disabled nil)
