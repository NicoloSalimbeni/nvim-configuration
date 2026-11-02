" custom function to start browser page
function! OpenMarkdownPreview(url)
  call jobstart(['firefox', '--private-window', a:url], {'detach': v:true})
endfunction
let g:mkdp_browserfunc = 'OpenMarkdownPreview'

" set default theme (dark or light)
" By default the theme is define according to the preferences of the system
let g:mkdp_theme = 'dark'
setlocal wrap
