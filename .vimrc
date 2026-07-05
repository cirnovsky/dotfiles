" misc
syntax enable
filetype plugin indent on
set udir=~/.vim/undo udf path+=** hid noswf exrc secure is
set gp=git\ grep\ -n
let g:netrw_liststyle=1

" plugins
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'stqqrm/bex.vim'
Plug '~/vim-mail'
call plug#end()

" vim-mail
let g:mail_accounts = {
  \ 'gmail': {'root': '~/Mail/gmail', 'from': 'cirnovsky <pup@guanyu.me>', 'send': 'msmtp -a gmail -t'},
  \ }
let g:mail_from = "cirnovsky <pup@guanyu.me>"

" keymaps
nmap gb <cmd>ls<cr>:b<space>

" lsp
so ~/.vim/.coc.conf.vim

" bex
let g:bex_show_hidden = 1
