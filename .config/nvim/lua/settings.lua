local utils = require('utils')
local aucmd = utils.aucmd
local nmap = utils.nmap

local set = vim.opt
local g = vim.g

-- signcolumn
set.number = true
set.relativenumber = true
set.signcolumn = 'yes:1'
set.numberwidth = 1
vim.o.stc = '%=%l%s'

-- open quickfix window below all vert-split windows
local settings_augroup = aucmd('FileType', 'settings', 'qf', function()
  vim.cmd.wincmd('J')
  vim.cmd.resize('15')
end)

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
set.scrolloff = 5
set.mouse = 'a'
set.inccommand = 'split'
set.hidden = true
g.mapleader = ';'
set.wildmode = 'longest,full'
set.virtualedit = 'block'
set.undofile = true
set.clipboard = 'unnamedplus'
set.foldtext = 'v:lua.require("utils").simple_fold()'
set.conceallevel = 3

aucmd({ 'VimEnter', 'WinEnter', 'BufWinEnter' }, settings_augroup, '*', function()
  set.cursorline = true
end)
aucmd('WinLeave', settings_augroup, '*', function() set.cursorline = false end)

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

aucmd('TextYankPost', settings_augroup, '*', function()
  vim.highlight.on_yank()
end)

-- highlight long lines and add more patterns for errorformat
vim.cmd([[
 set efm^=\%\\s%#%\\d%#:%#\ %#from\ %f:%l:%m,IN\ %f:%l:%m,
]])
vim.cmd.match([[ErrorMsg /\%121v.\+/]])

aucmd('BufEnter', 'rooter_group', '*', function()
  utils.rooter({ 'static_core', 'ets2panda' },{ 'workspace', 'builds' }, { '.git' })
end)

-- auto-save
aucmd({'InsertLeave', 'TextChanged'}, settings_augroup, '*', function()
  vim.cmd('silent! w')
end)

-- go to last loc when opening a buffer
aucmd('BufReadPost', settings_augroup, '*', function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
end)

aucmd('FileType', settings_augroup, { 'gitcommit', 'markdown', 'norg'}, function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
end)

aucmd('FileType', 'q_group', { 'qf', 'help', 'fugitive' }, function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
end)

vim.filetype.add({ extension = { ets = 'typescript' } })
vim.filetype.add({ extension = { sts = 'typescript' } })
vim.filetype.add({ extension = { irt = 'ruby' } })

if g.neovide then
  g.neovide_cursor_animation_length = 0
  set.guifont = 'VictorMono NF:h12'
  if g.terminal_color_0 == nil then
    g.terminal_color_0 = '#494D64'
    g.terminal_color_1 = '#ED8796'
    g.terminal_color_2 = '#A6DA95'
    g.terminal_color_3 = '#EED49F'
    g.terminal_color_4 = '#8AADF4'
    g.terminal_color_5 = '#F5BDE6'
    g.terminal_color_6 = '#8BD5CA'
    g.terminal_color_7 = '#B8C0E0'
    g.terminal_color_8 = '#5B6078'
    g.terminal_color_9 = '#ED8796'
    g.terminal_color_10 = '#A6DA95'
    g.terminal_color_11 = '#EED49F'
    g.terminal_color_12 = '#8AADF4'
    g.terminal_color_13 = '#F5BDE6'
    g.terminal_color_14 = '#8BD5CA'
    g.terminal_color_15 = '#A5ADCB'
  end
  nmap('<f11>', ':let g:neovide_fullscreen = !g:neovide_fullscreen<cr>')
end

