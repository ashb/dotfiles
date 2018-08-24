" -*- vim -*-

map <Leader>b :<c-u>CtrlPBuffer<cr>
map <Leader>r :<c-u>exe 'CtrlP' expand('%:h')<cr>
let g:ctrlp_working_path_mode = '0'

" When opening new files do it in the same window by default
let g:ctrlp_open_new_file = 'r'

" Sometimes I forget which file I'm in.
let g:ctrlp_match_current_file = 1

" Show hidden
let g:ctrlp_show_hidden = 1

" But ignore .git dirs, and obvious binary files
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn|terraform\/modules|venv)|build|vendor|pkg\/dep|target\/scala-2.11)$',
  \ 'file': '\v\.(a|so|dylib|class|pyc)$',
  \ }
