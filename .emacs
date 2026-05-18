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
(setopt use-short-answers t)

(load "~/.emacs.rc/rc.el")

(global-set-key (kbd "C-c g") 'rgrep)
(global-set-key (kbd "C-c d") 'duplicate-line)
(global-set-key (kbd "C-c m") 'man)
(keymap-set minibuffer-local-completion-map "C-;" 'minibuffer-next-completion)
(keymap-set minibuffer-local-completion-map "C-'" 'minibuffer-previous-completion)
(global-auto-revert-mode 1)

(rc/require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-prev-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(use-package typescript-mode :ensure t)
(use-package markdown-mode :ensure t)
(use-package magit :ensure t)
(use-package move-text
  :ensure t
  :bind (("M-p" . move-text-up)
	 ("M-n" . move-text-down)))
(use-package uv-mode
  :ensure t
  :hook (python-mode . uv-mode-auto-activate-hook))
(use-package gruvbox-theme
  :ensure t
  :config (load-theme 'gruvbox-dark-medium 1))
(use-package xclip
  :ensure t
  :config (xclip-mode 1))

					; Org-mode
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

					; Company-mode
(rc/require 'company)
(setq company-selection-wrap-around t)
(add-hook 'after-init-hook 'global-company-mode)

					; Eglot
(add-hook 'eglot-managed-mode-hook
	  (lambda ()
	    (keymap-set eglot-mode-map "C-c e r" 'eglot-rename)))
(add-hook 'prog-mode 'eglot-ensure)

