local aucmd = require('utils').aucmd
local set = vim.opt
local g = vim.g

-- signcolumn
set.number = true
set.relativenumber = true
set.signcolumn = 'yes:1'
-- but not in terminal
local settings_augroup = aucmd({ 'TermOpen', 'TermEnter' }, 'settings', { callback = function()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = 'no'
end })

-- open quickfix window below all vert-split windows
aucmd('FileType', settings_augroup, { pattern = 'qf', callback = function()
  vim.cmd('wincmd J | resize 15')
end })

-- windows layout
set.winheight = 20
set.winminwidth = 15
set.winminheight = 5
set.cmdheight = 0

-- split to below and right
set.splitbelow = true
set.splitright = true

-- searching
set.hlsearch = true
set.ignorecase = true
set.smartcase = true
set.incsearch = true

-- clipboard
g.clipboard = {
  name = 'win32yank',
  copy = {
    ['+'] = 'win32yank.exe -i --crlf',
    ['*'] = 'win32yank.exe -i --crlf',
  },
  paste = {
    ['+'] = 'win32yank.exe -o --lf',
    ['*'] = 'win32yank.exe -o --lf',
  },
  cache_enabled = 0
}
set.clipboard = 'unnamedplus'

-- misc
set.wrap = false
set.cursorline = true
set.completeopt = 'menuone,noselect'
set.scrolloff = 5
set.mouse = 'a'
set.inccommand = 'split'
set.hidden = true
g.mapleader = ';'

-- rg integration
set.grepprg = 'rg --vimgrep --no-heading --smart-case'
set.grepformat = '%f:%l:%c:%m,%f:%l:%m'

-- disable most of builtin plugins
g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1

-- diff tool setting
set.diffopt = 'vertical'

aucmd('TextYankPost', settings_augroup, { callback = function()
  vim.highlight.on_yank()
end })

-- highlight long lines and add more patterns for errorformat
vim.cmd([[
 match ErrorMsg /\%121v.\+/
 set efm^=\%\\s%#%\\d%#:%#\ %#from\ %f:%l:%m,IN\ %f:%l:%m,
]])
