" misc
syntax enable
filetype plugin indent on
set udir=~/.vim/undo udf path+=** hid noswf exrc secure is
set gp=git\ grep\ -n

" plugins
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'stqqrm/bex.vim'
call plug#end()

" keymaps
nmap gb <cmd>ls<cr>:b<space>

" lsp
so ~/.vim/.coc.conf.vim

" nerdtree
let g:bex_show_hidden = 1
