"""md_codeblock_support.vim - Functions related to codeblock support in markdown files

let s:languages = {
      \ "py": "python",
      \ "python": "python",
      \ "r": "r",
      \ "{r}": "r",
      \ "R": "r",
      \ "{R}": "r",
      \ "javascript": "javascript",
      \ "js": "javascript",
      \ "bash": "bash",
      \ }
let s:languages_pattern = '\(' . join(keys(s:languages), '\|') . '\)'
let s:vimux_markdown_code_block_start_pattern='```' . s:languages_pattern . '\n'
let s:vimux_markdown_code_block_end_pattern='```\n'



function! md_codeblock_support#send_code_block_to_tmux_pane(pane="+")
  " Send the content of the markdown code block
  " to the selected tmux pane 
  "
  " pane: string, by default it's the next pane's id

  let l:original_pos=getcurpos()[1:-1]
  let l:first_line_in_block = search(s:vimux_markdown_code_block_start_pattern, 'Wb') + 1

  "get language from the code block
  let s:block_language = matchstr(getline(l:first_line_in_block-1), s:languages_pattern)
  let g:msg2tmux_current_code_block_language = get(s:languages, s:block_language)

  let l:last_line_in_block = search(s:vimux_markdown_code_block_end_pattern, 'W')-1
  let l:block_text=getline(l:first_line_in_block,l:last_line_in_block)
  call cursor(original_pos)

  call msg2tmux#send_keys_to_tmux_pane(l:block_text, {"pane": a:pane})
endfunction

function! md_codeblock_support#find_next_block(stop_at_the_end=1)
  let l:flag = a:stop_at_the_end ? "Wn" : "wn"
  let l:next_codeblock_first_line = search(s:vimux_markdown_code_block_start_pattern, l:flag)+1

  if l:next_codeblock_first_line is 1
    "if there's no match, it returns 0
    return 0
  else
    return  l:next_codeblock_first_line
  endif
endfunction

function! md_codeblock_support#find_previous_block()
  let l:original_pos = getcurpos()[1:-1]
  let l:next_codeblock_first_line = search(s:vimux_markdown_code_block_end_pattern, "Wb")-1
  if l:next_codeblock_first_line is -1 | return 0 | endif
  let l:next_codeblock_first_line = search(s:vimux_markdown_code_block_start_pattern, "Wnb")+1
  call cursor(l:original_pos)

  if l:next_codeblock_first_line is 0
    "if there's no match, it returns 0
    return 0
  else
    return  l:next_codeblock_first_line
  endif
endfunction

function! md_codeblock_support#jump_to_next_block(stop_at_the_end=1)
  let l:next_codeblock_first_line = md_codeblock_support#find_next_block(a:stop_at_the_end)
  if l:next_codeblock_first_line isnot 0
    call cursor(l:next_codeblock_first_line,1)
  else
    let l:answer = input("No more code blocks in the rest of the file. Do you want to start from the beginning? [y/n] ")
    redraw
    echo
    if l:answer is "y"
      call md_codeblock_support#jump_to_next_block(0)
    endif
  endif
endfunction

function! md_codeblock_support#jump_to_previous_block()
  let l:next_codeblock_first_line = md_codeblock_support#find_previous_block()
  if l:next_codeblock_first_line isnot 0
    call cursor(l:next_codeblock_first_line,1)
  else
    echo "No more previous code blocks."
  endif
endfunction

function! md_codeblock_support#send_all_code_blocks_to_tmux_pane() abort
  let l:original_pos= getcurpos()[1:-1]

  call cursor(1,1)

  " Find next code block and execute it if it exists
  function! s:execute_next_code_block() abort
    let l:next_codeblock_exists=md_codeblock_support#find_next_block()
    if l:next_codeblock_exists isnot 0
      call md_codeblock_support#jump_to_next_block()
      call md_codeblock_support#send_code_block_to_tmux_pane()
      call s:execute_next_code_block()
    else
      echo "Every code block have been executed."
    endif
  endfunction

  call s:execute_next_code_block()
  delfunction s:execute_next_code_block

  call cursor(l:original_pos)

  unlet l:original_pos
endfunction

function! md_codeblock_support#send_previous_code_blocks_to_tmux_pane()
  " TODO: Fix this function
  let l:original_pos= getcurpos()[1:-1]

  call cursor(1,1)

  " Find next code block and execute it if it exists
  function! s:execute_next_code_block_for_prev_all() closure
    let l:next_codeblock=md_codeblock_support#find_next_block()

    " Execute the previous code Blocks
    if (l:next_codeblock isnot 0) && (l:next_codeblock <= l:original_pos[0])
      call md_codeblock_support#jump_to_next_block()
      call md_codeblock_support#send_code_block_to_tmux_pane()
      call s:execute_next_code_block_for_prev_all()
    else
      echo "All the previous code blocks have been executed."
    endif
  endfunction

  call s:execute_next_code_block_for_prev_all()
  call cursor(l:original_pos)

endfunction
