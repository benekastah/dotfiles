
" Vim session config
let g:session_autosave = 'yes'
let g:session_autoload = 'no'

" Git vim sessions
function! Strip(input_string)
    return substitute(a:input_string, '^\_s*\(.\{-}\)\_s*$', '\1', '')
endfunction

function! s:getCurrentGitBranch()
    let l:result = system("git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* //'")
    return Strip(l:result)
endfunction

function! s:getGitDirectory(...)
    let l:result = system('git rev-parse --show-toplevel')
    return Strip(l:result)
endfunction

function! s:getSafeGitDirectory()
    let l:result = s:getGitDirectory()
    return substitute(l:result, '/', '-', 'g')
endfunction

function! s:getGitSessionName(...)
    if a:0 ># 0
        let l:branch = a:1
    else
        let l:branch = s:getCurrentGitBranch()
    endif
    let l:dir = s:getSafeGitDirectory()
    return l:dir . '_' . l:branch
endfunction

let s:save_session_command = 'SaveSession'
function! s:saveGitSession(...)
    let name = call(function('s:getGitSessionName'), a:000)
    execute s:save_session_command name
endfunction

let s:open_session_command = 'OpenSession'
function! s:openGitSession(...)
    let name = call(function('s:getGitSessionName'), a:000)
    execute s:open_session_command name
endfunction

function! s:sessionGitCheckout(branch)
    let l:currentBranch = s:getCurrentGitBranch()
    let l:checkoutResult = system('git checkout ' . shellescape(a:branch))
    if v:shell_error
        echo l:checkoutResult
        return
    endif
    call s:saveGitSession(l:currentBranch)
    CloseSession
    try
        " Will fail if that git branch has no session
        call s:openGitSession()
    endtry
endfunction

command! -nargs=1 Gsc call s:sessionGitCheckout(<f-args>)

command! -nargs=* -bang Gss let s:save_session_command = 'SaveSession<bang>' | call s:saveGitSession(<f-args>) | let s:save_session_command = 'SaveSession'
command! -nargs=* -bang SGss silent<bang> Gos <args>

command! -nargs=* -bang Gos let s:open_session_command = 'OpenSession<bang>' | call s:openGitSession(<f-args>) | let s:open_session_command = 'OpenSession'
command! -nargs=* -bang SGos silent<bang> Gos <args>

command! -nargs=* Gsn echo s:getGitSessionName(<f-args>)

" if !len(argv())
"     silent call s:openGitSession()
" endif
