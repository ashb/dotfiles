setlocal ts=2 sw=2 sts=2
set listchars=tab:\ \ ,trail:•
let g:go_fmt_command = "goimports"

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" ,gb   build current file
nmap <Leader>gb <Plug>(go-build)
nmap <Leader>gc <Plug>(go-coverage)
nmap <Leader>gd <Plug>(go-doc)
nmap <Leader>gt <Plug>(go-test)
