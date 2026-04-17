(set-face-attribute 'default nil :height 160)
(setq ns-pop-up-frames nil)
(setq global-auto-revert-non-file-buffers 1)
(setq custom-file "~/.emacs.custom.el")
(setq create-lockfiles nil)
(setq vc-follow-symlinks t)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(tool-bar-mode -1)
(scroll-bar-mode -1)

(load "~/.emacs.rc/rc.el")

(global-set-key (kbd "C-c g") 'rgrep)
(global-set-key (kbd "C-c d") 'duplicate-line)
(global-set-key (kbd "C-c m") 'man)
(keymap-set minibuffer-local-completion-map "C-;" 'minibuffer-next-completion)
(keymap-set minibuffer-local-completion-map "C-'" 'minibuffer-previous-completion)
(global-auto-revert-mode 1)

(rc/require 'gruber-darker-theme)
(load-theme 'gruber-darker t)

(rc/require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-prev-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(rc/require 'vterm)
