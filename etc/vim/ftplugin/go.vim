setlocal ts=2 sw=2 sts=2
set listchars=tab:\ \ ,trail:•
let g:go_fmt_command = "goimports"

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:go_gocode_autobuild = 1
let g:go_gocode_propose_builtins = 1

" ,gb   build current file
nmap <Leader>gb <Plug>(go-build)
nmap <Leader>gc <Plug>(go-coverage-toggle)
nmap <Leader>gd <Plug>(go-doc)
nmap <Leader>gt <Plug>(go-test)
nmap <Leader>a <Plug>(go-alternate-edit)
nmap <Leader>va <Plug>(go-alternate-vertical)
nmap <Leader>sa <Plug>(go-alternate-split)
nmap <Leader>l <Plug>(go-metalinter)

"let b:syntastic_mode = "passive"
let g:syntastic_go_checkers=['go']


let g:deoplete#sources.go = ['buffer', 'go', 'ultisnips']
let g:deoplete#sources#go#pointer = 1
let g:deoplete#sources#go#use_cache = 1
let g:deoplete#sources#go#json_directory = '~/.cache/deoplete/go/$GOOS_$GOARCH'
let g:deoplete#sources#go#auto_goos = 1

" Vim-go coverd colour - use 256 colour green, not 16 colour green because of
" Solarized
highlight goCoverageCovered  term=bold ctermfg=118
