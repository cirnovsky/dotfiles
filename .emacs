(set-face-attribute 'default nil :height 160)
(setq global-auto-revert-non-file-buffers 1)
(setq custom-file "~/.emacs.custom.el")

(load "~/.emacs.rc/rc.el")


(global-set-key (kbd "C-c p f") 'project-find-file)
(global-set-key (kbd "C-c p g") 'rgrep)
(global-set-key (kbd "C-c d") 'duplicate-line)
(global-set-key (kbd "C-c m") 'man)
(global-auto-revert-mode 1)

(rc/require 'gruber-darker-theme)
(load-theme 'gruber-darker)

(rc/require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-prev-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
