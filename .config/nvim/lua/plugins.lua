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
  use { 'Pocco81/auto-save.nvim',
    config = function()
      require('auto-save').setup{
        execution_message = {
          message = function() return "" end,
          dim = 0
        }
      }
    end
  }

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
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
        }
      }
    end
  }

  use 'michaeljsmith/vim-indent-object'
  use { 'chaoren/vim-wordmotion', keys = { 'w', 'e', 'b', 'd', 'c', 'y', 'v' } }
  use 'wellle/targets.vim'
  use 'David-Kunz/treesitter-unit'

  use { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup() end }

  use {
    'ntpeters/vim-better-whitespace',
    setup = function()
      vim.g.better_whitespace_enabled = 1
      vim.g.strip_only_modified_lines = 1
      vim.g.show_spaces_that_precede_tabs = 1
      vim.g.better_whitespace_filetypes_blacklist = {'toggleterm'}
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
      local vgit = require('vgit')
      local nmap = require('utils').nmap
      vgit.setup{
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
      nmap('<leader>gu', vgit.hunk_up, 'Go to hunk above')
      nmap('<leader>gd', vgit.hunk_down, 'Go to hunk below')
      nmap('<leader>gr', vgit.buffer_hunk_reset, 'Reset hunk to HEAD')
      nmap('<leader>gv', vgit.buffer_hunk_preview, 'View hunk diff')
    end
  }
  use { 'sindrets/diffview.nvim', config = function() require('diffview').setup() end }

  use {
    'akinsho/nvim-toggleterm.lua',
    config = function()
      local nmap = require('utils').nmap
      local tmap = require('utils').tmap
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
      nmap('<leader>j', function() vim.cmd.ToggleTerm('direction=horizontal') end, 'Terminal')
      nmap('<leader>vj', function() vim.cmd.ToggleTerm('direction=vertical') end, 'Vertical terminal')
      nmap('<leader>fj', function() vim.cmd.ToggleTerm('direction=float') end, 'Floating terminal')
      tmap('<leader>j', vim.cmd.ToggleTerm, 'Close terminal')
    end
  }
  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      local nmap = require('utils').nmap
      local ntree = require('nvim-tree')
      ntree.setup {
        renderer = {
          indent_markers = {
            enable = true
          }
        }
      }
      nmap('<leader>e', ntree.toggle, 'File explorer')
    end
  }
  use 'natecraddock/telescope-zf-native.nvim'
  use { 'nvim-telescope/telescope.nvim',
    config = function()
      require('config.telescope')
    end
  }
  use { 'simrat39/symbols-outline.nvim',
    config = function()
      local nmap = require('utils').nmap
      local symbols = require('symbols-outline')
      symbols.setup()
      nmap('<leader>u', symbols.toggle_outline, 'SymbolsOutline')
    end
  }

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

  use { 'mrjones2014/legendary.nvim', config = function() require('legendary').setup() end }
  use { 'folke/which-key.nvim', config = function() require('which-key').setup() end }

  use {
    'folke/tokyonight.nvim',
    config = function()
      require('tokyonight').setup {
        styles = {
          comments = 'NONE',
          keywords = 'NONE',
        },
        sidebars = { 'qf', 'terminal', 'packer' },
        on_colors = function(colors) colors.border = colors.magenta end,
      }
      vim.cmd.colorscheme('tokyonight')
      vim.cmd.hi('NormalFloat guifg=#c0caf5 guibg=#394060')
    end
  }

  use {
    'mizlan/iswap.nvim',
    config = function()
      local nmap = require('utils').nmap
      require('iswap').setup{
        hl_snipe = 'HopNextKey',
        autoswap = true
      }
      nmap('<leader>sw', vim.cmd.ISwapWith, 'Swap nodes')
    end
  }

  use 'drybalka/tree-climber.nvim'
  use {'kevinhwang91/nvim-bqf', ft = 'qf'}

  use {
    'iamcco/markdown-preview.nvim',
    run = function() vim.fn["mkdp#util#install"]() end,
  }

  use {
    'stevearc/overseer.nvim',
    config = function() require('overseer').setup() end
  }

  use {
    'Pocco81/true-zen.nvim',
    config = function()
      require('true-zen').setup {}
    end,
  }

  use {
    'phaazon/mind.nvim',
    branch = 'v2.2',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      local mind = require('mind')
      local nmap = require('utils').nmap
      mind.setup()
      mind.is_opened = false
      nmap('<leader>w', function()
        if mind.is_opened then
          mind.close()
          mind.is_opened = false
        else
          vim.wo.relativenumber = false
          mind.open_main()
          mind.is_opened = true
        end
      end, 'Toggle personal Wiki')
    end
  }

  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        signs = false
      }
    end
  }

  use {
    'gaoDean/autolist.nvim',
    after = 'nvim-cmp',
    config = function() require('autolist').setup{} end
  }

end)
