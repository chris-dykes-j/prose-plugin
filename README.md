# Prose Plugin
Personal plugin for writing fiction in NeoVim. Written partly to reduce keystrokes but mostly for fun.

## TODO
- [x] Organize the structure.
- [x] Get it to work with my nvim config.
- [ ] Add a toggle.
- [ ] Add auto caps at beginning of sentence.
- [ ] Add options.
  - [ ] Em dash could be two hyphens instead.
  - [ ] Quotes could have modes 'minimal,' 'exhaustive,' and 'custom' for the dialogue tag lists (likely not necessary but interesting to implement).
    - [ ] Combination of 'exhaustive' plus 'custom.'
- [ ] Extend quotes functionality.
  - [ ] Interactivity to cover edge cases. ("Blah blah," she said. She did some gesture or action in between the dialogue. "Blah blah blah, blah blah blah blah.")

## How to setup
Some keymaps to use for formatting.

```lua
local prose = require 'prose'

-- Quotations
vim.keymap.set('n', '<C-q>', function() prose.quote:add_quotations() end, { desc = 'Add quotation marks to current line' })
vim.keymap.set('i', '<C-q>', function() prose.quote:add_quotations() end, { desc = 'Add quotation marks to current line' })
vim.keymap.set('x', 'q', function() prose.quote:add_quotes_to_selection() end, { desc = 'Add quotation marks to the current selection line by line' })

-- Italics
vim.keymap.set('n', '<C-i>', function() prose.italicize:italicize() end, { desc = 'Italicize current line' })
vim.keymap.set('i', '<C-i>', function() prose.italicize:italicize() end, { desc = 'Italicize current line' })
```
