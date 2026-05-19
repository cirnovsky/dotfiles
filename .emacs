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

(global-set-key (kbd "C-c g") 'rgrep)
(global-set-key (kbd "C-c d") 'duplicate-line)
(global-set-key (kbd "C-c m") 'man)
(keymap-set minibuffer-local-completion-map "C-;" 'minibuffer-next-completion)
(keymap-set minibuffer-local-completion-map "C-'" 'minibuffer-previous-completion)
(global-auto-revert-mode 1)

(use-package multiple-cursors
  :ensure t
  :custom (mc/always-run-for-all t)
  :bind (("C->" . mc/mark-next-like-this)
	 ("C-<" . mc/mark-prev-like-this)
	 ("C-c C-<" . mc/mark-all-like-this)))

(use-package company
  :ensure t
  :custom (company-selection-wrap-around t)
  :hook (after-init-hook . global-company-mode))

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


					; Eglot
(add-hook 'eglot-managed-mode-hook
	  (lambda ()
	    (keymap-set eglot-mode-map "C-c e r" 'eglot-rename)))
(add-hook 'prog-mode 'eglot-ensure)

