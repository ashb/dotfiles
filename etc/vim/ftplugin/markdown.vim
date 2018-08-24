
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_toc_autofit = 1

let g:vim_markdown_frontmatter = 1

let g:vim_markdown_fenced_languages = ['bash=sh']

function! RemapCodeblocks()
  " Capture the mkdNonListItem syntax, so we can walk through it looking for
  " any mkdSnippetXXX
  redir => l:mkdGroups
    silent syn list @mkdNonListItem
  redir END

  echo l:mkdGroups

  " We need to add this to the end of the start suffixes.
  let l:suffix = '\%\(\s\+hl_lines=".\+"\)\?'

  let l:synname = matchstrpos(l:mkdGroups, '\<mkdSnippet[A-Z_]\+\>')
  while synname != ['', -1, -1]
    echo synname[0]
    execute printf('syn list %s', synname[0])
    let l:synname = matchstrpos(l:mkdGroups, '\<mkdSnippet[A-Z_]\+\>', synname[2])
  endwhile
endfunction
