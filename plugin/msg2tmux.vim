" Vim global plugin for sending code to tmux
" from markdown codeblocks or visual selection
"
" Maintainer: Fülöp Kovács
" Repository: https://github.com/fulopkovacs/msg2tmux.vim
" License: MIT


let g:msg2tmux_current_code_block_language = ""

if !hasmapto('<Plug>SendCodeBlockToTmuxPane')
  map <LocalLeader>cc <Plug>SendCodeBlockToTmuxPane
endif

if !hasmapto('<Plug>JumpToNextCodeBlock')
  map <LocalLeader>jj <Plug>JumpToNextCodeBlock
endif

if !hasmapto('<Plug>JumpToPreviousCodeBlock')
  map <LocalLeader>kk <Plug>JumpToPreviousCodeBlock
endif

if !hasmapto('<Plug>SendAllCodeBlocksToTmuxPane')
  map <LocalLeader>aa <Plug>SendAllCodeBlocksToTmuxPane
endif

if !hasmapto('<Plug>SendPreviousCodeBlocksToTmuxPane')
  map <LocalLeader>pp <Plug>SendPreviousCodeBlocksToTmuxPane
endif

if !hasmapto('<Plug>SendSelectionToTmuxPane')
  vmap <LocalLeader>we <Plug>SendSelectionToTmuxPane
endif

" WARN: experimental, must be tested with all the supported shells!
if !hasmapto('<Plug>ClearPane')
  map <LocalLeader>cl <Plug>ClearPane
endif



noremap <silent> <script> <Plug>SendCodeBlockToTmuxPane :call md_codeblock_support#send_code_block_to_tmux_pane()<CR>

noremap <silent> <script> <Plug>JumpToNextCodeBlock :call md_codeblock_support#jump_to_next_block()<CR>

noremap <silent> <script> <Plug>JumpToPreviousCodeBlock :call md_codeblock_support#jump_to_previous_block()<CR>

noremap <silent> <script> <Plug>SendAllCodeBlocksToTmuxPane :call md_codeblock_support#send_all_code_blocks_to_tmux_pane()<CR>

noremap <silent> <script> <Plug>SendPreviousCodeBlocksToTmuxPane :call md_codeblock_support#send_previous_code_blocks_to_tmux_pane()<CR>

vmap <silent> <script> <Plug>SendSelectionToTmuxPane "vy :call msg2tmux#send_selection_to_tmux_pane()<CR>

" WARN: experimental, must be tested with all the supported shells!
noremap <silent> <script> <Plug>ClearPane :call msg2tmux#send_keys_to_tmux_pane([ "C-l" ], {"command_end": ""})<CR>










" TODO: delete mappings after the development has ended
if !hasmapto('<Plug>Msg2tmuxExample')
   nnoremap <Plug>Msg2tmuxExample :call msg2tmux#example()<CR>
endif

nmap <leader>ee <Plug>Msg2tmuxExample

" Define plugins like this
" if !hasmapto('<Plug>TypecorrAdd')
"   map <unique> <Leader>a  <Plug>TypecorrAdd
" endif


" User can redefine the mapping later
" map ,c  <Plug>TypecorrAdd
