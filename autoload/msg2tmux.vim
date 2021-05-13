" TODO: Escape the dash character properly!
" INFO: This function is an ugly workaround (required for
" lua support). I couldn't find a way to properly solve
" this problem.
function! msg2tmux#escape_dash_first_char(line) abort
" Escape the dash symbol if it's the first character
" of the line.
" `line`: string
  let l:line = a:line
  if l:line[0] == "-"
    let l:line = ' ' . l:line
  endif
  return l:line

endfunction

function! msg2tmux#insert_line_breaks(lines, target) abort
  " Inserts line breaks into the message
  " `lines`: list of strings
  " `target`: string - target pane

  let l:tmux_line_break = "C-o Down"

  if g:msg2tmux_current_code_block_language == "r"
    let l:tmux_line_break = "Enter"
  endif

  let l:tmux_line_break_cmd = ' \; send-keys -t ' . a:target . " " . l:tmux_line_break . ' \; send-keys -l -t ' . a:target . " "

  call map(a:lines, { _, line -> shellescape(msg2tmux#escape_dash_first_char(line), 1) })
  " INFO: The extra `l:tmux_line_break` at the end of the file
  " is necessary for python code input where the least line is indented
  " TODO: remove this workaround later
  let s:msg = join(a:lines, l:tmux_line_break_cmd)

  if g:msg2tmux_current_code_block_language == "python"
      return s:msg . '\; send-keys -t ' . a:target . l:tmux_line_break
  else
    return s:msg
  endif

endfunction

function! msg2tmux#send_keys_to_tmux_pane(message, opts = {}) abort
  " Sends that selected message to a tmux pane of the current window
  " `message`: list of strings - the message to send
  " `opts`: a dict of options for the `tmux send-keys` command
  "   `tmux_command_end`: string - the key(s) to send after the message
  "   `pane`: number - id of the tmux pane

  let l:default_opts = {
        \ "command_end":"Enter",
        \ "pane":"+"
        \ }
  let l:command_end = get(a:opts, "command_end", l:default_opts["command_end"])
  let l:pane = get(a:opts, "pane", l:default_opts["pane"])

  let l:tmux_command_start = "tmux send-keys -l -t"
  let l:target_pane = l:pane
  let l:tmux_command_end = '\; send-keys -t ' . l:target_pane . " " . l:command_end
  let l:message = msg2tmux#insert_line_breaks(a:message, l:target_pane)
  call execute('!' . join([l:tmux_command_start, l:target_pane, l:message , l:tmux_command_end], " "), "silent")
endfunction

 function! msg2tmux#send_selection_to_tmux_pane() abort
  let l:message = split(@v, "\n")
  call msg2tmux#send_keys_to_tmux_pane(l:message)
 endfunction
