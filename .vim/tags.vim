" tags.vim — universal-ctags + GNU Global for code navigation
" needs:  brew install universal-ctags global      (vim 9.1.1590+ for 'autocomplete')
" usage:  so ~/.vim/tags.vim; run :Index once per git project
"         add to ~/.config/git/ignore:  tags  GTAGS  GRTAGS  GPATH  gtags.files

set pumheight=8

" ---- definitions / preview / completion from ctags -------------------------
set tags=./tags;,tags
set showfulltag                          " completion shows the signature
set previewpopup=height:12,width:90      " K shows the definition in a popup
set autocomplete complete=.^8,w^5,b^5,t^10
set completeopt=menuone,noselect,popup,fuzzy

" ---- indexing ---------------------------------------------------------------
let s:ctags = 'ctags --fields=+nS --extras=+q --kinds-c=+p --kinds-c++=+p -L gtags.files -f tags'

function! s:Root() abort
  let g = finddir('.git', expand('%:p:h') . ';')
  return empty(g) ? '' : fnamemodify(g, ':p:h:h')
endfunction

function! s:Run(cmd, root, ...) abort
  let o = {'cwd': a:root, 'in_io': 'null', 'out_io': 'null', 'err_io': 'null'}
  if a:0 | let o.exit_cb = a:1 | endif
  call job_start(['sh', '-c', a:cmd], o)
endfunction

" :Index — full async rebuild from git's file list (respects .gitignore)
function! s:Index() abort
  let root = s:Root()
  if empty(root) | echo 'tags: not in a git repo' | return | endif
  call s:Run('git ls-files -co --exclude-standard > gtags.files && ' . s:ctags
        \ . ' && gtags --gtagslabel=native-pygments -f gtags.files', root,
        \ {j, st -> execute('echom "tags: indexed ' . root . ' (exit ' . st . ')"', '')})
endfunction
command! Index call s:Index()

" on save: incremental update, only in projects already :Index'ed
function! s:Update() abort
  let root = s:Root()
  if empty(root) || !filereadable(root . '/GTAGS') | return | endif
  call s:Run('global --single-update ' . shellescape(expand('%:p')) . '; ' . s:ctags, root)
endfunction
augroup tagsvim | au! | au BufWritePost * call s:Update() | augroup END

" ---- references via global -> quickfix (no cursor jump) ------------------
" flags: -r refs, -d defs, -s symbols with no definition (locals, attrs)
function! s:Global(flags, word) abort
  let root = s:Root()
  if empty(root) | return [] | endif
  return systemlist('cd ' . shellescape(root) . ' && global --result=grep'
        \ . ' --path-style=absolute ' . a:flags . ' ' . shellescape(a:word))
endfunction

function! s:Refs(word, withdefs) abort
  let hits = s:Global('-r', a:word)
  if empty(hits) | let hits = s:Global('-s', a:word) | endif
  if a:withdefs | let hits = s:Global('-d', a:word) + hits | endif
  call setqflist([], ' ', {'lines': hits, 'efm': '%f:%l:%m', 'title': 'refs: ' . a:word})
  return len(hits)
endfunction

function! s:Rename() abort
  let old = expand('<cword>')
  let new = input('rename ' . old . ' -> ', old)
  if empty(new) || new ==# old | return | endif
  if !s:Refs(old, 1) | echo 'no hits' | return | endif
  exe 'cdo s/\V\C\<' . escape(old, '/\') . '\>/' . escape(new, '/\&~') . '/ge | update'
endfunction

" ---- maps (definitions: <C-]> / g<C-]>, preview: <C-w>}) ---------------------
nnoremap gr <cmd>call <SID>Refs(expand('<cword>'), 0)<bar>cwindow<cr>
nnoremap <leader>rn <cmd>call <SID>Rename()<cr>
" format with gq: formatprg per filetype
au FileType c,cpp,java setlocal formatprg=clang-format\ --assume-filename=%
