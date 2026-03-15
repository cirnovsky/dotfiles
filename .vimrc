syntax enable
filetype plugin indent on

colo blue
set ai si ci is fo=cro re=0 nosc nocul noswf hid path+=**
set udir=~/.vim/undo udf
set fdm=marker fmr={{{,}}}
set tags=./tags;,tags;
autocmd filetype cpp setl tags+=~/.tags/cpp
autocmd filetype python setl tags+=~/.tags/python

nmap gb <cmd>ls<cr>:b
