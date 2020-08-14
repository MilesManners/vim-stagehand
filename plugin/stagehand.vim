" stagehand.vim - stage code behind a curtain
" Author:  Miles Manners <https://repo.dmm.gg>
" Version: 1.0

if exists("g:loaded_stagehand") | finish | endif
let g:loaded_stagehand = 1

let s:cpo_save = &cpo
set cpo&vim

" Saves the current gv, excluding the newline at the end of V-LINE
func! Store_selection()
  " Store the cursor position so we can restore it later
  let l:pos = getpos('.')

  " Check for V-LINE mode
  exec "normal! gv"
  if mode() ==# 'V'
    " Remove the ending newline
    exec "normal! \<esc>`<v`>$h"
  endif
  exec "normal! \<esc>"

  exec "normal! `<"
  let s:selection_start = getpos('.')

  exec "keeppatterns normal! v`>l?[^\\n]\<cr>\<esc>"
  let s:selection_end = getpos('.')

  " Restore the cursor position like nothing ever happened
  call setpos('.', l:pos)
endfunc

func! Restore_selection()
  call setpos('.', s:selection_start)
  exec "normal! v"
  call setpos('.', s:selection_end)
endfunction

" Protects a register to prevent pollution inside a function
func! Wrap_register(reg, fn)
  " Store the register as a list of lines
  let [l:contents, l:type] = [getreg(a:reg), getregtype(a:reg)]
  try
    return a:fn()
  finally
    " Restore the register to its original value
    call setreg(a:reg, l:contents, l:type)
  endtry
endfunc

func! Get_selection()
  exec "normal! gvy"
  return split(getreg('"'), '\n')
endfunc

" Bring those changes out from backstage
func! Open_curtains()
  if ! &modified
    return
  endif

  let l:bufnr = bufnr('%')
  let l:pos = getpos('.')

  " Copy everything from backstage
  exec "normal! gg0vG$y"

  " Don't wipe everything in case of no exit
  setl bufhidden=hide
  exec ':b ' . b:original

  " TODO: Figure out why deleting everything fails to paste

  " Replace the old section (and update our gv)
  call Restore_selection()
  exec "normal! \"_dPv`]\<esc>"

  " Renew our saved selection in case of no exit
  call Store_selection()

  exec ':b ' . l:bufnr
  call setpos('.', l:pos)
  setl bufhidden=wipe
endfunc

" Close the curtains and get ready to make the magic happen
func! Close_curtains()
  " Save the selected region so we don't lose our place
  call Store_selection()

  let l:output = Wrap_register('"', funcref('Get_selection'))

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
    au BufWriteCmd <buffer> call Wrap_register('"', funcref('Open_curtains')) | set nomodified
    au BufWinLeave <buffer> au! stagehandEvents | if exists('#User#StagehandLeave') | do User StagehandLeave | endif
  augroup END

  " Allow opening the curtains with no error messages
  set nomodified
  exec "set filetype=" . ft

  if exists('#User#StagehandEnter')
    do User StagehandEnter
  endif
endfunc

vnoremap <silent> <Plug>CloseCurtains :<C-u>call Close_curtains()<CR>
vmap s <Plug>CloseCurtains

let &cpo = s:cpo_save
unlet s:cpo_save
