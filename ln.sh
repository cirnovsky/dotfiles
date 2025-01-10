#!/bin/bash

pwd=$(pwd)

shopt -s dotglob
for entry in "$pwd"/*; do
	entry_name=$(basename "$entry")
    
	echo $entry_name
	if ! grep -qx "$entry_name" .lnignore; then
		ln -s "$(realpath "$entry")" $HOME/"$entry_name"
        
		if [[ $? -eq 0 ]]; then
			echo "Linked $entry_name to $HOME/$entry_name"
		else
			echo "Failed to link $entry_name"
		fi
	fi
done
