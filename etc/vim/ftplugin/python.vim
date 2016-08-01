" -*- Mode: vim; tab-width: 4; indent-tabs-mode: nil; -*-
setlocal ts=4 sw=4 sts=4


let g:syntastic_python_checkers = ['flake8', 'python']
" Don't run python checks for anything in homebrew or installed packages
autocmd FileType python if stridx(expand("%:p"), $BREW_PREFIX) == 0 || stridx(expand("%:p"), "/site-packages/") != -1 |
    \ let b:syntastic_checkers = ["python"] | endif

let g:syntastic_python_flake8_args="--max-line-length=160"

" Use what ever python is in our path -- if we're in a virtual env that will
" be the 'right' python (2 or 3) that we've selected.
let g:ycm_python_binary_path = exepath("python")
let g:syntastic_python_python_exec = g:ycm_python_binary_path
let g:syntastic_python_flake8_exec = exepath("flake8")
