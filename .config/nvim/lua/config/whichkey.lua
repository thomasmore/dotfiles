local wk = require('which-key')
wk.setup { notify = false }

wk.add {
  {'<leader>g', group = 'Git/Grep' },
  {'<leader>w', group = 'Wiki' },
  {'<leader>l', group = 'LSP' },
  {'<leader>c', group = 'CMake' },
  {'<leader>a', group = 'Opencode' },
}
