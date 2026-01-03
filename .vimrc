
" Basic Setup {{{
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
" }}}

" Navigation Setup {{{
nmap ? :find ./**/*

nmap <space>n :bn!<CR>
nmap <space>p :bp!<CR>
nmap <space>w :bd<CR>

nmap <space>k :GotoWord<CR>
" }}}

" Plugin Installation {{{
call plug#begin()
Plug 'cirnovsky/vim-gotoword'
Plug 'vim-airline/vim-airline'
Plug 'github/copilot.vim'
Plug 'tpope/vim-commentary'
Plug 'yegappan/lsp'
call plug#end()
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

" <lsp> {{{
let lspServers = [#{
			\    name: 'pylsp',
			\    filetype: ['python'],
			\    path: 'pylsp',
			\    args: []
			\  },
			\ #{
			\    name: 'clangd',
			\    filetype: ['c', 'cpp'],
			\    path: 'clangd',
			\    args: ['--background-index']
			\  }]
autocmd User LspSetup call LspAddServer(lspServers)

nnoremap gd <cmd>LspGotoDefinition<CR>
nnoremap gr <cmd>LspPeekReferences<CR>
nnoremap gi <cmd>LspGotoImplementation<CR>
nnoremap K <cmd>LspHover<CR>
nnoremap <leader>rn <cmd>LspRename<CR>
nnoremap [d <cmd>LspDiagPrev<CR>
nnoremap ]d <cmd>LspDiagNext<CR>
" }}}

""" <vim-airline> {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
""" }}}
