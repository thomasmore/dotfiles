local wk = require('which-key')
wk.setup()

wk.register {
  ['<leader>g'] = { name = '+Git/Grep' },
  ['<leader>w'] = { name = '+Wiki' },
  ['<leader>l'] = { name = '+LSP' },
  ['<leader>c'] = { name = '+CMake' },
}
