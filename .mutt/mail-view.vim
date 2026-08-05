" mail-view.vim — view a raw MIME email inside vim.
"
" Launched by mail-view.sh, which drops the whole raw message to a temp .eml and
" starts vim with:
"     vim -c 'source mail-view.vim' -c "call MailViewOpen('<raw.eml>')"
"
" The heavy MIME work (charset + transfer-encoding decode, choosing the HTML
" renderer from mailcap) lives in mail-view.py; this script is just the vim UI.
"
" Buffer-local keys:
"   t   toggle between text/plain and mailcapped text/html
"   gb  open the HTML part in a browser, with cid: images inlined
"   gx  open the link/attachment under the cursor: a '[N]' marker (inline or in
"       the References footer) opens its URL; a '[N]' attachment line opens it
"   q   quit vim
"
" State is kept per-buffer so several messages can be open at once:
"   b:mailview_raw    path to the raw .eml
"   b:mailview_mode   'plain' | 'html'
"   b:mailview_avail  list of available modes, e.g. ['plain', 'html']

let s:helper  = expand('<sfile>:p:h') . '/mail-view.py'
let s:browser = expand('<sfile>:p:h') . '/view-html-browser.py'

function! s:Run(args) abort
  return systemlist('python3 ' . shellescape(s:helper) . ' ' . a:args)
endfunction

function! MailViewRender(mode) abort
  if index(b:mailview_avail, a:mode) < 0
    echohl WarningMsg
    echo 'mail-view: no ' . a:mode . ' part in this message'
    echohl None
    return
  endif
  let lines = s:Run('render ' . shellescape(b:mailview_raw) . ' ' . a:mode)
  setlocal modifiable
  silent! %delete _
  call setline(1, lines)
  setlocal nomodifiable nomodified
  let b:mailview_mode = a:mode
  normal! gg
  redraw
  call s:Status()
endfunction

function! MailViewToggle() abort
  call MailViewRender(b:mailview_mode ==# 'plain' ? 'html' : 'plain')
endfunction

function! MailViewBrowser() abort
  call system('python3 ' . shellescape(s:browser) . ' ' . shellescape(b:mailview_raw))
  echo 'mail-view: opened HTML in browser'
endfunction

let s:url_pat = 'https\?://[^ >()"'."'".']\+'

function! s:OpenUrl(url) abort
  call system('open ' . shellescape(a:url))
  echo 'mail-view: opened ' . a:url
endfunction

function! s:OpenAttach(n) abort
  call system('python3 ' . shellescape(s:helper) . ' attach '
        \ . shellescape(b:mailview_raw) . ' ' . a:n)
  echo 'mail-view: opened attachment ' . a:n
endfunction

" The number N of a '[N]' marker the cursor sits on, or 0 if it isn't on one.
function! s:RefUnderCursor() abort
  let col = col('.')
  let line = getline('.')
  let from = 0
  while 1
    let s = match(line, '\[\d\+\]', from)
    if s < 0 | return 0 | endif
    let e = matchend(line, '\[\d\+\]', from)
    if col >= s + 1 && col <= e
      return str2nr(matchstr(line, '\d\+', s))
    endif
    let from = e
  endwhile
endfunction

" The URL that w3m's 'References:' footer gives to marker [n], or '' if none.
function! s:RefUrl(n) abort
  let lnum = search('^\[' . a:n . '\]\s\+' . s:url_pat, 'nw')
  return lnum > 0 ? matchstr(getline(lnum), s:url_pat) : ''
endfunction

" gx — open what the cursor is on:
"   * an attachment, when on a '[N] name' line in the 'Attachments:' block;
"   * the link for a '[N]' marker, whether that's an inline marker in the body
"     or the '[N] url' line in w3m's 'References:' footer;
"   * otherwise any bare URL on the current line.
function! MailViewGx() abort
  let line = getline('.')
  let n = s:RefUnderCursor()

  " Attachments: is appended after References:, so an on-'[N]' cursor is on an
  " attachment line iff the nearest 'Attachments:' header above is the nearest.
  let ahdr = search('^Attachments:$', 'bnW')
  if n > 0 && line =~# '^\[\d\+\]' && ahdr > 0 && ahdr > search('^References:$', 'bnW')
    call s:OpenAttach(n)
    return
  endif

  " A '[N]' marker (inline or in the footer) -> the footer URL it points to.
  if n > 0
    let url = s:RefUrl(n)
    if !empty(url)
      call s:OpenUrl(url)
      return
    endif
  endif

  " Fallback: a bare URL sitting on this line.
  let url = matchstr(line, s:url_pat)
  if !empty(url)
    call s:OpenUrl(url)
    return
  endif
  echo 'mail-view: no link or attachment on this line'
endfunction

" Highlight the footnote scaffolding: '[N]' markers, footer headers, and URLs.
function! s:Syntax() abort
  syntax match mailViewRef  /\[\d\+\]/                                containedin=ALL
  syntax match mailViewFoot /^\%(References\|Attachments\|Links\):$/  containedin=ALL
  execute 'syntax match mailViewUrl "' . s:url_pat . '" containedin=ALL'
  highlight default link mailViewRef  Special
  highlight default link mailViewFoot Title
  highlight default link mailViewUrl  Underlined
endfunction

function! s:Status() abort
  let others = filter(copy(b:mailview_avail), 'v:val !=# b:mailview_mode')
  let hint = empty(others) ? '' : ' (t: switch to ' . others[0] . ')'
  echo 'mail-view [' . b:mailview_mode . ']' . hint . '  gb: browser  gx: open  q: quit'
endfunction

function! MailViewOpen(raw) abort
  enew
  let b:mailview_raw   = a:raw
  let b:mailview_avail = s:Run('parts ' . shellescape(a:raw))
  call filter(b:mailview_avail, '!empty(v:val)')
  if empty(b:mailview_avail)
    let b:mailview_avail = ['plain']
  endif

  setlocal buftype=nofile bufhidden=wipe noswapfile nomodifiable
  setlocal filetype=mail nonumber norelativenumber foldcolumn=0
  call s:Syntax()

  nnoremap <buffer> <silent> t  :call MailViewToggle()<CR>
  nnoremap <buffer> <silent> gb :call MailViewBrowser()<CR>
  nnoremap <buffer> <silent> gx :call MailViewGx()<CR>
  nnoremap <buffer> <silent> q  :qa!<CR>

  " Prefer text/plain (matching mutt's alternative_order), else whatever exists.
  call MailViewRender(index(b:mailview_avail, 'plain') >= 0 ? 'plain' : b:mailview_avail[0])
endfunction
