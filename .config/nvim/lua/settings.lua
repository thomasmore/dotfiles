local set = vim.opt

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

-- misc
set.wrap = false
set.cursorline = true
set.clipboard = 'unnamedplus'
set.completeopt = 'menuone,noselect'
set.scrolloff = 5
set.mouse = 'a'
set.inccommand = 'split'

-- rg integration
set.grepprg = 'rg --vimgrep --no-heading --smart-case'
set.grepformat = '%f:%l:%c:%m,%f:%l:%m'

-- folding
set.foldmethod = 'expr'
set.foldexpr = 'nvim_treesitter#foldexpr()'
set.foldlevelstart = 7

-- diff tool setting
set.diffopt = 'vertical'

vim.cmd('colorscheme tokyonight')
