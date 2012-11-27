" Fold expressions {{{1
function! StackedChangelgoFolds()
  if HeadingDepth(v:lnum) > 0
    return ">1"
  else
    return "="
  endif
endfunction

function! NestedChangelgoFolds()
  let depth = HeadingDepth(v:lnum)
  if depth > 0
    return ">".depth
  else
    return "="
  endif
endfunction

" Helpers {{{1
function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction

function! HeadingDepth(lnum)
  let level=0
  let thisline = getline(a:lnum)
  if thisline != ''
    let nextline = getline(a:lnum + 1)
    if nextline =~ '^---'
      let level = 1
    endif
  endif
  return level
endfunction

function! s:FoldText()
  let level = HeadingDepth(v:foldstart)
  let indent = repeat('#', level)
  let title = substitute(getline(v:foldstart), '^#\+\s*', '', '')
  let foldsize = (v:foldend - v:foldstart)
  let linecount = '['.foldsize.' line'.(foldsize>1?'s':'').']'
  return indent.' '.title.' '.linecount
endfunction

" API {{{1
function! ToggleChangelgoFoldexpr()
  if &l:foldexpr ==# 'StackedChangelgoFolds()'
    setlocal foldexpr=NestedChangelgoFolds()
  else
    setlocal foldexpr=StackedChangelgoFolds()
  endif
endfunction
command! -buffer FoldToggle call ToggleChangelgoFoldexpr()

" Setup {{{1
if !exists('g:changelog_fold_style')
  let g:changelog_fold_style = 'stacked'
endif

setlocal foldmethod=expr
let &l:foldtext = s:SID() . 'FoldText()'
let &l:foldexpr =
  \ g:changelog_fold_style ==# 'nested'
  \ ? 'NestedChangelgoFolds()'
  \ : 'StackedChangelgoFolds()'

" Teardown {{{1
let b:undo_ftplugin .= '
  \ | setlocal foldmethod< foldtext< foldexpr<
  \ | delcommand FoldToggle
  \ '
" vim:set fdm=marker:
