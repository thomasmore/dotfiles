local utils = require 'utils'
local aucmd = utils.aucmd
local nmap = utils.nmap
local xmap = utils.xmap
local omap = utils.omap
local tmap = utils.tmap

-- Better arrows and window movement
nmap('<up>', '<c-w><up>')
nmap('<down>', '<c-w><down>')
nmap('<left>', '<c-w><left>')
nmap('<right>', '<c-w><right>')
nmap('<m-l>', '<c-w>l')
nmap('<m-h>', '<c-w>h')
nmap('<m-k>', '<c-w>k')
nmap('<m-j>', '<c-w>j')

-- Quickfix
nmap('<leader>o', function() vim.cmd.copen(); vim.cmd.cbottom() end, 'Open quickfix')
nmap('<leader>n', vim.cmd.cnext, 'Next in quickfix')
nmap('<leader>p', vim.cmd.cprev, 'Previous in quickfix')

-- Git related
nmap('dgl', '<cmd>diffget //2<cr>', 'Diff get left')
nmap('dgr', '<cmd>diffget //3<cr>', 'Diff get right')

-- Misc
-- reserve gd to lsp-related things
nmap('Gd', 'gd', 'Goto local declaration')
-- goto bottom without irritating delay
nmap('GG', 'G', 'Goto the last line of file')
-- open file under cursor in previous window (used to open files from terminal output)
nmap('gx', '<cmd>let _curf=expand("<cWORD>")<cr><c-w>p:execute("e "._curf)<cr>', 'Open file under cursor')
nmap('<f2>', function()
  vim.cmd.nohlsearch()
  vim.cmd.diffupdate()
  require('notify').dismiss{}
end, 'Turn off last search highlight and diffupdate')
nmap('<leader>rg', ':silent grep<space>', 'Find with rg (and put in quickfix)', { silent = false })
nmap('<leader>rf', utils.run_file, 'Run file in terminal')
tmap('<esc>', [[<c-\><c-n>]], 'Exit terminal mode')

nmap(']]', function()
  require('tree-climber').goto_next({ skip_comments = true })
  if not vim.g.neovide then
    require('neoscroll').zz(250)
  end
end, 'Go to next sibling in syntax tree')
nmap('[[', function()
  require('tree-climber').goto_prev({ skip_comments = true })
  if not vim.g.neovide then
    require('neoscroll').zz(250)
  end
end, 'Go to prev sibling in syntax tree')

xmap('iu', ':lua require("treesitter-unit").select()<cr>', 'inner treesitter unit')
xmap('au', ':lua require("treesitter-unit").select(true)<cr>', 'a treesitter unit')
omap('iu', ':<c-u>lua require("treesitter-unit").select()<cr>', 'inner treesitter unit')
omap('au', ':<c-u>lua require("treesitter-unit").select(true)<cr>', 'a treesitter unit')

nmap('<space>', 'ciw', 'Replace word')
nmap('gh', '^', 'Go to line begin')
nmap('gl', '$', 'Go to line end')

aucmd('BufRead', 'irtoc', 'irtoc_code.cpp', function()
  local ir_utils = require('ir_utils')
  nmap('<leader>i', ir_utils.show_input_context, 'Show context for ir input')
  nmap('<leader>I', ir_utils.jump_to_input_def, 'Go to ir input definition')
end)
