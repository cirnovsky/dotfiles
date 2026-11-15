" misc
let g:vifm_replace_netrw = 1
let g:loaded_netrwPlugin = 1
let g:python_indent = #{open_paren: 'shiftwidth()', continue: 'shiftwidth()', closed_paren_align_last_line: 0}
set cinoptions+=j1,(0,ws,Ws
filetype plugin indent on
sy enable
set udir=~/.vim/undo udf path+=** hid noswf exrc secure is ai ci gp=rg\ --vimgrep
packadd comment

" code navigation (ctags + gtags)
so ~/.vim/tags.vim

" keymaps
nnoremap <C-x> <cmd>ls<cr>:b<space>
nnoremap <C-k> <cmd>bd<cr>
nnoremap <C-s> :fin<space>
nnoremap <silent> <leader>y <cmd>let @+ = expand('%:p')<cr>
