" Vim filetype plugin
" Language:     xp-framework
" Author:       Sebastian Kusnier <seek@matrixcode.de>
" Version:      1.0.2
" License:      MIT

let g:xp_global_inc= [
  \'~/devel/xp-framework/core/src/main/php',
  \'~/devel/xp-framework/tools/src/main/php'
\]

let g:xp_project_inc= []

let g:xp_root_markers = ['xpinstall/', 'ivy.xml', 'changelog']

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

function! s:GetProjectPath()
    let cph = expand('%:p:h', 1)
    if match(cph, '\v^<.+>://') >= 0 | return | endif
    for marker in g:xp_root_markers
        let wd = call('find'.(marker =~ '/$' ? 'dir' : 'file'), [marker, cph.';'])
        if wd != '' | let &autochdir = 0 | break | endif
    endfor
"    execute 'lcd!' fnameescape(wd == '' ? cph : substitute(wd, marker.'$', '.', ''))
    let wd = fnameescape(wd == '' ? cph : substitute(wd, marker.'$', '', ''))
    if wd != '' | return wd | endif
    return '.'
endfunction

function! s:GenerateTags(tagsfile, dir)
  let cmd = '/usr/local/bin/ctags --append=yes --sort=yes --fields=l --PHP-kinds=+cfidv -R -f '.a:tagsfile.' '.a:dir
  let output = system(cmd)
  if v:shell_error
    let msg = "Failed to update tags file %s: %s!"
    throw printf(msg, fnamemodify(a:tagsfile, ':~'), strtrans(output))
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

function! s:GenerateXpTags()
  let cmd = 'lcd '.s:GetProjectPath()
  execute cmd

  call delete("tags")
  call writefile([], "tags", "b")

  for fn in split(glob('*.pth'))
    for line in readfile(fn)
      echo "UpdateTags: " . line
      call s:GenerateTags('tags', line)
    endfor
  endfor

  for inc in g:xp_project_inc + g:xp_global_inc
    echo "UpdateTags Global: " . inc
    call s:GenerateTags('tags', inc)
  endfor

  echo "Update xptags done."
endfunction

function! s:PrintProjectPath() 
endfunction

command! Xptags call s:GenerateXpTags()
command! Xpwd call s:PrintProjectPath()

" vim:set sw=2:
