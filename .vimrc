" Basics {{{
syntax enable
filetype plugin indent on
set ai
set si
set ci
set mouse=a
set is
set fo=cro
set re=0
set nosc
set nocul
set noswapfile

set undodir=~/.vim/undo
set undofile

set foldmethod=marker
set foldmarker={{{,}}}
colo pablo

autocmd FileType cpp set kp=cppman

let g:netrw_liststyle=3
let g:airline#extensions#tabline#enabled=1

" Ctags
set tags=./tags;,tags
nmap <silent> <C-]> <C-]>
nmap <silent> <C-t> <C-t>
" }}}

" Keymaps {{{
nmap ? :find ./**/*

nmap <space>n :bn!<CR>
nmap <space>p :bp!<CR>
nmap <space>w :bd<CR>

nmap <space>r <cmd>cope<CR><cmd>AsyncRun 
" }}}

" Plugins {{{
call plug#begin()
Plug 'skywind3000/vim-auto-popmenu'
Plug 'cirnovsky/vim-dict'
Plug 'cirnovsky/vim-gotoword'
Plug 'vim-airline/vim-airline'
Plug 'ludovicchabant/vim-gutentags'
Plug 'github/copilot.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-commentary'
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

" <copilot.vim> {{{
let g:copilot_filetypes = { '*': v:false }
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
function! CopilotToggle()
	if exists("b:copilot_enabled")
		if b:copilot_enabled
			let b:copilot_enabled = v:false
		else
			let b:copilot_enabled = v:true
		endif
	else
		let b:copilot_enabled = v:true
	endif
endfunction
nmap <silent> <C-L> <esc>:call CopilotToggle()<CR>
" }}}
