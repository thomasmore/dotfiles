local telescope = require('telescope.builtin')
local vgit = require('vgit')
local wk = require('which-key')
local dap = require('dap')
local cmake = require('cmake')
-- TODO: register neoscroll and lightspeed mappings
-- TODO: move lsp-related mappings here
wk.register({
  -- Better arrows and window movement
  ['<up>'] = { '<c-w><up>', 'which_key_ignore' },
  ['<down>'] = { '<c-w><down>', 'which_key_ignore' },
  ['<left>'] = { '<c-w><left>', 'which_key_ignore' },
  ['<right>'] = { '<c-w><right>', 'which_key_ignore' },
  ['<m-l>'] = { '<c-w>l', 'which_key_ignore' },
  ['<m-h>'] = { '<c-w>h', 'which_key_ignore' },
  ['<m-k>'] = { '<c-w>k', 'which_key_ignore' },
  ['<m-j>'] = { '<c-w>j', 'which_key_ignore' },
  -- Telescope
  ['<c-p>'] = { telescope.find_files, 'Find file' }, -- TODO: frecency file finder
  ['<c-l>'] = { telescope.current_buffer_fuzzy_find, 'Live search in current file' },
  ['<c-h>'] = { telescope.oldfiles, 'Open recent file' },
  ['<leader>gg'] = { telescope.grep_string, 'Grep for word under the cursor' },
  ['<leader>lg'] = { telescope.live_grep, 'Live grep for typed string' },
  ['<leader>bu'] = { telescope.buffers, 'List open buffers'},
  ['gco'] = { telescope.git_branches, 'List git branches'},
  ['gr'] = { telescope.lsp_references, 'List references'},
  ['gd'] = { telescope.lsp_definitions, 'Go to definiton or list them'},
  ['c-RightMouse'] = { '<LeftMouse><cmd>Telescope lsp_definitions<cr>', 'which_key_ignore'},
  -- Git related
  ['<leader>gu'] = { vgit.hunk_up, 'Go to hunk above' },
  ['<leader>gd'] = { vgit.hunk_down, 'Go to hunk below' },
  ['<leader>gr'] = { vgit.buffer_hunk_reset, 'Reset hunk to HEAD' },
  ['<leader>gv'] = { vgit.buffer_hunk_preview, 'View hunk diff' },
  -- Debug
  [',c'] = { dap.continue, 'Continue' },
  [',n'] = { dap.step_over, 'Next (step over)' },
  [',i'] = { dap.step_into, 'Step into' },
  [',f'] = { dap.step_out, 'Finish (step out)' },
  [',b'] = { dap.toggle_breakpoint, 'Breakpoint toggle' },
  [',B'] = { function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, 'Breakpoint conditional' },
  [',r'] = { dap.run_to_cursor, 'Run to cursor' },
  [',e'] = { require('dapui').eval, 'Eval word under cursor' },
  -- CMake
  ['<leader>m'] = { cmake_build, 'Build target' },
  ['<leader>st'] = { cmake.select_target, 'Select target' },
  ['<leader>d'] = { cmake.debug, 'Debug' },
  -- TODO: build_and_debug
  -- Quickfix
  ['<leader>cl'] = { '<cmd>cclose<cr>', 'Close quickfix' },
  ['<leader>o'] = { '<cmd>copen<cr><cmd>cbottom<cr>', 'Open quickfix' },
  ['<leader>n'] = { '<cmd>cnext<cr>', 'Next in quickfix' },
  ['<leader>p'] = { '<cmd>cprev<cr>', 'Previous in quickfix' },

  ['<leader>u'] = { require('symbols-outline').toggle_outline, 'SymbolsOutline' },
  ['<leader>e'] = { require('nvim-tree').toggle, 'File explorer' },

  ['<f2>'] = { '<cmd>nohlsearch<cr>', 'Turn off last search highlight' },
  -- reserve gd to lsp-related things
  ['Gd'] = { 'gd', 'Goto local declaration' },
  -- goto bottom without irritating delay
  ['GG'] = { 'G', 'Goto the last line of file'},
})

wk.register({
  ['<leader>rg'] = { ':silent grep<space>', 'Find with rg (and put in quickfix)' },
  -- Save shift on command typing
  -- [';'] = { ':', 'which_key_ignore' },
}, { silent = false })
