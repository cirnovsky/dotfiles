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
(add-hook 'eglot-managed-mode-hook
	  (lambda ()
	    (keymap-set eglot-mode-map "C-c e r" 'eglot-rename)))
(global-auto-revert-mode 1)

(rc/require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-prev-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(rc/require 'vterm)
(rc/require 'magit)
(rc/require 'markdown-mode)

(rc/require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

(rc/require 'uv-mode)
(add-hook 'python-mode-hook #'uv-mode-auto-activate-hook)

					; Org-mode
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
