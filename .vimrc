call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()
syntax off
set mouse=a
set undodir=~/.vim/undo
set nu
set laststatus=2
set noswapfile
set nobackup
set foldmethod=marker
set foldmarker={{{,}}}
set undofile
set autoread
set clipboard=unnamed
colo darkblue
noremap gb #*cgn
inoremap <F11> <ESC>:w<CR>:!_cr %<CR>
inoremap <F10> <ESC>:!_run %:r<CR>
inoremap <F9> <ESC>:w<CR>:!_cp %<CR>
noremap <F11> <ESC>:w<CR>:!_cr %<CR>
noremap <F10> <ESC>:!_run %:r<CR>
noremap <F9> <ESC>:w<CR>:!_cp %<CR>
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap {<space> {}<ESC>i<space><space><ESC>i
inoremap {<CR> {<CR>}<ESC>O
inoremap /* /**/<ESC>hi
inoremap " <c-r>=Fuck("\"")<CR>
inoremap ' <c-r>=Fuck("'")<CR>
inoremap ) <c-r>=Skp(")")<CR>
inoremap ] <c-r>=Skp("]")<CR>
inoremap } <c-r>=Skp("}")<CR>

func Fuck(quo)
  return getline('.')[col('.') - 1] == a:quo ? "\<ESC>la" : a:quo . a:quo . "\<ESC>ha"
endfunc
func Skp(bra)
  return getline('.')[col('.') - 1] == a:bra ? "\<ESC>la" : a:bra
endfunc
