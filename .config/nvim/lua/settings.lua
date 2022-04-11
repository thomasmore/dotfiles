local set = vim.opt
local g = vim.g

-- signcolumn
set.number = true
set.relativenumber = true
set.signcolumn = 'yes:1'
-- but not in terminal
local settings_augroup = vim.api.nvim_create_augroup('settings', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', { callback = function()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = 'no'
end, group = settings_augroup })

-- open quickfix window below all vert-split windows
vim.api.nvim_create_autocmd('FileType', { pattern = 'qf', callback = function()
  vim.cmd('wincmd J')
end, group = settings_augroup })

-- windows layout
set.winheight = 20
set.winminwidth = 15
set.winminheight = 5

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

-- use filetype.lua
g.do_filetype_lua = 1
g.did_load_filetypes = 0

-- rg integration
set.grepprg = 'rg --vimgrep --no-heading --smart-case'
set.grepformat = '%f:%l:%c:%m,%f:%l:%m'

-- folding
set.foldmethod = 'expr'
set.foldexpr = 'nvim_treesitter#foldexpr()'
set.foldlevelstart = 7

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

g.tokyonight_italic_comments = false
g.tokyonight_italic_keywords = false

vim.api.nvim_create_autocmd('TextYankPost', { callback = vim.highlight.on_yank, group = settings_augroup })
vim.cmd([[
  colorscheme tokyonight
  hi NormalFloat guifg=#c0caf5 guibg=#394060
" highlight long lines
  match ErrorMsg /\%121v.\+/
]])
