" Basics {{{
syntax enable
filetype plugin indent on

set ai si ci mouse=a is fo=cro re=0 nosc nocul noswapfile hid
set tags=./tags;,tags
set undodir=~/.vim/undo undofile
set foldmethod=marker foldmarker={{{,}}}

let g:apc_enable_ft = {"*":1} | let g:apc_enable_tab = 0
set cpt=.,k,w,b,t cot=menu,menuone,noselect shm+=c
" }}}

" Keymaps {{{
nmap ? :find ./**/*
nmap gb <cmd>ls<cr>:b<space>
nmap <space>r <cmd>cope<CR>:AsyncRun 
" }}}

" Plugins {{{
call plug#begin()
Plug 'skywind3000/vim-auto-popmenu'
Plug 'cirnovsky/vim-dict'
Plug 'cirnovsky/vim-gotoword'
Plug 'ludovicchabant/vim-gutentags'
Plug 'github/copilot.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-commentary'
call plug#end()
" }}}

" <copilot.vim> {{{
let g:copilot_filetypes = { '*': v:false }
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
nmap <silent> <C-L> <cmd>let b:copilot_enabled = !get(b:, 'copilot_enabled', 1)<CR><cmd>echo "Copilot: " . (b:copilot_enabled ? "On" : "Off")<CR>
" }}}
