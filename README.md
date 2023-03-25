# reviewer.nvim

> **Warning**: This plugin is still in early development, expect features to change and even break.

Review code inside your favourite editor without ever having to leave it, the future is here.

Powered by the awesome [diffview.nvim](https://github.com/sindrets/diffview.nvim) plugin :tada:

## Installation

```lua
-- lazy.nvim
require('lazy').setup({{
    'zapling/reviewer.nvim',
    dependencies = {'sindrets/diffview.nvim', 'nvim-lua/plenary.nvim'}
}})
```

## Setup

```lua
require('reviewer').setup({
    providers = {
        gitlab = {opts = {access_token = os.getenv("GITLAB_ACCESS_TOKEN")}}
    }
})
```

## Usage

- `:Review` show a diff between the current branch and main
- `:Reivew stop` close the diff
