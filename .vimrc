" misc
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:python_indent = #{open_paren: 'shiftwidth()', continue: 'shiftwidth()', closed_paren_align_last_line: 0}
set cinoptions+=j1,(0,ws,Ws
filetype plugin indent on
sy enable
set udir=~/.vim/undo udf path+=** hid noswf exrc secure is ai ci gp=rg\ --vimgrep

" code navigation (ctags + gtags)
so ~/.vim/tags.vim

" keymaps
nmap <C-x> <cmd>ls<cr>:b<space>
nmap <C-k> <cmd>bd<cr>
nmap <C-s> :fin<space>
nmap <silent> <leader>y <cmd>let @+ = expand('%:p')<cr>

" multicursor
let g:VM_maps = {}
let g:VM_maps["Add Cursor Down"]    = '<esc>j'   " new cursor down
let g:VM_maps["Add Cursor Up"]      = '<esc>k'   " new cursor up
let g:VM_maps["Exit"] = '<C-c>'
