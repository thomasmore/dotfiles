local utils = require 'utils'
local map = utils.map
local nmap = utils.nmap
local xmap = utils.xmap
local omap = utils.omap
local imap = utils.imap
local t = utils.replace_termcodes

local telescope = require('telescope.builtin')
local vgit = require('vgit')
local dap = require('dap')

require('legendary').setup()  -- Register all mappings also in Legendary
local wk = require('which-key')
-- TODO: register neoscroll and lightspeed mappings
-- TODO: register fugitive mappings
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
  ['dgl'] = { '<cmd>diffget //2<cr>', 'Diff get left' },
  ['dgr'] = { '<cmd>diffget //3<cr>', 'Diff get right' },
  -- Debug
  [',c'] = { dap.continue, 'Continue' },
  [',n'] = { dap.step_over, 'Next (step over)' },
  [',i'] = { dap.step_into, 'Step into' },
  [',f'] = { dap.step_out, 'Finish (step out)' },
  [',b'] = { dap.toggle_breakpoint, 'Breakpoint toggle' },
  [',B'] = { function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, 'Breakpoint conditional' },
  [',r'] = { dap.run_to_cursor, 'Run to cursor' },
  -- [',e'] = { require('dapui').eval, 'Eval word under cursor' }, TODO
  -- CMake
  -- TODO remove <cmd>
  ['<leader>m'] = { '<cmd>lua cmake_build()<cr>', 'Build target' },
  ['<leader>st'] = { '<cmd>CMake select_target<cr>', 'Select target' },
  ['<leader>d'] = { '<cmd>CMake debug<cr>', 'Debug' },
  -- TODO: build_and_debug
  -- Quickfix
  ['<leader>cl'] = { '<cmd>cclose<cr>', 'Close quickfix' },
  ['<leader>o'] = { '<cmd>copen<cr><cmd>cbottom<cr>', 'Open quickfix' },
  ['<leader>n'] = { '<cmd>cnext<cr>', 'Next in quickfix' },
  ['<leader>p'] = { '<cmd>cprev<cr>', 'Previous in quickfix' },
  -- Terminal
  ['<leader>j'] = { '<cmd>ToggleTerm direction=horizontal<cr>', 'Terminal' },
  ['<leader>vj'] = { '<cmd>ToggleTerm direction=vertical<cr>', 'Vertical terminal' },
  ['<leader>fj'] = { '<cmd>ToggleTerm direction=float<cr>', 'Floating terminal' },

  ['<leader>u'] = { require('symbols-outline').toggle_outline, 'SymbolsOutline' },
  ['<leader>e'] = { require('nvim-tree').toggle, 'File explorer' },
  ['<leader>rg'] = { ':silent grep<space>', 'Find with rg (and put in quickfix)', silent = false },

  ['<f2>'] = { '<cmd>nohlsearch<cr><cmd>diffupdate<cr>', 'Turn off last search highlight and diffupdate' },
  -- reserve gd to lsp-related things
  ['Gd'] = { 'gd', 'Goto local declaration' },
  -- goto bottom without irritating delay
  ['GG'] = { 'G', 'Goto the last line of file'},
  -- open file under cursor in previous window (used to open files from terminal output)
  ['gx'] = { '<cmd>let _curf=expand("<cWORD>")<cr><c-w>p:execute("e "._curf)<cr>', 'Open file under cursor' },
  ['<leader>sw'] = {'<cmd>ISwapWith<cr>', 'Swap nodes'},
  [']]'] = { "<cmd>lua require('tree-climber').goto_next({skip_comments = true})<cr><cmd>lua require('neoscroll').zz(250)<cr>", 'Go to next sibling in syntax tree' },
  ['[['] = { "<cmd>lua require('tree-climber').goto_prev({skip_comments = true})<cr><cmd>lua require('neoscroll').zz(250)<cr>", 'Go to prev sibling in syntax tree' },
})

wk.register({
  -- [',e'] = { require('dapui').eval, 'Eval in debug' }, TODO
}, { mode = 'v' })

wk.register({
  ['<esc>'] = { t('<c-\\><c-n>'), 'Exit terminal' },
  ['<leader>j'] = { t('<c-\\><c-n>:ToggleTerm<cr>'), 'Close terminal' },
}, { mode = 't' })

xmap('iu', ':lua require("treesitter-unit").select()<cr>')
xmap('au', ':lua require("treesitter-unit").select(true)<cr>')
omap('iu', ':<c-u>lua require("treesitter-unit").select()<cr>')
omap('au', ':<c-u>lua require("treesitter-unit").select(true)<cr>')

nmap(';', '<leader>')
