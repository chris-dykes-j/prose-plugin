# Prose Plugin

## TODO
- [x] Organize the structure.
- [x] Get it to work with my nvim config

## How to setup

```lua
local prose = require 'prose'

vim.keymap.set('n', '<C-q>', function() prose.quote:add_quotations() end, { desc = 'Add quotation marks to current line' })
vim.keymap.set('i', '<C-q>', function() prose.quote:add_quotations() end, { desc = 'Add quotation marks to current line' })
vim.keymap.set('x', 'q', function() prose.quote:add_quotes_to_selection() end, { desc = 'Add quotation marks to the current selection line by line' })

vim.keymap.set('n', '<C-i>', function() prose.italicize:italicize() end, { desc = 'Italicize current line' })
vim.keymap.set('i', '<C-i>', function() prose.italicize:italicize() end, { desc = 'Italicize current line' })
```
