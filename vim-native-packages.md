# Vim plugins without vim-plug

Vim 8+ loads plugins natively from `~/.vim/pack/*/start/`.

Remove the `plug#begin()`, `Plug`, and `plug#end()` lines from `.vimrc`, then install plugins:

```sh
mkdir -p ~/.vim/pack/plugins/start
git clone https://github.com/tpope/vim-commentary ~/.vim/pack/plugins/start/vim-commentary
git clone https://github.com/tpope/vim-surround ~/.vim/pack/plugins/start/vim-surround
git clone https://github.com/mg979/vim-visual-multi ~/.vim/pack/plugins/start/vim-visual-multi
git clone https://github.com/vifm/vifm.vim ~/.vim/pack/plugins/start/vifm.vim
vim -N -es +'helptags ALL' +qa
```

Plugins under `start/` load automatically. Put optional plugins under `pack/plugins/opt/` and load them with:

```vim
packadd plugin-name
```

For a dotfiles repository, track plugins as submodules:

```sh
git submodule add REPOSITORY_URL .vim/pack/plugins/start/PLUGIN_NAME
git submodule update --init --recursive
git submodule update --remote --merge
```

After migrating, remove `.vim/autoload/plug.vim`.
