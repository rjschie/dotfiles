
"
" Add the "util" import
"
function! AddUtilImport()
  g/utils\/factory/d

  if !search('import.*\.\./utils/core-utilities', 'n')
    call append(1, "import util from '../utils/core-utilities';")
  endif
endfunction


"
" Remove any comment block on top and make sure others
" that are "/* */" become "/** */"
"
function! CleanupComments()
  %s/\/\*\*\@!\(\_.\{-}\)\*\//\/**\1*\//ge
  %s/\/\*\_.*\*\/\n\(export\sdefault\)/\1/e
endfunction


"
"Add a blank line beneath Attributes comment section
"
function! AddLineAfterAttributes()
  if !search('// Attributes\n^$', 'n')
    if search('// Attributes')
      execute "normal! o\<esc>0d$"
    endif
  endif
endfunction


"
" Move "param" to just below attributes
"
function! MoveToAttributes(param, default)
  if search('// Attributes\n^$\n\s*'.a:param.'(.*) {')
    return 0
  endif

  if search('\<'.a:param.'.*{$', 'e')
    normal! V%"cd
    let clip = @c
  elseif search('\<'.a:param.'.*,$', 'e')
    normal! V"cd
    let clip = @c
  endif

  if !exists('clip')
    let clip = a:param."() {\n  return ".a:default.";\n},"
  endif

  let attrPos=search('// Attributes', 'n') + 1
  call append(attrPos, split(clip, '\n'))
endfunction


"
" Move the Links
"
function! MoveLinks()
  let clip = '_links: {},'

  if search('_links(.*) {', 'e') || search('_links\s*:\s*{', 'e')
    normal! V%"cd
    let clip = @c
  endif

  if search('updatedAt(.*) {', 'e')
    normal! %
    call append(line('.'), '')
    call append(line('.'), split(clip, '\n'))
    call append((line('.')), '')
  endif
endfunction


"
" Convert normal props to methods, except "_links"
"
function! ConvertPropToMethod()
  %s/^\s\s\(_links\)\@!\(\w*\)\s*:\s*\(.*\),/\2() {\r  return \3;\r},/eg
endfunction


"
" Cleanup blank new lines
"
function! CleanNewLines()
  %s/\(},$\)\n*/\1\r/ge
endfunction


"
" Sort Functions
"
function! SortFunctions()
  g/^\s\s\w.*{$/;/^\s\s},/-1s/\n/@@@
  /_links/;/^$\n/;/^});$/sort
  %s/@@@/\r/ge
endfunction


"
"Begin calling
"
call AddLineAfterAttributes()
call AddUtilImport()
call CleanupComments()

call MoveToAttributes('updatedAt', 'this.createdAt')
call MoveToAttributes('createdAt', 'util.date.past(1)')
call MoveToAttributes('id', 'faker.random.uuid()')

call ConvertPropToMethod()
call CleanNewLines()
call MoveLinks()
call AddLineAfterAttributes()

normal! gg=G

call SortFunctions()
