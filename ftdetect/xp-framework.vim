" xp-framework.vim - file type detect plugin for vim which detects xp-framework
" Author:       Sebastian Kusnier <seek@matrixcode.de>
" Version:      1.0.2
" License:      MIT
"
" Install via pathogen by cloning/adding submodule in ~/.vim/bundle or
" by dropping this script in ~/vim/ftdetect
"
function DetectXPFramework()
  if getline(2) =~ '^\/\* This class is part of the XP framework$'
    set ft=php.xp-framework syntax=php
  endif
endfunction

autocmd BufNewFile,BufRead *.php call DetectXPFramework()

" vim:set sw=2:
