" use 'yadm ls-files' to detect if the current file
" being edited is tracked as a file by yadm
"
" if we're editing a dotfile,
" patch git executable path for git fugitive and git gitter

if exists('g:loaded_yadm_git')
  finish
endif
let g:loaded_yadm_git = 1

let s:has_yadm = executable('yadm')

let g:yadm_git_repo_path = get(g:, "yadm_git_repo_path", "~/.local/share/yadm/repo.git")
let g:yadm_git_enabled = get(g:, "yadm_git_enabled", 1)

let g:yadm_git_fugitive_enabled = get(g:, "yadm_git_fugitive_enabled", 1)
let g:yadm_git_gitgutter_enabled = get(g:, "yadm_git_gitgutter_enabled", 1)
let g:yadm_git_default_git_path = get(g:, "yadm_git_default_git_path", "git")

function! s:yadm_check_file()
  if !g:yadm_git_enabled
    return
  endif
  if !s:has_yadm
    echo 'Could not find yadm executable'
    return
  endif
  let s:filepath = expand('%:p')
  if filewritable(s:filepath) != 1
    return
  endif
  " use yadm ls-files to check if the current file is tracked by yadm
  " jobstart runs async
  call jobstart(['yadm', 'ls-files', '--error-unmatch', s:filepath], {'on_exit':{j,d,e->s:yadm_callback(d)}})
endfunction

function! s:yadm_patch_plugins()
  let s:yadm_git_verbose = get(g:, "yadm_git_verbose", 0)
  if g:yadm_git_fugitive_enabled
    call FugitiveDetect(g:yadm_git_repo_path)
  endif
  if g:yadm_git_gitgutter_enabled
    let g:gitgutter_git_executable='yadm'
  endif
  if s:yadm_git_verbose
    echo 'yadm: detected file as dotfile'
  endif
endfunction

function! s:yadm_reset_plugins()
  let s:yadm_git_verbose = get(g:, "yadm_git_verbose", 0)
  if g:yadm_git_gitgutter_enabled && g:gitgutter_git_executable == 'yadm'
    let g:gitgutter_git_executable=g:yadm_git_default_git_path
    if s:yadm_git_verbose
      echo 'yadm: reset gitgutter executable path'
    endif
  endif
endfunction

" callback from anonymous function above, receives the exit status
function! s:yadm_callback(exit_status)
  if a:exit_status == 0
    call s:yadm_patch_plugins()
  else
    call s:yadm_reset_plugins()
  endif
endfunction

" for public usage
function! YadmCheckFile()
  s:yadm_check_file()
endfunction

augroup yadm
  autocmd!
  autocmd BufWinEnter * call s:yadm_check_file()
augroup END
