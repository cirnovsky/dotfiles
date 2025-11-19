" Basic Setup {{{
syntax enable
filetype plugin indent on
set ai
set si
set ci
set mouse=a
set incsearch
set formatoptions=cro
set regexpengine=1
set noshowcmd
set nocursorline
set noswapfile

set undodir=~/.vim/undo
set undofile

set foldmethod=marker
set foldmarker={{{,}}}
nmap <space><space> za
" }}}

" Auto-Completion Setup {{{
set tags=./tags;,tags
nmap <silent> <C-]> <C-]>
nmap <silent> <C-t> <C-t>
" }}}

" Navigation Setup {{{
nmap ? :find ./**/*

nmap <C-d> <C-d>zz
nmap <C-u> <C-u>zz

nmap gn :bn!<CR>
nmap gp :bp!<CR>
nmap gw :bd<CR>

nmap gk :GotoWord<CR>
" }}}

" Plugin Installation {{{
call plug#begin()
Plug 'skywind3000/vim-auto-popmenu'
Plug 'cirnovsky/vim-dict'
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'cirnovsky/vim-gotoword'
call plug#end()
" }}}

" <vim-auto-popmenu> {{{
" 设定需要生效的文件类型，如果是 "*" 的话，代表所有类型
let g:apc_enable_ft = {"*":1}

" 设定从字典文件以及当前打开的文件里收集补全单词，详情看 ':help cpt'
set cpt=.,k,w,b,t

" 不要自动选中第一个选项。
set completeopt=menu,menuone,noselect

" 禁止在下方显示一些啰嗦的提示
set shortmess+=c
" }}}

" <vim-airline> {{{
let g:airline#extensions#tabline#enabled = 1
" }}}

autocmd FileType cpp nmap <C-k> :w<CR>:!ccr % in<CR>
autocmd FileType python nmap <C-k> :w<CR>:!python3 % < in<CR>
