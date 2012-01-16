" Vim filetype plugin
" Language:   xp-framework
" Author:       Sebastian Kusnier <seek@matrixcode.de>
" Version:      1.0.1
" License:      MIT

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
