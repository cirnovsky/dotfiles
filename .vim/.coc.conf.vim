let g:coc_global_extensions = ['coc-pyright', 'coc-clangd', 'coc-tsserver']

call coc#config('diagnostic', {'enable': v:false})
call coc#config('inlayHint', {'enable': v:false})
call coc#config('suggest', {'autoTrigger': 'none', 'noselect': v:false})

set ph=8
set encoding=utf-8
set nobackup
set nowritebackup
set updatetime=300

" completion
inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : coc#refresh()
inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : '<C-p>'

" goto 
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" docs
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
	if CocAction('hasProvider', 'hover')
		call CocActionAsync('doHover')
	else
		call feedkeys('K', 'in')
	endif
endfunction

" actions
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>f <Plug>(coc-format-selected)
command! -nargs=0 Format :call CocActionAsync('format')
