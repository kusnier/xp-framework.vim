" Vim filetype plugin
" Language:   xp-framework
" Author:       Sebastian Kusnier <seek@matrixcode.de>
" Version:      1.0.2
" License:      MIT

" adjust indenting
" see: http://developer.xp-framework.net/xml/static?cs/xp_whitespace
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set smarttab
set smartindent

" adjust path
" This is a list of directories which will be searched when using
" the |gf|, [f, ]f, ^Wf, |:find|, |:sfind|, |:tabfind| and other commands

setlocal include=^\\s\\+'\\(\\w\\+\\.\\)\\+\\w\\+'\\,\\?$
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal suffixesadd=.class.php

setlocal path=.,src

if isdirectory(expand("~/devel/xp-framework/core/src/main/php"))
  setlocal path+=~/devel/xp-framework/core/src/main/php
endif

if isdirectory(expand("~/devel/xp-framework/tools/src/main/php"))
  setlocal path+=~/devel/xp-framework/tools/src/main/php
endif

" vim:set sw=2:
