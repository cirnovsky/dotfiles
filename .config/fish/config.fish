if status is-interactive
	# Commands to run in interactive sessions can go here
	set -gx PATH $HOME/bin $PATH
end

fish_vi_key_bindings
# alias dotfiles 'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dtf 'cd ~/.dotfiles'
alias code 'cd ~/Documents/projects/code'
alias blog 'cd ~/Documents/projects/blog'
