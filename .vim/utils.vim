function! GetVisualSelection()
    " Why is this not a built-in Vim script function?!
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
endfunction
command! GetVisualSelection echo GetVisualSelection()

" Timers
let s:interval_id = 1
let s:intervals = {}
function! SetInterval(ms, action) abort
    let interval_id = s:interval_id
    let s:interval_id += 1
    let jobname = 'SetInterval_'.interval_id
    let jobid = jobstart(jobname, &shell, [
        \ '-c', 'while true; do sleep '.(a:ms / 1000).'; echo "ping"; done'])
    exe 'augroup '.jobname.' | augroup END'
    exe 'au '.jobname.' JobActivity '.jobname.' '.a:action
    let s:intervals[interval_id] = {
        \ 'jobid': jobid,
        \ 'interval_id': interval_id,
        \ 'jobname': jobname,
        \ }
    return interval_id
endfunction

function! ClearInterval(interval_id) abort
    if !has_key(s:intervals, a:interval_id)
        return 0
    endif
    let timeout_info = s:intervals[a:interval_id]
    unlet s:intervals[a:interval_id]
    try
        call jobstop(timeout_info.jobid)
    catch '^Vim\%((\a\+)\)\=:E900' | endtry
    exe 'au! '.timeout_info.jobname
    return 1
endfunction

function! SetTimeout(ms, action) abort
    let interval_id = s:interval_id
    let interval_id2 = SetInterval(a:ms, 'call ClearTimeout('.interval_id.') | '.a:action)
    if interval_id !=# interval_id2
        call ClearInterval(interval_id2)
        throw 'Interval ids do not match'
    endif
    return interval_id
endfunction

function! ClearTimeout(timeout_id) abort
    call ClearInterval(a:timeout_id)
endfunction

function! TmuxSplit(opts, cmd, ...)
    if type(a:opts) == type(0)
        let opts = get(g:, 'tmux_split_opts', '')
    else
        let opts = a:opts
    endif
    let splitw = 'tmux split-window '.opts
    if a:0
        let cmd = '_IN=/tmp/$RANDOM; cat > "$_IN"; '.
                \ splitw.' '.shellescape('('.a:cmd.')').
                \ '" < ''$_IN''; rm ''$_IN''"'
        echom 'TmuxSplit '.cmd
        call system(cmd, a:1)
    else
        let cmd = splitw.' '.shellescape(a:cmd)
        echom 'TmuxSplit '.cmd
        call system(cmd)
    endif
endfunction
