" emacsmodeline.vim
" -*- tab-width: 3 -*-
" Brief: Parse emacs mode line and setlocal in vim
" Version: 0.1
" Maintainer: Ash Berlin <ash.berlin@gmail.com>
"
" Installation: put this file under your ~/.vim/plugins/
"
" Usage:
"
" This script is used to parse emcas mode line, for example:
" -*- tab-width: 2 -*-
"
" Which is the same meaning as:
" vim:tabstop=2:
"
" The script looks for an emacs mode line in the first 2 lines of the file to
" match emacs' behaviour. Currently a very small subset of possible emacs's
" modes are understood. To add more put entries into
" 'g:emacs_mode_line_mapping' dictionary. If the value is a function it will be
" called with 'name' and 'val'. For example

"   function! s:indent_tabs(name, val)
"     " name would be 'indent-tabs-mode'
"     exec 'setlocal ' . (val == 'nil') . 'expandtab'
"   endfunc
"   let g.emacs_mode_line_mapping['indent-tabs-mode'] = function('s:indent_tabs_mode')
"
" If the dictionary value is a string it will be setlocal'ed directly.
"
" Revisions:
"

function! s:indent_tabs_mode(name, val)
  if a:val == "nil"
    exec 'setlocal expandtab'
  else
    exec 'setlocal noexpandtab'
  endif
endfunc

let g:emacs_mode_line_mapping = {
  \ 'tab-width': 'tabstop',
  \ 'indent-tabs-mode': function('s:indent_tabs_mode'),
  \ 'Mode': {
  \   'prop': 'filetype',
  \   'map': { 'Bash': 'sh' },
  \ },
\}

function! s:GetParameters(line)
  let l:opt = {}

  for pair in split(substitute(a:line, '\s\+\(.*\)\s\+$', '\1', ''), '\s*;\s*')
    let vals = split(pair, '\s*:\s*')
    let l:opt[ vals[0] ] = vals[1]
  endfor

  return l:opt
endfunc

function! ParseEmacsModeLine()
  for l:line in readfile(expand('%:p'), '', 2)
    let l:mode = substitute(l:line, '^.*-\*-\(.*\)-\*-.*', '\1', '')
    if l:mode != l:line

      for [k, v] in items( s:GetParameters(l:mode) )
        if has_key(g:emacs_mode_line_mapping, k)
          let K = g:emacs_mode_line_mapping[k]
          let t = type(K)
          if t == type(function("tr"))
            call K(k, v)
          elseif t == type({})
            " value is a dict.
            if !has_key(K, "prop") || !has_key(K, "map") 
             \ || type( K['prop'] ) != type("") || type( K['map'] ) != type({})
              throw "g:emacs_mode_line_mapping['" . k . "'] is a dictionary, but it doesn't have 'prop' and 'map' values"
            endif
            if has_key(K.map, v)
              exec 'setlocal ' K.prop . '=' . K.map[v]
            else
              exec 'setlocal ' K.prop . '=' . v
            endif
          else
            exec 'setlocal ' K . '=' . v
          endif
          unlet K
        endif
      endfor
      break
    endif
  endfor
endfunc


augroup emacs
  autocmd!
  autocmd BufReadPost * call ParseEmacsModeLine()
augroup END
