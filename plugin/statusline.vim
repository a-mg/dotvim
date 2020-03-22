set laststatus=2                                " always show statusline

let statusline_on   = ""
let statusline_on  .= "%#MySLPath#"
let statusline_on  .= " %f "                    " path (relative to pwd)
let statusline_on  .= "%#StatusLine#"
let statusline_on  .= " "
let statusline_on  .= "%#MySLMod#"
let statusline_on  .= "%m"                      " modified
let statusline_on  .= "%#StatusLine#"
let statusline_on  .= "%{Git()}"                " git status
let statusline_on  .= "%="                      " right align
let statusline_on  .= "%y"                      " filetype
let statusline_on  .= "%{Enc()}"                " encoding
let statusline_on  .= " "
let statusline_on  .= "%12("                    " ruler group:
let statusline_on  .= "%c:"                     " current column
let statusline_on  .= "%l/"                     " current line
let statusline_on  .= "%L"                      " total lines
let statusline_on  .= "%)"
let statusline_on  .= " "

let statusline_off  = " "
let statusline_off .= "%f"                      " path (relative to pwd)
let statusline_off .= "%m"                      " modified

let statusline_ui   = ""
let statusline_ui  .= "%#MySLPath#"
let statusline_ui  .= "%y"                      " filetype
let statusline_ui  .= "%#StatusLine#"



function! Enc() abort
  return "[" . (&fileencoding ? &fileencoding : &encoding) . "]"
endfunction

function! Git() abort
  let l:branch = FugitiveStatusline()
  if l:branch ==? ""
    return ""
  else
    let l:git = "[" . matchstr(l:branch, "(\\zs.*\\ze)") . "]"
    let [a,m,r] = GitGutterGetHunkSummary()
    let l:git .= printf('[+%d,~%d,-%d]', a, m, r)
    return l:git
  endif
endfunction



hi link MySLPath WildMenu
hi link MySLMod  CursorLineNr

let s:ignore = ["fugitive", "netrw"]

augroup Statusline
  au!
  au WinEnter,BufEnter * 
        \ if index(s:ignore, &ft) < 0
        \ | setlocal statusline=%!statusline_on
        \ | endif
  au WinLeave,BufLeave * setlocal statusline=%!statusline_off
  au FileType netrw,fugitive setlocal statusline=%!statusline_ui
augroup END