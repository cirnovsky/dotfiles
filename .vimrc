" misc
syntax enable
filetype plugin indent on
set udir=~/.vim/undo udf path+=** hid noswf exrc secure is ar
set gp=git\ grep\ -n
let g:netrw_liststyle=1

" plugins
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi'
Plug '~/vim-mail'
call plug#end()

" vim-mail
let g:mail_accounts = {
  \ 'gmail': {'root': '~/Mail/gmail', 'from': 'cirnovsky <pup@guanyu.me>', 'send': 'msmtp -a gmail -t'},
  \ }
let g:mail_from = "cirnovsky <pup@guanyu.me>"

" keymaps
nmap <C-x> <cmd>ls<cr>:b<space>
nmap <C-k> <cmd>bd<cr>
nmap <C-s> :fin<space>
nmap <esc>x q:i

" lsp
so ~/.vim/coc.vim
