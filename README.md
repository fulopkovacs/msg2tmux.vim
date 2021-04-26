<p align="center">
<pre>
  <code>
            _     _
          /   \ /   \
          |    V    |
>>>-VIM--------     /------->
           \  TMUX /
            \     /
             \   /
              \ /
               V
  </code>
</pre>
</p>

# msg2tmux.vim

<span style="color:red">WARNING: This plugin is still in development, and may stuck in this state for ever. If you need something stable and robust you can check out ethese projects](#when-shouldnt-you-use-this-plugin-?) that inspired _msg2tmux_ in the first place.</span>

Transform markdown documents into interactive notebooks with `vim` and `tmux`.

## Use cases
`msg2tmux` is supposed to be a simple and stupid lightweight alternative to `nvim-R` with additional features, like supporting code blocks in non-r-markdown files, and multiple other languages, like `javascript`, `bash`, `python` (but it doesn't support `.ipynb` files, and doesn't plan to).

## When shouldn't you use this plugin?
This plugin is not as robust and stable as other more matured and specialised tools. Here are some good alternatives, that were the inspirations of this project:

- [**Nvim-R**](https://github.com/jalvesaq/Nvim-R): for working with `R` (and R markdown documents)
- [**Vimux**](https://github.com/preservim/vimux): Interact with `tmux` panes from vim
- [**tslime.vim**](https://github.com/preservim/vimux): _"a simple vim script to send portion of text from a vim buffer to a running tmux session"_ (from their [GitHub page](https://github.com/jgdavey/tslime.vim))

## Compatibility with shells and Caveats

This plugin can interact reliably with the following shells:
- `R`
- `radian` - with the following caveat:
  - Bracket completion must be disabled (`options.radian.auto_match = FALSE`). Check out the [docs of radian on modyfing the settings here](https://github.com/randy3k/radian#settings).
- `bash`
- `ipython`

## Supported languages
- `python`
- `R`
- `javascript`
- `bash`

**The `python` shell is not supported**, and I'm not planning to work on it in the future.


## Installation

Compatible with both `vim` (from version `8.0` and above) and `nvim`.

Use your preferred plugin manager, I use [`vim-plug`](https://github.com/junegunn/vim-plug):

```
Plug 'fulopkovacs/msg2tmux'
Plug 'fulopkovacs/msg2tmux'
```

## Features (and default keybindings)

You **must** run `vim` in a tmux session

```
===========================================================
GENERAL

<LocalLeader>we   Send the visual selection to the next
                  tmux pane

===========================================================
MARKDOWN, R-MARKDOWN

<LocalLeader>jj   Jump to next code block

<LocalLeader>kk   Jump to previous code block

<LocalLeader>cc   Execute the current code block in
                  the next tmux pane

<LocalLeader>pp   Execute the current and all previous
                  code blocks in the next tmux pane

<LocalLeader>aa   Execute every code block of the document
                  from the first to the last one in the
                  next tmux pane

<LocalLeader>cl   Sends the `C-l` keystroke to the next tmux
                  pane (usually it clears it)
```


