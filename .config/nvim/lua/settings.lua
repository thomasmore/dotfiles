local utils = require('utils')
local aucmd = utils.aucmd
local nmap = utils.nmap

local set = vim.opt
local g = vim.g

-- signcolumn
set.number = true
set.relativenumber = true
set.signcolumn = 'yes:1'
-- set.signcolumn = 'no'
-- vim.o.stc = '%=%{v:relnum?v:relnum:v:lnum}│ '

-- but not in terminal
local settings_augroup = aucmd({ 'TermOpen', 'TermEnter' }, 'settings', { callback = function()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = 'no'
end })

-- open quickfix window below all vert-split windows
aucmd('FileType', settings_augroup, { pattern = 'qf', callback = function()
  vim.cmd.wincmd('J')
  vim.cmd.resize('15')
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

-- misc
set.wrap = false
set.completeopt = 'menuone,noselect'
set.pumheight = 20
set.pumblend = 10
set.scrolloff = 5
set.mouse = 'a'
set.inccommand = 'split'
set.hidden = true
g.mapleader = ';'
set.wildmode = 'longest,full'
set.virtualedit = 'block'
set.undofile = true
set.clipboard = 'unnamedplus'

aucmd({ 'VimEnter', 'WinEnter', 'BufWinEnter' }, settings_augroup, { callback = function()
  set.cursorline = true
end })
aucmd('WinLeave', settings_augroup, { callback = function() set.cursorline = false end })

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
g.loaded_matchit = 1
g.loaded_matchparen = 1

-- diff tool setting
set.diffopt = 'vertical'

aucmd('TextYankPost', settings_augroup, { callback = function()
  vim.highlight.on_yank()
end })

-- highlight long lines and add more patterns for errorformat
vim.cmd([[
 set efm^=\%\\s%#%\\d%#:%#\ %#from\ %f:%l:%m,IN\ %f:%l:%m,
]])
vim.cmd.match([[ErrorMsg /\%121v.\+/]])

aucmd('BufEnter', 'rooter_group', { callback = function()
  utils.rooter({ 'workspace', 'builds' }, { '.git' })
end })

-- auto-save
aucmd({'InsertLeave', 'TextChanged'}, settings_augroup, { callback = function()
  vim.cmd('silent! w')
end })

-- go to last loc when opening a buffer
aucmd('BufReadPost', settings_augroup, {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

aucmd('FileType', settings_augroup, {
  pattern = { 'gitcommit', 'markdown', 'norg'},
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

aucmd('FileType', 'q_group', {
  pattern = {
    'qf',
    'help',
    'fugitive'
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

if g.neovide then
  g.neovide_cursor_animation_length = 0
  set.guifont = 'JetBrainsMono NF:h13'
  nmap('<f11>', ':let g:neovide_fullscreen = !g:neovide_fullscreen<cr>')
end
