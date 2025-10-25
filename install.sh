#!/usr/bin/env bash
# Symlink all dotfiles in this directory to $HOME
# except install.sh itself and .git directory

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup"

mkdir -p "$BACKUP_DIR"

echo "📁 Dotfiles directory: $DOTFILES_DIR"
echo "💾 Backup directory:   $BACKUP_DIR"
echo

for file in "$DOTFILES_DIR"/.* "$DOTFILES_DIR"/*; do
    base="$(basename "$file")"

    # Skip current dir, parent dir, and installer itself
    [[ "$base" == "." || "$base" == ".." || "$base" == "install.sh" || "$base" == ".git" ]] && continue

    target="$HOME/$base"

    # Backup existing file if it’s not a symlink to the same file
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "🔄 Backing up existing $base → $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/"
    fi

    # Remove old symlink if it exists
    if [ -L "$target" ]; then
        echo "🗑 Removing old symlink $target"
        rm "$target"
    fi

    echo "🔗 Linking $target → $file"
    ln -s "$file" "$target"
done

echo
echo "✅ All dotfiles linked successfully!"
