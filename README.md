## yadm-git.vim

Integrates [`yadm`](https://github.com/TheLocehiliosan/yadm) with [`vim-fugitive`](https://github.com/tpope/vim-fugitive) and [`vim-gitgutter`](https://github.com/airblade/vim-gitgutter) so you can manage your dotfiles without leaving vim.

Whenever a buffer is loaded, uses `yadm ls-files` to detect if the current file is tracked by `yadm`. If it is, this:

- runs `FugitiveDetect` from [`vim-fugitive`](https://github.com/tpope/vim-fugitive), so fugitive can act on the `yadm` git repo. All fugitive bindings stay the same
- sets `g:gitgutter_git_executable` to `yadm`, which causes [`vim-gitgutter`](https://github.com/airblade/vim-gitgutter) to show changed git hunks using `yadm`

When you stop editing the dotfile (switch to a file which `yadm` isn't tracking), it resets them back to the defaults (Fugitive does that automatically).

Note: for gitgutter, you might prefer to switch to [gitsigns](https://github.com/lewis6991/gitsigns.nvim), which provides yadm support out of the box

## Install

This uses [`jobstart`](https://neovim.io/doc/user/builtin.html#jobstart()), so it requires `neovim`. Am quite new to writing plugins, so would appreciate feedback and/or direction on compatibility with vim

Should work with all vim plugin managers -- load the file in `plugin`

Using [`vim-plug`](https://github.com/junegunn/vim-plug)

```
Plug 'seanbreckenridge/yadm-git.vim'
```

To configure:

```vimscript
let g:yadm_git_enabled = 1
let g:yadm_git_verbose = 0

let g:yadm_git_fugitive_enabled = 1
let g:yadm_git_gitgutter_enabled = 1

let g:yadm_git_repo_path = "~/.local/share/yadm/repo.git"
let g:yadm_git_default_git_path = "git"
```

Using [`packer`](https://github.com/wbthomason/packer.nvim):

```lua
require('packer').startup(function(use)
    ...
    use 'seanbreckenridge/yadm-git.vim'
    ...
end)

-- configure
vim.g.yadm_git_gitgutter_enabled = 1
vim.g.yadm_git_verbose = 1
```

### Known Issues

Sometimes when switching back to a git repository from a dotfile, GitGutter doesn't redraw the hunks. This can be fixed by running `:GitGutter` to force a redraw
