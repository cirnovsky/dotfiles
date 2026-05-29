(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))

(set-face-attribute 'default nil :height 160)
(xterm-mouse-mode 1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq ns-pop-up-frames nil)
(setq global-auto-revert-non-file-buffers 1)
(setq custom-file "~/.emacs.custom.el")
(setq create-lockfiles nil)
(setq vc-follow-symlinks t)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq use-package-always-ensure t)
(setopt use-short-answers t)

(global-set-key (kbd "C-c g") 'rgrep)
(global-set-key (kbd "C-c d") 'duplicate-line)
(global-set-key (kbd "C-c m") 'man)
(global-set-key (kbd "C-c r") 'recompile)
(keymap-set minibuffer-local-completion-map "C-;" 'minibuffer-next-completion)
(keymap-set minibuffer-local-completion-map "C-'" 'minibuffer-previous-completion)
(global-auto-revert-mode 1)

(use-package multiple-cursors
  :custom (mc/always-run-for-all t)
  :bind (("C->" . mc/mark-next-like-this)
	 ("C-<" . mc/mark-prev-like-this)
	 ("C-c C-<" . mc/mark-all-like-this)))

(use-package company
  :custom (company-selection-wrap-around t)
  :hook (after-init-hook . global-company-mode))

(use-package typescript-mode)
(use-package markdown-mode)
(use-package magit)

(use-package move-text
  :bind (("M-p" . move-text-up)
	 ("M-n" . move-text-down)))
(use-package uv-mode
  :hook (python-mode . uv-mode-auto-activate-hook))
(use-package gruvbox-theme
  :config (load-theme 'gruvbox-dark-medium 1))
(use-package xclip
  :config (xclip-mode 1))
(use-package typescript-mode)
(use-package markdown-mode)
(use-package magit)
					; Org-mode
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)


					; Eglot
(add-hook 'eglot-managed-mode-hook
	  (lambda ()
	    (keymap-set eglot-mode-map "C-c e r" 'eglot-rename)))
(add-hook 'prog-mode-hook 'eglot-ensure)

