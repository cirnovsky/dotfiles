syntax enable
filetype plugin indent on

"set ai si ci is fo=cro re=0 nosc nocul noswf hid path+=**
set udir=~/.vim/undo udf path+=** hid noswf exrc secure is
set tags=./tags;,tags;

nmap gb <cmd>ls<cr>:b<space>

set gp=git\ grep\ -n

so ~/.vim/coc.vim
