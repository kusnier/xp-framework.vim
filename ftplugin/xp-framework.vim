" Vim filetype plugin
" Language:     xp-framework
" Author:       Sebastian Kusnier <seek@matrixcode.de>
" Version:      1.0.2
" License:      MIT

let g:xp_global_inc= [
  \'~/devel/xp-framework/core/src/main/php',
  \'~/devel/xp-framework/tools/src/main/php'
\]

let g:xp_project_inc= ['./src']

" adjust indenting
" see: http://developer.xp-framework.net/xml/static?cs/xp_whitespace
setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal smarttab
setlocal smartindent

" adjust path
" This is a list of directories which will be searched when using
" the |gf|, [f, ]f, ^Wf, |:find|, |:sfind|, |:tabfind| and other commands

setlocal include=^\\s\\+'\\(\\w\\+\\.\\)\\+\\w\\+'\\,\\?$
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal suffixesadd=.class.php

setlocal path=.,src

for inc in g:xp_global_inc + g:xp_project_inc
  if isdirectory(expand(inc))
    let cmd = 'setlocal path+=' . escape(inc, '\ ')
    execute cmd
  endif
endfor


" vim:set sw=2:
