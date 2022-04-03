local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'hoob3rt/lualine.nvim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'bogado/file-line'
Plug 'farmergreg/vim-lastplace'
Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'
Plug 'airblade/vim-rooter'
Plug 'mhinz/vim-startify'
Plug 'b3nj5m1n/kommentary'
Plug 'karb94/neoscroll.nvim'
Plug 'akinsho/nvim-toggleterm.lua'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'

Plug 'rafamadriz/friendly-snippets'

Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug 'David-Kunz/treesitter-unit'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ggandor/lightspeed.nvim'
Plug 'sindrets/diffview.nvim'
Plug 'alvarosevilla95/luatab.nvim'

Plug 'michaeljsmith/vim-indent-object'
Plug 'chaoren/vim-wordmotion'
Plug 'wellle/targets.vim'

Plug 'Pocco81/AutoSave.nvim'

Plug 'tanvirtin/vgit.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'zeertzjq/nvim-paste-fix'
Plug 'Shatur/neovim-cmake'
Plug 'stevearc/dressing.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'cohama/lexima.vim'
Plug 'simrat39/symbols-outline.nvim'
Plug 'SmiteshP/nvim-gps'
Plug 'folke/which-key.nvim'
Plug 'mrjones2014/legendary.nvim'

Plug 'folke/tokyonight.nvim'

vim.call('plug#end')
