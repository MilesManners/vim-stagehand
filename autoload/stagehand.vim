" stagehand.vim - stage code behind a curtain
" Author:  Miles Manners <https://repo.dmm.gg>
" Version: 1.1

if exists("g:loaded_stagehand") | finish | endif
let g:loaded_stagehand = 1

let s:cpo_save = &cpo
set cpo&vim

" Saves the current gv, excluding the newline at the end of V-LINE
func! stagehand#store_selection()
  " Store the cursor position so we can restore it later
  let l:pos = getpos('.')

  " Check for V-LINE mode
  if visualmode() ==# 'V'
    " Convert V-LINE to VISUAL
    exec "normal! `<v`>$\<esc>"
  endif

  exec "normal! `<"
  let l:start = getpos('.')

  exec "keeppatterns normal! v`>l"
  call search('[^\n]', 'b')
  let l:end = getpos('.')

  exec "normal! \<esc>"

  " Restore the cursor position like nothing ever happened
  call setpos('.', l:pos)

  return [l:start, l:end]
endfunc

func! stagehand#restore_selection(selection)
  let result = setpos('.', a:selection[0])
  if result == -1
    return -1
  endif
  exec "normal! v"
  return setpos('.', a:selection[1])
endfunction

" Protects a register to prevent pollution inside a function
func! stagehand#wrap_register(reg, fn)
  " Store the register as a list of lines
  let [l:contents, l:type] = [getreg(a:reg), getregtype(a:reg)]
  try
    return a:fn()
  finally
    " Restore the register to its original value
    call setreg(a:reg, l:contents, l:type)
  endtry
endfunc

func! stagehand#get_selection()
  exec "normal! gvy"
  return split(getreg('"'), '\n')
endfunc

" Bring those changes out from backstage
func! stagehand#open_curtains()
  if ! &modified
    return 0
  endif

  let l:bufnr = bufnr('%')
  let l:pos = getpos('.')
  let l:selection = b:selection

  " Copy everything from backstage
  exec "normal! gg0vG$"
  call search('[^\n]', 'b')
  exec "normal! y"

  " Don't wipe everything in case of no exit
  setl bufhidden=hide
  exec ':b ' . b:original

  " TODO: Figure out why deleting everything fails to paste

  " Replace the old section (and update our gv)
  call stagehand#restore_selection(l:selection)
  exec "normal! \"_dPv`]\<esc>"

  " Renew our saved selection in case of no exit
  let l:selection = stagehand#store_selection()

  call setpos('.', l:pos)
  setl bufhidden=wipe
  let b:selection = l:selection
endfunc

" Close the curtains and get ready to make the magic happen
func! stagehand#close_curtains()
  " Save the selected region so we don't lose our place
  let l:selection = stagehand#store_selection()

  let l:output = stagehand#wrap_register('"', funcref('stagehand#get_selection'))

  let l:bufnr = bufnr('%')
  let l:ft = &filetype

  " Create the buffer
  exec 'new backstage'
  setl nobuflisted noswapfile buftype=acwrite bufhidden=wipe

  call setline(1, l:output)

  " TODO: Remove undo history from new buffer
  " exec "set ul=-1 | m-1 | let &ul=" . &ul
  let old_ul = &ul
  set ul=-1
  exe "normal a \<bs>\<esc>"
  let &ul = old_ul
  unlet old_ul

  let b:original = l:bufnr
  let b:selection = l:selection

  augroup stagehandEvents
    au!
    " Replace saving with opening the curtains
    au BufWriteCmd <buffer> call stagehand#wrap_register('"', funcref('stagehand#open_curtains')) | set nomodified
    au BufWinLeave <buffer> au! stagehandEvents | if exists('#User#StagehandLeave') | do User StagehandLeave | endif
  augroup END

  " Allow opening the curtains with no error messages
  set nomodified
  exec "set filetype=" . ft

  if exists('#User#StagehandEnter')
    do User StagehandEnter
  endif
endfunc

let &cpo = s:cpo_save
unlet s:cpo_save
