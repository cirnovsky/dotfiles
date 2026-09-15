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
"   gw  toggle reflowing the body to 'textwidth' (gq) on and off; the header
"       block (From/To/Subject/…) is left unwrapped
"   gb  open the HTML part in a browser, with cid: images inlined
"   gx  open the link/attachment under the cursor: a '[N]' marker (inline or in
"       the References footer) opens its URL; a '[N]' attachment line opens it;
"       a 'cid:<id>' reference (as the text/plain body writes inline images)
"       opens the inline part it points at
"   q   quit vim
"   D   delete this mail (mutt's <delete-message>) and show the next one
"   J   show the next undeleted mail
"   K   show the previous undeleted mail
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
  " Reflow to 'textwidth' (gq honours the filetype=mail default of 72) when the
  " wrap toggle is on; re-rendering re-applies it so it survives part switches.
  " Reflow the body only: start after the header block (From/To/Subject/…, up to
  " the first blank line) so it isn't collapsed into one paragraph, and stop
  " before any References:/Attachments:/Links: footer so its [N] lines aren't
  " joined together either.
  if get(b:, 'mailview_wrap', 0)
    let sep = 1
    while sep <= line('$') && getline(sep) !=# ''
      let sep += 1
    endwhile
    let last = line('$')
    let f = sep
    while f <= line('$')
      if getline(f) =~# '^\%(References\|Attachments\|Links\):$'
        let last = f - 1
        break
      endif
      let f += 1
    endwhile
    if sep < last
      silent! execute 'normal! ' . (sep + 1) . 'Ggq' . last . 'G'
    endif
  endif
  setlocal nomodifiable nomodified
  let b:mailview_mode = a:mode
  normal! gg
  redraw
  call s:Status()
endfunction

function! MailViewToggleWrap() abort
  let b:mailview_wrap = !get(b:, 'mailview_wrap', 0)
  call MailViewRender(b:mailview_mode)
endfunction

function! MailViewToggle() abort
  call MailViewRender(b:mailview_mode ==# 'plain' ? 'html' : 'plain')
endfunction

function! MailViewBrowser() abort
  call system('python3 ' . shellescape(s:browser) . ' ' . shellescape(b:mailview_raw))
  echo 'mail-view: opened HTML in browser'
endfunction

let s:url_pat = 'https\?://[^ >()"'."'".']\+'
" A cid: reference as it appears inline in the text/plain body, e.g.
" 'cid:image002.jpg@01DD246A.0CC42F60' (usually wrapped in '[...]').
let s:cid_pat = 'cid:[^] >()"'."'".']\+'

function! s:OpenUrl(url) abort
  call system('open ' . shellescape(a:url))
  echo 'mail-view: opened ' . a:url
endfunction

function! s:OpenAttach(n) abort
  call system('python3 ' . shellescape(s:helper) . ' attach '
        \ . shellescape(b:mailview_raw) . ' ' . a:n)
  echo 'mail-view: opened attachment ' . a:n
endfunction

function! s:OpenAttachCid(cid) abort
  call system('python3 ' . shellescape(s:helper) . ' attach-cid '
        \ . shellescape(b:mailview_raw) . ' ' . shellescape(a:cid))
  echo 'mail-view: opened ' . a:cid
endfunction

" The cid: reference the cursor sits on, else the first one on the line, else ''.
function! s:CidUnderCursor() abort
  let col = col('.')
  let line = getline('.')
  let from = 0
  while 1
    let s = match(line, s:cid_pat, from)
    if s < 0 | break | endif
    let e = matchend(line, s:cid_pat, from)
    if col >= s + 1 && col <= e
      return matchstr(line, s:cid_pat, s)
    endif
    let from = e
  endwhile
  return matchstr(line, s:cid_pat)
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
"   * the inline part a 'cid:<id>' reference points at;
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

  " A 'cid:<id>' reference -> the inline part it points at.
  let cid = s:CidUnderCursor()
  if !empty(cid)
    call s:OpenAttachCid(cid)
    return
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
  execute 'syntax match mailViewCid "\[' . s:cid_pat . '\]" containedin=ALL'
  highlight default link mailViewRef  Special
  highlight default link mailViewFoot Title
  highlight default link mailViewCid  Special
endfunction

" Have mutt do a:action ('delete'/'next'/'prev') and show the message it lands
" on.  mail-view.sh reads the request from one fifo, pushes the mutt keys and
" exits; mutt pipes the resulting message into a new mail-view.sh, which
" overwrites b:mailview_raw and answers on the other fifo.  vim's system()
" leaves the terminal alone while it waits, so mutt is free to work meanwhile.
function! MailViewMove(action) abort
  call system('echo ' . a:action . ' > ' . g:mailview_req . '; cat ' . g:mailview_rsp)
  redraw!   " mutt's endwin() moved the cursor behind our back
  call MailViewOpen(b:mailview_raw)
endfunction
autocmd VimLeavePre * if exists('g:mailview_req') | call system('echo quit > ' . g:mailview_req) | endif

function! s:Status() abort
  let others = filter(copy(b:mailview_avail), 'v:val !=# b:mailview_mode')
  let hint = empty(others) ? '' : ' (t: switch to ' . others[0] . ')'
  let wrap = get(b:, 'mailview_wrap', 0) ? '  gw: unwrap' : '  gw: wrap'
  echo strpart('mail-view [' . b:mailview_mode . ']' . hint . wrap
        \ . '  gb: browser  gx: open  D: delete  J/K: next/prev  q: quit', 0, v:echospace)
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
  nnoremap <buffer> <silent> gw :call MailViewToggleWrap()<CR>
  nnoremap <buffer> <silent> gb :call MailViewBrowser()<CR>
  nnoremap <buffer> <silent> gx :call MailViewGx()<CR>
  nnoremap <buffer> <silent> q  :qa!<CR>
  nnoremap <buffer> <silent> D  :call MailViewMove('delete')<CR>
  nnoremap <buffer> <silent> J  :call MailViewMove('next')<CR>
  nnoremap <buffer> <silent> K  :call MailViewMove('prev')<CR>

  " Prefer text/plain (matching mutt's alternative_order), else whatever exists.
  call MailViewRender(index(b:mailview_avail, 'plain') >= 0 ? 'plain' : b:mailview_avail[0])
endfunction
