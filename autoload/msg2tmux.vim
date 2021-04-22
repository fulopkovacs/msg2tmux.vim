" TODO: delete this function after testing
function msg2tmux#example() abort
endfunction

function! msg2tmux#insert_line_breaks(lines) abort
  " Inserts line breaks into the message
  " `lines`: list of strings

  let l:tmux_linebreak = " C-o Down "
  let l:lines_with_quotes = map(a:lines, { _, key -> shellescape(key, 1) })
  " INFO: The extra `l:tmux_linebreak` at the end of the file
  " is necessary for python code input where the least line is indented
  " TODO: remove this workaround later
  if len(a:lines) > 1
    return join(a:lines, l:tmux_linebreak) . l:tmux_linebreak
  else
    return join(a:lines, l:tmux_linebreak)
  endif
endfunction

function! msg2tmux#send_keys_to_tmux_pane(message, opts = {}) abort
  " Sends that selected message to a tmux pane of the current window
  " `text`: list of strings - the message to send
  " `tmux_command_end`: string - the key(s) to send after the message
  " `pane`: number - id of the tmux pane

  let l:default_opts = {
        \ "command_end":"Enter",
        \ "pane":"+"
        \ }
  let l:tmux_command_end = get(a:opts, "command_end", l:default_opts["command_end"])
  let l:pane = get(a:opts, "pane", l:default_opts["pane"])

  let l:tmux_command_start = "tmux send-keys -t"
  let l:target_pane = "+." . l:pane " the `+` selects the current window
  let l:message = msg2tmux#insert_line_breaks(a:message)
  " echo '!' . join([l:tmux_command_start, l:target_pane, l:message , l:tmux_command_end], ' ')
  call execute('!' . join([l:tmux_command_start, l:target_pane, l:message , l:tmux_command_end], " "), "silent")
endfunction

 function! msg2tmux#send_selection_to_tmux_pane() abort
  let l:message = split(@v, "\n")
  call msg2tmux#send_keys_to_tmux_pane(l:message)
 endfunction

" TODO: remove the lines below after testing
" let g:test_message = ["for i in range(5):", "  print(\"index: \" + str(i))", "print('done')"]
" call msg2tmux#send_keys_to_tmux_pane(g:test_message, { "pane": 2 })
" call msg2tmux#send_keys_to_tmux_pane(g:test_message)
