# telescope-git-log
* This is an integration plugin with [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Installation
* vim-plug
```
Plug 'nvim-telescope/telescope.nvim'
Plug 'senkentarou/telescope-git-log.nvim'
```

## Setup
* Please setup as telescope extension on `init.lua` as below:
```
local telescope = require("telescope")

telescope.setup {
  ...
}

telescope.load_extension("git_log")
```

## Commands
* example:
```
:lua require('telescope').extensions.git_log.list_commits_on_file()
```

* `commit`: show commit on file (`<CR>`)
* `blob`: show blob on file (insert: `<C-o>`, normal: o)
* `compare` show compare current commit and former one on file (insert: `<C-p>`, normal: p)


## For development
* Load under development plugin files on root repository.
* `nvim --cmd "set rtp+=."`

## Special thanks
* this extension is very inspired by https://github.com/aaronhallaert/advanced-git-search.nvim
