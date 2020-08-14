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
  exec "normal! \<esc>gv"
  if mode() ==# 'V'
    " Remove the ending newline
    exec "normal! \<esc>`<v`>$h"
  endif
  exec "normal! \<esc>"

  exec "normal! `<"
  let s:selection_start = getpos('.')

  exec "keeppatterns normal! v`>l"
  call search('[^\n]', 'b')
  let s:selection_end = getpos('.')

  exec "normal! \<esc>"

  " Restore the cursor position like nothing ever happened
  call setpos('.', l:pos)
endfunc

func! stagehand#restore_selection()
  call setpos('.', s:selection_start)
  exec "normal! v"
  call setpos('.', s:selection_end)
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
    return
  endif

  let l:bufnr = bufnr('%')
  let l:pos = getpos('.')

  " Copy everything from backstage
  exec "normal! gg0vG$"
  call search('[^\n]', 'b')
  exec "normal! y"

  " Don't wipe everything in case of no exit
  setl bufhidden=hide
  exec ':b ' . b:original

  " TODO: Figure out why deleting everything fails to paste

  " Replace the old section (and update our gv)
  call stagehand#restore_selection()
  exec "normal! \"_dPv`]\<esc>"

  " Renew our saved selection in case of no exit
  call stagehand#store_selection()

  exec ':b ' . l:bufnr
  call setpos('.', l:pos)
  setl bufhidden=wipe
endfunc

" Close the curtains and get ready to make the magic happen
func! stagehand#close_curtains()
  " Save the selected region so we don't lose our place
  call stagehand#store_selection()

  let l:output = stagehand#wrap_register('"', funcref('stagehand#get_selection'))

  let l:bufnr = bufnr('%')
  let l:ft = &filetype

  " Create the buffer
  exec 'new backstage'
  setl nobuflisted noswapfile buftype=acwrite bufhidden=wipe

  call setline(1, l:output)

  " TODO: Remove undo history from new buffer
  " exec "set ul=-1 | m-1 | let &ul=" . &ul

  let b:original = l:bufnr

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
