function! MyTabLine()
	let s = ''
	for i in range(bufnr('$'))
		let b = i + 1
		if buflisted(b)
			let s .= (b == bufnr('%') ? '%#TabLineSel# ' : '%#TabLine# ')
			let s .= fnamemodify(bufname(b), ':t') 
			let s .= (getbufvar(b, "&mod") ? '[+]' : '') . ' '
		endif
	endfor
	return s . '%#TabLineFill#%T'
endfunction
set showtabline=2 " Always show the tabline
set tabline=%!MyTabLine()
