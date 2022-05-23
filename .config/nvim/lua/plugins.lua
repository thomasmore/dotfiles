return require('packer').startup(function()

  use 'wbthomason/packer.nvim'

  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use { 'rcarriga/nvim-notify', config = function() vim.notify = require('notify') end }
  use 'stevearc/dressing.nvim'
  use 'kyazdani42/nvim-web-devicons'

  use 'tpope/vim-repeat'
  use 'bogado/file-line'
  use 'farmergreg/vim-lastplace'
  use 'tpope/vim-sleuth'
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        char = '▏',
        use_treesitter = true,
        show_first_indent_level = false,
        filetype_exclude = { 'json', 'startify' },
        buftype_exclude = { 'terminal' }
      }
    end
  }
  use {
    'airblade/vim-rooter',
    setup = function()
      vim.g.rooter_patterns = { '.git' }
      vim.g.rooter_silent_chdir = 1
    end
  }
  use { 'karb94/neoscroll.nvim', config = function() require('neoscroll').setup() end }
  use {
    'b3nj5m1n/kommentary',
    config = function()
      require('kommentary.config').configure_language("default", {
        prefer_single_line_comments = true,
        ignore_whitespace = false,
      })
    end
  }
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
      vim.api.nvim_create_autocmd('User StartifyBufferOpened', { command = 'Rooter' } )
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.opt.foldlevelstart = 7
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true
        }
      }
    end
  }

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

  use { 'tpope/vim-fugitive', cmd = { 'G', 'Git', 'Gedit', 'Gread', 'Gwrite', 'Gdiff', 'Gclog', 'Gdiffsplit' } }
  use {
    'tanvirtin/vgit.nvim',
    config = function()
      require('vgit').setup{
        settings = {
          live_gutter = {
            edge_navigation = false,
          },
          authorship_code_lens = {
            enabled = false,
          },
          scene = {
            diff_preference = 'split',
          },
        }
      }
    end
  }
  use { 'sindrets/diffview.nvim', config = function() require('diffview').setup() end }

  use {
    'xolox/vim-notes', setup = function() vim.g.notes_directories = { '~/nvimnotes' } end,
    cmd = { 'Note', 'RecentNotes', 'e', 'tabe', 'sp', 'vs' },
    requires = { 'xolox/vim-misc' }
  }

  use {
    'akinsho/nvim-toggleterm.lua',
    config = function()
      require('toggleterm').setup{
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        shade_terminals = true,
        insert_mappings = false
      }
    end
  }
  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup {
        renderer = {
          indent_markers = {
            enable = true
          }
        }
      }
    end
  }
  use { 'nvim-telescope/telescope.nvim',
    config = function()
      require('config.telescope')
    end
  }
  use {  -- TODO: I am using it only for db_client for custom sorter, rework?
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require('telescope').load_extension("frecency")
    end,
    requires = {"tami5/sqlite.lua"}
  }
  use 'simrat39/symbols-outline.nvim'
  use { 'github/copilot.vim', setup = function() vim.g.copilot_no_tab_map = true end, cmd = { 'Copilot' } }

  use {
    'ggandor/lightspeed.nvim',
    config = function()
      require('lightspeed').setup {
        ignore_case = true,
        jump_to_unique_chars = false,
        match_only_the_start_of_same_char_seqs = true,
        limit_ft_matches = 7,
        labels = nil,
        cycle_group_fwd_key = nil,
        cycle_group_bwd_key = nil,
      }
    end
  }

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

  use { 'mrjones2014/legendary.nvim' }
  use 'folke/which-key.nvim'

  use { 'lewis6991/impatient.nvim', disable = true }  -- TODO

  use {
    'folke/tokyonight.nvim',
    config = function()
      vim.g.tokyonight_italic_comments = false
      vim.g.tokyonight_italic_keywords = false
      vim.g.tokyonight_colors = { border = 'magenta' }
      vim.g.tokyonight_sidebars = { 'qf', 'terminal', 'packer' }
      vim.cmd([[
        colorscheme tokyonight
        hi NormalFloat guifg=#c0caf5 guibg=#394060
      ]])
    end
  }

  use {
    'mizlan/iswap.nvim',
    config = function()
      require('iswap').setup{
        hl_snipe = 'HopNextKey',
        autoswap = true
      }
    end
  }
end)
