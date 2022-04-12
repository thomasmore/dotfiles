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
  use {
    'airblade/vim-rooter',
    setup = function()
      vim.g.rooter_patterns = { '.git' }
      vim.g.rooter_silent_chdir = 1
    end
  }
  use 'karb94/neoscroll.nvim'
  use 'b3nj5m1n/kommentary'
  use { 'Pocco81/AutoSave.nvim', config = function() require('autosave').setup({ execution_message = "" }) end }

  use {
    'mhinz/vim-startify',
    setup = function()
      vim.g.startify_session_persistence = 1
      vim.g.startify_fortune_use_unicode = 1
      vim.g.startify_lists = {
        { type = 'dir', header = { '   MRU ' .. vim.fn.getcwd() } },
        { type = 'sessions', header = { '   Sessions' } },
        { type = 'files', header = { '   MRU' } }
      }
    end
  }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use 'michaeljsmith/vim-indent-object'
  use { 'chaoren/vim-wordmotion', keys = { 'w', 'e', 'b', 'd', 'c', 'y', 'v' } }
  use 'wellle/targets.vim'
  use 'David-Kunz/treesitter-unit'

  use 'tpope/vim-surround'
  use {
    'ntpeters/vim-better-whitespace',
    setup = function()
      vim.g.better_whitespace_enabled = 1
      vim.g.strip_whitespace_on_save = 1
      vim.g.strip_only_modified_lines = 1
      vim.g.show_spaces_that_precede_tabs = 1
    end
  }
  use {
    'cohama/lexima.vim',
    setup = function()
      require('utils').aucmd('FileType', 'dap', { pattern = 'dap-repl', callback = function()
        vim.b.lexima_disabled = 1
      end })
    end
  }

  use { 'neovim/nvim-lspconfig', config = function() require('config.lsp') end }
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
    config = function() require('config.cmp') end,
    event = 'InsertEnter'
  }

  use {
    'hoob3rt/lualine.nvim',
    requires = { 'SmiteshP/nvim-gps' },
    after = { 'neovim-cmake' },
    config = function() require('config.statusline') end
  }
  use { 'alvarosevilla95/luatab.nvim', config = function() require('luatab').setup() end }

  use { 'tpope/vim-fugitive', cmd = { 'G', 'Git', 'Gedit', 'Gread', 'Gwrite', 'Gdiff', 'Gclog' } }
  use { 'tanvirtin/vgit.nvim', config = function() require('vgit').setup() end }
  use { 'sindrets/diffview.nvim', config = function() require('diffview').setup() end }

  use {
    'xolox/vim-notes', setup = function() vim.g.notes_directories = { '~/nvimnotes' } end,
    cmd = { 'Note', 'RecentNotes', 'e', 'tabe', 'sp', 'vs' },
    requires = { 'xolox/vim-misc' }
  }

  use { 'akinsho/nvim-toggleterm.lua', config = function() require('config.term') end }
  use 'kyazdani42/nvim-tree.lua'
  use 'nvim-telescope/telescope.nvim'
  use 'simrat39/symbols-outline.nvim'
  use { 'github/copilot.vim', setup = function() vim.g.copilot_no_tab_map = true end, cmd = { 'Copilot' } }

  use 'ggandor/lightspeed.nvim'

  use { 'mfussenegger/nvim-dap', config = function() require('config.dap') end }
  use {
    'rcarriga/nvim-dap-ui',
    after = { 'nvim-dap' },
    config = function() require('config.dapui') end
  }
  use {
    'Shatur/neovim-cmake',
    after = { 'nvim-dap' },
    config = function() require('config.cmake') end
  }

  use { 'mrjones2014/legendary.nvim', commit = 'e5a927706f1e525b7654d748fc16fa426e89a92f' }
  use 'folke/which-key.nvim'

  use { 'lewis6991/impatient.nvim', disable = true }  -- TODO

  use 'folke/tokyonight.nvim'

end)
