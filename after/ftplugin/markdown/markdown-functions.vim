" custom function to start browser page
function OpenMarkdownPreview (url)
  execute "silent ! firefox --private-window " . a:url
endfunction
let g:mkdp_browserfunc = 'OpenMarkdownPreview'

" set default theme (dark or light)
" By default the theme is define according to the preferences of the system
let g:mkdp_theme = 'dark'
setlocal wrap
