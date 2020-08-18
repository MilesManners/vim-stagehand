" stagehand.vim - stage code behind a curtain
" Author:  Miles Manners <https://repo.dmm.gg>
" Version: 2.0

if exists("g:loaded_stagehand") | finish | endif
let g:loaded_stagehand = 1

let s:cpo_save = &cpo
set cpo&vim

" Bring those changes out from backstage
func! stagehand#open_curtains()
  if ! &modified
    return 0
  endif

  let l:pos = getcurpos()

  " Copy everything from backstage
  exe "normal! G$"
  let l:text = getline('^', search('[^\n]', 'b'))

  " Deleting/appdending accounts for differing amounts of lines
  call deletebufline(b:original, b:lines[0], b:lines[1])
  call appendbufline(b:original, b:lines[0] - 1, l:text)

  " Renew our saved selection in case of no exit
  let b:lines[1] = b:lines[0] + len(l:text) - 1

  call setpos('.', l:pos)
endfunc

func! s:clear_autocmd()
  au! * <buffer>

  if exists('#User#StagehandLeave') | do User StagehandLeave | endif
endfunc

" Close the curtains and get ready to make the magic happen
func! stagehand#close_curtains()
  let l:pos = getcurpos()

  exe "normal! `>"
  let l:lines = [line("'<"), search('[^\n]', 'b', line("'<"))]

  call setpos('.', l:pos)

  let l:output = getline(l:lines[0], l:lines[1])

  let l:bufnr = bufnr('%')
  let l:ft = &filetype

  exe 'new Backstage@' . l:bufnr . ':' . l:lines[0][1] . '-' . l:lines[1][1]
  exe "set nobl noswf bt=acwrite bh=wipe nomod ft=" . l:ft

  " Remove undo history while adding text to the new buffer
  exe "set ul=-1 | call setline(1, l:output) | let &ul=" . &ul

  let b:original = l:bufnr
  let b:lines = l:lines

  " Replace saving with opening the curtains
  au BufWriteCmd <buffer> call stagehand#open_curtains() | set nomodified
  au BufWinLeave <buffer> call <SID>clear_autocmd()

  if exists('#User#StagehandEnter') | do User StagehandEnter | endif
endfunc

let &cpo = s:cpo_save
unlet s:cpo_save
