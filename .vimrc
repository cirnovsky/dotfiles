" misc
syntax enable
filetype plugin indent on
set udir=~/.vim/undo udf path+=** hid noswf exrc secure is
set gp=git\ grep\ -n
let g:netrw_liststyle=1
colo habamax

" plugins
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi'
call plug#end()

" keymaps
nmap <C-x> <cmd>ls<cr>:b<space>
nmap <C-k> <cmd>bd<cr>
nmap <C-s> :fin<space>
function! CopyPath()
    if &filetype ==# 'netrw' | let fname = matchstr(getline('.'), '^\S\+') | let @+ = b:netrw_curdir . '/' . fname
    else | let @+ = expand('%:p') | endif
endfunction
nmap <silent> <leader>y :call CopyPath()<CR>

" lsp
so ~/.vim/coc.vim

" multicursor
let g:VM_maps = {}
let g:VM_maps["Add Cursor Down"]    = '<esc>j'   " new cursor down
let g:VM_maps["Add Cursor Up"]      = '<esc>k'   " new cursor up
let g:VM_maps["Exit"] = '<C-c>'
