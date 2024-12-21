if status is-interactive
	# Commands to run in interactive sessions can go here
	set -gx PATH $HOME/bin $PATH
end

alias dotfiles 'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
