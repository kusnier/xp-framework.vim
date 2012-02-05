" Vim filetype plugin
" Language:     xp-framework
" Author:       Sebastian Kusnier <seek@matrixcode.de>
" Version:      1.0.3
" License:      MIT


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


function! s:SetPath(path)
  if isdirectory(expand(a:path))
    let cmd = 'setlocal path+=' . escape(a:path, '\ ')
    execute cmd
  endif
endfunction


setlocal path=.

for inc in g:xp_project_inc + g:xp_global_inc
  call s:SetPath(inc)
endfor

" Load path files
for fn in split(glob('*.pth'))
  for line in readfile(fn)
    call s:SetPath(line)
  endfor
endfor


" vim:set sw=2:
