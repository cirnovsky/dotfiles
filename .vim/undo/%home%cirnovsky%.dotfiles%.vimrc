Vim�UnDo� �i�k�28_�p�r�v>��8{4f��e���   ,                 '       '   '   '    gsc�    _�                     5        ����                                                                           �                                                                                                                                                                                                                                                                                gfDZ     �   5               �   5            5�_�                    7        ����                                                                           �                                                                                                                                                                                                                                                                                gfD\    �   6               �   7            5�_�                    7        ����                                                                           t                                                                                                                                                                                                                                                                                gfDa     �   6   8   �      W" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim5�_�                    �        ����                                                                           t                                                                                                                                                                                                                                                                                gfDf    �   �               �   �            5�_�                    7       ����                                                                           u                                                                                                                                                                                                                                                                                gfF      �   6   9   �      Z{{{" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim5�_�                    8       ����                                                                           v                                                                                                                                                                                                                                                                                gfF     �   7   9   �      W" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim5�_�                    8       ����                                                                           v                                                                                                                                                                                                                                                                                gfF     �   7   9   �      Y""""https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim5�_�      	              8       ����                                                                           v                                                                                                                                                                                                                                                                                gfF
     �   7   9   �      Y""" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim5�_�      
           	   8       ����                                                                           v                                                                                                                                                                                                                                                                                gfF
    �   7   9   �      X"" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim5�_�   	              
   7        ����                                                                           v                                                                                                                                                                                                                                                                                gfF     �   6   8   �      {{{5�_�   
                 7        ����                                                                           v                                                                                                                                                                                                                                                                                gfF     �   6   8   �      {{5�_�                    7        ����                                                                           v                                                                                                                                                                                                                                                                                gfF     �   6   8   �      {5�_�                    7        ����                                                                           v                                                                                                                                                                                                                                                                                gfF     �   6   7           5�_�                    7   W    ����                                                                           u                                                                                                                                                                                                                                                                                gfF!     �   6   8   �      W" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim5�_�                    �        ����                                                                           u                                                                                                                                                                                                                                                                                gfF%     �   �              }}}5�_�                    �       ����                                                                           u                                                                                                                                                                                                                                                                                gfF&    �   �              ""}}}5�_�                            ����                                                                           �                                                                                                                                                                                                                                                                                gl$�     �              �   Eif (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal') " {{{     if (has("nvim"))   %    let $NVIM_TUI_ENABLE_TRUE_COLOR=1     endif     if (has("termguicolors"))       set termguicolors     endif   endif " }}}   call plug#begin() " {{{   3Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }   Plug 'junegunn/fzf.vim'   Plug 'morhetz/gruvbox'   Plug 'tpope/vim-commentary'   /Plug 'neoclide/coc.nvim', {'branch': 'release'}   call plug#end() " }}}   	syntax on   syntax enable   set undodir=~/.vim/undo   set nu   set laststatus=2   set noswapfile   set nobackup   set foldmethod=marker   set foldmarker={{{,}}}   set undofile   set autoread   set bg=dark   set clipboard=unnamed   noremap gb #*cgn   %inoremap <F11> <ESC>:w<CR>:!_cr %<CR>   "inoremap <F10> <ESC>:!_run %:r<CR>   $inoremap <F9> <ESC>:w<CR>:!_cp %<CR>   $noremap <F11> <ESC>:w<CR>:!_cr %<CR>   !noremap <F10> <ESC>:!_run %:r<CR>   #noremap <F9> <ESC>:w<CR>:!_cp %<CR>   inoremap ( ()<ESC>i   inoremap [ []<ESC>i   .inoremap {<space> {}<ESC>i<space><space><ESC>i   inoremap {<CR> {<CR>}<ESC>O   inoremap /* /**/<ESC>hi   inoremap " <c-r>=Fuck("\"")<CR>   inoremap ' <c-r>=Fuck("'")<CR>   inoremap ) <c-r>=Skp(")")<CR>   inoremap ] <c-r>=Skp("]")<CR>   inoremap } <c-r>=Skp("}")<CR>   colo gruvbox       func Fuck(quo)   V  return getline('.')[col('.') - 1] == a:quo ? "\<ESC>la" : a:quo . a:quo . "\<ESC>ha"   endfunc   func Skp(bra)   A  return getline('.')[col('.') - 1] == a:bra ? "\<ESC>la" : a:bra   endfunc       [" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim {{{       N" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count   " utf-8 byte sequence   set encoding=utf-8   6" Some servers have issues with backup files, see #649   set nobackup   set nowritebackup       H" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable   !" delays and poor user experience   set updatetime=300       I" Always show the signcolumn, otherwise it would shift the text each time   $" diagnostics appear/become resolved   set signcolumn=yes       C" Use tab for trigger completion with characters ahead and navigate   P" NOTE: There's always complete item selected by default, you may want to enable   D" no select by `"suggest.noselect": true` in your configuration file   K" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by   3" other plugin before putting this into your config   inoremap <silent><expr> <TAB>   -      \ coc#pum#visible() ? coc#pum#next(1) :   %      \ CheckBackspace() ? "\<Tab>" :         \ coc#refresh()   Einoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"       K" Make <CR> to accept selected completion item or notify coc.nvim to format   9" <C-g>u breaks current undo, please make your own choice   Binoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()   I                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"        function! CheckBackspace() abort     let col = col('.') - 1   0  return !col || getline('.')[col - 1]  =~# '\s'   endfunction       %" Use <c-space> to trigger completion   if has('nvim')   1  inoremap <silent><expr> <c-space> coc#refresh()   else   -  inoremap <silent><expr> <c-@> coc#refresh()   endif       +" Use `[g` and `]g` to navigate diagnostics   Q" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list   ,nmap <silent> [g <Plug>(coc-diagnostic-prev)   ,nmap <silent> ]g <Plug>(coc-diagnostic-next)       " GoTo code navigation   'nmap <silent> gd <Plug>(coc-definition)   ,nmap <silent> gy <Plug>(coc-type-definition)   +nmap <silent> gi <Plug>(coc-implementation)   'nmap <silent> gr <Plug>(coc-references)       /" Use K to show documentation in preview window   1nnoremap <silent> K :call ShowDocumentation()<CR>       function! ShowDocumentation()   &  if CocAction('hasProvider', 'hover')   "    call CocActionAsync('doHover')     else       call feedkeys('K', 'in')     endif   endfunction       A" Highlight the symbol and its references when holding the cursor   <autocmd CursorHold * silent call CocActionAsync('highlight')       " Symbol renaming   "nmap <leader>rn <Plug>(coc-rename)       " Formatting selected code   +xmap <leader>f  <Plug>(coc-format-selected)   +nmap <leader>f  <Plug>(coc-format-selected)       augroup mygroup   
  autocmd!   *  " Setup formatexpr specified filetype(s)   N  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')   -  " Update signature help on jump placeholder   J  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')   augroup end       2" Applying code actions to the selected code block   ." Example: `<leader>aap` for current paragraph   /xmap <leader>a  <Plug>(coc-codeaction-selected)   /nmap <leader>a  <Plug>(coc-codeaction-selected)       =" Remap keys for applying code actions at the cursor position   .nmap <leader>ac  <Plug>(coc-codeaction-cursor)   7" Remap keys for apply code actions affect whole buffer   .nmap <leader>as  <Plug>(coc-codeaction-source)   P" Apply the most preferred quickfix action to fix diagnostic on the current line   (nmap <leader>qf  <Plug>(coc-fix-current)       /" Remap keys for applying refactor code actions   8nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)   Axmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)   Anmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)       ." Run the Code Lens action on the current line   ,nmap <leader>cl  <Plug>(coc-codelens-action)       %" Map function and class text objects   O" NOTE: Requires 'textDocument.documentSymbol' support from the language server   xmap if <Plug>(coc-funcobj-i)   omap if <Plug>(coc-funcobj-i)   xmap af <Plug>(coc-funcobj-a)   omap af <Plug>(coc-funcobj-a)   xmap ic <Plug>(coc-classobj-i)   omap ic <Plug>(coc-classobj-i)   xmap ac <Plug>(coc-classobj-a)   omap ac <Plug>(coc-classobj-a)       6" Remap <C-f> and <C-b> to scroll float windows/popups   -if has('nvim-0.4.0') || has('patch-8.2.0750')   _  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"   _  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"   o  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"   n  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"   _  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"   _  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"   endif       "" Use CTRL-S for selections ranges   C" Requires 'textDocument/selectionRange' support of language server   ,nmap <silent> <C-s> <Plug>(coc-range-select)   ,xmap <silent> <C-s> <Plug>(coc-range-select)       0" Add `:Format` command to format current buffer   7command! -nargs=0 Format :call CocActionAsync('format')       ," Add `:Fold` command to fold current buffer   <command! -nargs=? Fold :call     CocAction('fold', <f-args>)       >" Add `:OR` command for organize imports of the current buffer   ]command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')       *" Add (Neo)Vim's native statusline support   N" NOTE: Please see `:h coc-status` for integrations with external plugins that   7" provide custom statusline: lightline.vim, vim-airline   Cset statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}       " Mappings for CoCList   " Show all diagnostics   Annoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>   " Manage extensions   @nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>   " Show commands   >nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>   !" Find symbol of current document   =nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>   " Search workspace symbols   @nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>   !" Do default action for next item   5nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>   %" Do default action for previous item   5nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>   " Resume latest coc list   ;nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>   " }}}5�_�                            ����                                                                            �                                                                                                                                                                                                                                                                                gl$�     �                   �               5�_�                            ����                                                                                                                                                                                                                                                                                                                                                           gl$�    �                     call plug#begin()5�_�                            ����                                                                                                                                                                                                                                                                                                                                                           gl$�    �          &       �          %    5�_�                            ����                                                                                                                                                                                                                                                                                                                                                           gl%�    �         '       �         &    5�_�                            ����                                                                                                                                                                                                                                                                                                                                                           gl&r     �                set nosm5�_�                           ����                                                                                                                                                                                                                                                                                                                                                           gl&u     �         &    5�_�                            ����                                                                                                                                                                                                                                                                                                                                                           gl&v    �         '       �         '    5�_�                            ����                                                                                                                                                                                                                                                                                                                                                           gl&�   	 �                3hi MatchParen cterm=none ctermbg=green ctermfg=blue5�_�                           ����                                                                                                                                                                                                                                                                                                                                                           gl&�     �         &    5�_�                            ����                                                                                                                                                                                                                                                                                                                                                           gl&�   
 �         '       �         '    5�_�                    (        ����                                                                                                                                                                                                                                                                                                                                                           gl'�     �   (            5�_�                     )        ����                                                                                                                                                                                                                                                                                                                                                           gl'�     �   (               �   )            5�_�      !               (        ����                                                                           7                                                                                                                                                                                                                                                                                gl'�    �   (   *   O    5�_�       "           !   =        ����                                                                           8                                                                                                                                                                                                                                                                                gl'�     �   <   =          &" These are the regions for each pair.5�_�   !   #           "   =        ����                                                                           7                                                                                                                                                                                                                                                                                gl'�     �   <   =          F" This could be improved, perhaps, by makeing them match [ and { also,   B" but I'm not going to take the time to figure out haw to make the   )" end pattern match only the proper type.   �syn region level1 matchgroup=level1c start=/(/ end=/)/ contains=TOP,level1,level2,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens   �syn region level2 matchgroup=level2c start=/(/ end=/)/ contains=TOP,level2,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens   �syn region level3 matchgroup=level3c start=/(/ end=/)/ contains=TOP,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens   �syn region level4 matchgroup=level4c start=/(/ end=/)/ contains=TOP,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens   �syn region level5 matchgroup=level5c start=/(/ end=/)/ contains=TOP,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens   �syn region level6 matchgroup=level6c start=/(/ end=/)/ contains=TOP,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens   �syn region level7 matchgroup=level7c start=/(/ end=/)/ contains=TOP,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens   �syn region level8 matchgroup=level8c start=/(/ end=/)/ contains=TOP,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens   �syn region level9 matchgroup=level9c start=/(/ end=/)/ contains=TOP,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens   �syn region level10 matchgroup=level10c start=/(/ end=/)/ contains=TOP,level10,level11,level12,level13,level14,level15, level16,NoInParens   �syn region level11 matchgroup=level11c start=/(/ end=/)/ contains=TOP,level11,level12,level13,level14,level15, level16,NoInParens   ysyn region level12 matchgroup=level12c start=/(/ end=/)/ contains=TOP,level12,level13,level14,level15, level16,NoInParens   qsyn region level13 matchgroup=level13c start=/(/ end=/)/ contains=TOP,level13,level14,level15, level16,NoInParens   isyn region level14 matchgroup=level14c start=/(/ end=/)/ contains=TOP,level14,level15, level16,NoInParens   asyn region level15 matchgroup=level15c start=/(/ end=/)/ contains=TOP,level15, level16,NoInParens   Xsyn region level16 matchgroup=level16c start=/(/ end=/)/ contains=TOP,level16,NoInParens5�_�   "   $           #   )        ����                                                                           $                                                                                                                                                                                                                                                                                gl'�    �   (   )              hi level1c ctermfg=brown   hi level2c ctermfg=Darkblue   hi level3c ctermfg=darkgray   hi level4c ctermfg=darkgreen   hi level5c ctermfg=darkcyan   hi level6c ctermfg=darkred   hi level7c ctermfg=darkmagenta   hi level8c ctermfg=brown   hi level9c ctermfg=gray   hi level10c ctermfg=black   hi level11c ctermfg=darkmagenta   hi level12c ctermfg=Darkblue   hi level13c ctermfg=darkgreen   hi level14c ctermfg=darkcyan   hi level15c ctermfg=darkred   hi level16c ctermfg=red            5�_�   #   %           $           ����                                                                                                                                                                                                                                                                                                                                                           gl/�    �         )       �         (    5�_�   $   &           %           ����                                                                                                                                                                                                                                                                                                                                                           gmh�    �         *       �         )    5�_�   %   '           &           ����                                                                                                                                                                                                                                                                                                                                                           gsZ    �         +       �         *    5�_�   &               '           ����                                                                                                                                                                                                                                                                                                                                                           gsc�    �      	   ,       �      	   +    5�_�                            ����                                                                                                                                                                                                                                                                                                                                                           gl&�     �         &    �          &      4cPlug 'junegunn/fzf', { 'do': { -> fzf#install() } }   'Plug 'junegunn/fzf.vim'all plug#begin()5�_�                            ����                                                                                                                                                                                                                                                                                                                                                           gl&t     �         &    �         &      =shi MatchParen cterm=none ctermbg=green ctermfg=blueyntax off5��