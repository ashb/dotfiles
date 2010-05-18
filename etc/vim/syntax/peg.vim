" Vim syntax file
" Language: Cascading Style Sheets
" Maintainer: Dominic Baggott <dominic.baggott@gmail.com>
" URL: http://github.com/evilstreak/css.vim
" Last Change: 2009 Dec 04

" This is lazy, but it's both easy and accurate
syntax sync fromstart

syn keyword pegCommentTodo          TODO FIXME XXX TBD contained
syn region  pegComment              start=/^;/ end=/\n/ contains=@Spell,pegCommentTodo
syn region  pegRule                 start=/^[A-Z][A-Za-z0-9_]*\ze\s*←/ end=/\s*\zs.*\n\([ \t].*\n\)*/ contains=ALLBUT,pegRule
syn 
"syn match   pegProperty             /←\s*\zs.*\n\([ \t].*\n\)*/

hi def link pegCommentTodo          Todo
hi def link pegComment              Comment
hi def link pegRule                 Identifier
hi def link pegProperty             Constant
"hi def link pegCharset              Define
