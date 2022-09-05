local utils = require 'utils'
local nmap = utils.nmap
local xmap = utils.xmap
local omap = utils.omap
local imap = utils.imap
local tmap = utils.tmap

-- TODO: how to make register neoscroll and lightspeed mappings look good in WhichKey?

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
nmap('<leader>cl', vim.cmd.cclose, 'Close quickfix')
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
nmap('<f2>', function() vim.cmd.nohlsearch(); vim.cmd.diffupdate() end, 'Turn off last search highlight and diffupdate')
nmap('<leader>rg', ':silent grep<space>', 'Find with rg (and put in quickfix)', { silent = false })
tmap('<esc>', [[<c-\><c-n>]], 'Exit terminal mode')

nmap(']]', function()
  require('tree-climber').goto_next({ skip_comments = true })
  require('neoscroll').zz(250)
end, 'Go to next sibling in syntax tree')
nmap('[[', function()
  require('tree-climber').goto_prev({ skip_comments = true })
  require('neoscroll').zz(250)
end, 'Go to prev sibling in syntax tree')

xmap('iu', ':lua require("treesitter-unit").select()<cr>', 'inner treesitter unit')
xmap('au', ':lua require("treesitter-unit").select(true)<cr>', 'a treesitter unit')
omap('iu', ':<c-u>lua require("treesitter-unit").select()<cr>', 'inner treesitter unit')
omap('au', ':<c-u>lua require("treesitter-unit").select(true)<cr>', 'a treesitter unit')

local ir_utils = require('ir_utils')
nmap('<leader>i', ir_utils.show_input_context, 'show context for ir input')
nmap('<leader>gi', ir_utils.jump_to_input_def, 'go to ir input definition')
