if status is-interactive
	# Commands to run in interactive sessions can go here
	set -gx PATH $HOME/bin $PATH
end

fish_vi_key_bindings
# alias dotfiles 'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dtf 'cd ~/.dotfiles'
alias cod 'cd ~/Documents/projects/code'
alias blog 'cd ~/Documents/projects/blog'
alias pj 'cd ~/Documents/projects'
set -U fish_user_paths $fish_user_paths ~/.npm-g/bin
