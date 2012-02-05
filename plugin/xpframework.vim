" Vim filetype plugin
" Language:     xp-framework
" Author:       Sebastian Kusnier <seek@matrixcode.de>
" Version:      1.0.3
" License:      MIT

if exists('g:loaded_xpframework') || &cp || v:version < 700
  finish
endif
let g:loaded_xpframework = 1

let g:xp_global_inc= [
  \'~/devel/xp-framework/core/src/main/php',
  \'~/devel/xp-framework/tools/src/main/php'
\]

let g:xp_project_inc= []

let g:xp_root_markers = ['xpinstall/', 'ivy.xml', 'changelog']

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
  let cmd = 'ctags --append=yes --sort=yes --fields=l --PHP-kinds=+cfidv -R -f '.a:tagsfile.' '.a:dir
  let output = system(cmd)
  if v:shell_error
    let msg = "Failed to update tags file %s: %s!"
    throw printf(msg, fnamemodify(a:tagsfile, ':~'), strtrans(output))
  endif
endfunction

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
  echo 'Project path: ' s:GetProjectPath()
endfunction

command! Xptags call s:GenerateXpTags()
command! Xpwd call s:PrintProjectPath()
