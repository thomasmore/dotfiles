return require('packer').startup(function()

  use 'wbthomason/packer.nvim'

  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'rcarriga/nvim-notify'
  use 'stevearc/dressing.nvim'
  use 'kyazdani42/nvim-web-devicons'

  use 'tpope/vim-repeat'
  use 'bogado/file-line'
  use 'farmergreg/vim-lastplace'
  use 'tpope/vim-sleuth'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'airblade/vim-rooter'
  use 'karb94/neoscroll.nvim'
  use 'b3nj5m1n/kommentary'
  use 'Pocco81/AutoSave.nvim'

  use 'mhinz/vim-startify'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use 'michaeljsmith/vim-indent-object'
  use { 'chaoren/vim-wordmotion', keys = { 'w', 'e', 'b', 'd', 'c', 'y', 'v' } }
  use 'wellle/targets.vim'
  use 'David-Kunz/treesitter-unit'

  use 'tpope/vim-surround'
  use 'ntpeters/vim-better-whitespace'
  use 'cohama/lexima.vim'

  use 'neovim/nvim-lspconfig'
  use {
    'hrsh7th/vim-vsnip',
    requires = { 'rafamadriz/friendly-snippets', after = 'vim-vsnip' },
    event = 'InsertEnter'
  }
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      { 'hrsh7th/cmp-vsnip', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' }
    },
    config = [[require('config.cmp')]],
    event = 'InsertEnter'
  }

  use 'hoob3rt/lualine.nvim'
  use 'alvarosevilla95/luatab.nvim'
  use 'SmiteshP/nvim-gps'

  use { 'tpope/vim-fugitive', cmd = { 'G', 'Git', 'Gedit', 'Gread', 'Gwrite', 'Gdiff', 'Gclog' } }
  use 'tanvirtin/vgit.nvim'
  use 'sindrets/diffview.nvim'

  use {
    'xolox/vim-notes', setup = function() vim.g.notes_directories = { '~/nvimnotes' } end,
    cmd = { 'Note', 'RecentNotes', 'e', 'tabe', 'sp', 'vs' },
    requires = { 'xolox/vim-misc' }
  }

  use 'akinsho/nvim-toggleterm.lua'
  use 'kyazdani42/nvim-tree.lua'
  use 'nvim-telescope/telescope.nvim'
  use 'simrat39/symbols-outline.nvim'
  use { 'github/copilot.vim', setup = function() vim.g.copilot_no_tab_map = true end, cmd = { 'Copilot' } }

  use 'ggandor/lightspeed.nvim'

  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'Shatur/neovim-cmake'

  use 'folke/which-key.nvim'
  use 'mrjones2014/legendary.nvim'

  use 'lewis6991/impatient.nvim'

  use 'folke/tokyonight.nvim'

end)
