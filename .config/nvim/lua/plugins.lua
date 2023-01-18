require 'paq' {
  'thomasmore/paq-nvim';

  'nvim-lua/popup.nvim';
  'nvim-lua/plenary.nvim';
  {
    'rcarriga/nvim-notify',
    config = function() vim.notify = require('notify') end
  };
  'stevearc/dressing.nvim';
  'kyazdani42/nvim-web-devicons';

  'tpope/vim-repeat';
  'bogado/file-line';
  'farmergreg/vim-lastplace';
  'tpope/vim-sleuth';

  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        char = '▏',
        use_treesitter = true,
        show_first_indent_level = false,
        filetype_exclude = { 'json', 'startify' },
        buftype_exclude = { 'terminal' },
      }
    end
  };

  {
    'karb94/neoscroll.nvim',
    config = function() require('neoscroll').setup() end
  };

  {
    'b3nj5m1n/kommentary',
    config = function()
      require('kommentary.config').configure_language("default", {
        prefer_single_line_comments = true,
        ignore_whitespace = false,
      })
    end
  };

  {
    'Pocco81/auto-save.nvim',
    config = function()
      require('auto-save').setup{
        execution_message = {
          message = function() return "" end,
          dim = 0
        },
      }
    end
  };

  {
    'mhinz/vim-startify',
    config = function()
      vim.g.startify_session_persistence = 1
      vim.g.startify_fortune_use_unicode = 1
      vim.g.startify_lists = {
        { type = 'dir', header = { '   MRU ' .. vim.fn.getcwd() } },
        { type = 'sessions', header = { '   Sessions' } },
        { type = 'files', header = { '   MRU' } },
      }
    end
  };
  {
    'nvim-treesitter/nvim-treesitter',
    run = vim.cmd.TSUpdate,
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'lua', 'vim', 'c', 'cpp', 'java', 'ruby', 'python', 'cmake', 'bash',
            'markdown', 'markdown_inline', },
        highlight = {
          enable = true,
        },
      }
    end
  };

  'michaeljsmith/vim-indent-object';
  'chaoren/vim-wordmotion';
  'wellle/targets.vim';
  'David-Kunz/treesitter-unit';

  {
    'kylechui/nvim-surround',
    config = function() require('nvim-surround').setup() end
  };

  {
    'ntpeters/vim-better-whitespace',
    config = function()
      vim.g.better_whitespace_enabled = 1
      vim.g.strip_only_modified_lines = 1
      vim.g.show_spaces_that_precede_tabs = 1
      vim.g.better_whitespace_filetypes_blacklist = {'toggleterm'}
    end
  };

  {
    'neovim/nvim-lspconfig',
    config = function() require('config.lsp') end
  };


  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/cmp-buffer';
  'hrsh7th/cmp-nvim-lsp-signature-help';
  {
    'hrsh7th/nvim-cmp',
    config = function() require('config.cmp') end,
  };

  'andymass/vim-matchup';
  {
    'hrsh7th/nvim-insx',
    config = function()
      require('insx.preset.standard').setup()
    end,
  };

  {
    'alvarosevilla95/luatab.nvim',
    config = function() require('luatab').setup() end
  };

  'tpope/vim-fugitive';
  {
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
        },
      }
      nmap('<leader>gu', vgit.hunk_up, 'Go to hunk above')
      nmap('<leader>gd', vgit.hunk_down, 'Go to hunk below')
      nmap('<leader>gr', vgit.buffer_hunk_reset, 'Reset hunk to HEAD')
      nmap('<leader>gv', vgit.buffer_hunk_preview, 'View hunk diff')
    end,
    defer = true
  };
  {
    'sindrets/diffview.nvim',
    config = function()
      require('diffview').setup()
      local nmap = require('utils').nmap
      nmap('<leader>gh', function() vim.cmd.DiffviewFileHistory('%') end, 'View Git history for current file')
      nmap('<leader>go', function() vim.cmd.DiffviewOpen('HEAD^') end, 'View diff for last commit')
      nmap('<leader>gc', vim.cmd.DiffviewClose, 'Close Diffview tab')
    end,
    defer = true
  };
  'ray-x/guihua.lua';
  {
    'ray-x/forgit.nvim',
    config = function()
      require'forgit'.setup({
        vsplit = false,
        fugitive = true,
      })
    end,
    defer = true
  };

  {
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
      nmap('<leader>v', function() vim.cmd.ToggleTerm('direction=vertical') end, 'Vertical terminal')
      nmap('<leader>f', function() vim.cmd.ToggleTerm('direction=float') end, 'Floating terminal')
      tmap('<leader>j', vim.cmd.ToggleTerm, 'Close terminal')
    end
  };

  {
    'kyazdani42/nvim-tree.lua',
    config = function()
      local nmap = require('utils').nmap
      local ntree = require('nvim-tree')
      local ntree_api = require('nvim-tree.api').tree
      ntree.setup {
        renderer = {
          indent_markers = {
            enable = true
          },
        },
        update_focused_file = {
          enable = true,
          update_root = true
        }
      }
      nmap('<leader>e', ntree_api.toggle, 'File explorer')
      nmap('<leader>cd', function()
        local project_config = require('cmake.project_config').new()
        local build_dir = project_config:get_build_dir()
        ntree_api.open(build_dir.filename)
      end, 'Open Nvim Tree for build dir')
      nmap('<leader>wt', function()
        local notes_dir = require('neorg.modules.core.norg.dirman.module').public.get_workspaces()['notes']
        ntree_api.open(notes_dir)
      end, 'Toggle personal wiki')
    end,
    defer = true
  };

  'natecraddock/telescope-zf-native.nvim';
  {
    'nvim-telescope/telescope.nvim',
    config = function()
      require('config.telescope')
    end,
  };
  {
    'simrat39/symbols-outline.nvim',
    config = function()
      local nmap = require('utils').nmap
      local symbols = require('symbols-outline')
      symbols.setup()
      nmap('<leader>u', symbols.toggle_outline, 'SymbolsOutline')
    end
  };

  {
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
  };

  {
    'mfussenegger/nvim-dap',
    config = function() require('config.dap') end
  };
  {
    'rcarriga/nvim-dap-ui',
    config = function() require('config.dapui') end
  };
  {
    'thomasmore/neovim-cmake',
    config = function() require('config.cmake') end
  };

  'SmiteshP/nvim-gps';

  {
    'hoob3rt/lualine.nvim',
    config = function() require('config.statusline') end
  };

  {
    'folke/which-key.nvim',
    config = function() require('config.whichkey') end
  };

  {
    'catppuccin/nvim',
    config = function()
      require('catppuccin').setup {
        flavour = 'frappe',
        no_italic = true,
        integrations = {
          notify = true
        }
      }
      vim.cmd.colorscheme('catppuccin')
    end
  };

  {
    'mizlan/iswap.nvim',
    config = function()
      local nmap = require('utils').nmap
      require('iswap').setup{
        hl_snipe = 'HopNextKey',
        autoswap = true
      }
      nmap('<leader>sw', vim.cmd.ISwapWith, 'Swap nodes')
    end
  };

  'drybalka/tree-climber.nvim';
  'kevinhwang91/nvim-bqf';

  {
    'iamcco/markdown-preview.nvim',
    run = function() vim.fn["mkdp#util#install"]() end,
  };

  {
    'stevearc/overseer.nvim',
    config = function()
      local overseer = require('overseer')
      local nmap = require('utils').nmap
      overseer.setup()
      nmap('<leader>gs', function() overseer.load_task_bundle('git_sync') end, 'Git Sync')
    end
  };

  {
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup {
        signs = false
      };
    end
  };

  {
    'b0o/incline.nvim',
    config = function()
      require('incline').setup {
        hide = {
          focused_win = true,
        },
        window = {
          margin = {
            vertical = 0,
          },
          winhighlight = {
            inactive = {
              Normal = 'WildMenu',
            },
          },
        },
      }
    end
  };

  {
    'smjonas/live-command.nvim',
    config = function()
      require('live-command').setup {
        commands = {
          Norm = { cmd = 'norm' },
        },
      }
    end,
  };

  'lewis6991/impatient.nvim';

  {
    'RRethy/vim-illuminate',
    config = function()
      require('illuminate').configure {
        modes_denylist = { 'i' },
        filetypes_denylist = { 'NvimTree', 'qf' },
        delay = 50,
        large_file_cutoff = 10000,
      };
      vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'Visual' })
      vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'Visual' })
      vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'Visual' })
    end
  };

  {
    'gbprod/substitute.nvim',
    config = function()
      local sub = require('substitute')
      local nmap = require('utils').nmap
      local xmap = require('utils').xmap
      sub.setup{}
      nmap('<leader>s', sub.operator, 'Substitute motion with default register')
      nmap('<leader>ss', sub.line, 'Substitute line with default register')
      nmap('<leader>S', sub.eol, 'Substitute til EOL with default register')
      xmap('<laeder>s', sub.visual, 'Substitute visual selection with default register')
    end
  };

  {
    'mrjones2014/legendary.nvim',
    config = function()
      require('legendary').setup{}
    end,
    defer = true,
  };

  {
    'dnlhc/glance.nvim',
    config = function()
      local glance = require('glance')
      local actions = glance.actions
      local nmap = require('utils').nmap

      glance.setup {
        border = {
          enable = true,
        },
        hooks = {
          before_open = function(results, open, jump, method)
            if #results == 1 then
              jump(results[1])
            else
              open(results)
            end
          end,
        },
        mappings = {
          list = {
            ['<C-v>'] = actions.jump_vsplit,
            ['<C-x>'] = actions.jump_split,
            ['<C-t>'] = actions.jump_tab,
          }
        }
      }
      nmap('gr', function() vim.cmd.Glance('references') end, 'List references')
      nmap('gd', function() vim.cmd.Glance('definitions') end, 'List definitions')
      nmap('gi', function() vim.cmd.Glance('implementations') end, 'List implementations')
    end,
  };

  'MunifTanjim/nui.nvim';
  {
    'folke/noice.nvim',
    config = function()
      require('noice').setup{
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        views = {
          cmdline_popup = {
            position = {
              row = "85%",
            }
          }
        },
        routes = {
          {
            filter = { event = 'msg_show', kind = '', find = '^[%?/]' },
            opts = { skip = true },
          },
          {
            filter = { event = 'msg_show', kind = '', find = 'written' },
            opts = { skip = true },
          },
        },
      }
    end
  };

  {
    'folke/zen-mode.nvim',
    config = function()
      require('zen-mode').setup {}
    end,
    defer = true
  };

  {
    'nvim-neorg/neorg',
    run = function() vim.cmd.Neorg('sync-parsers') end,
    config = function()
      require('neorg').setup {
        load = {
          ['core.defaults'] = {},
          ['core.norg.concealer'] = {
            config = {
              folds = false,
            }
          },
          ['core.norg.completion'] = {
            config = {
              engine = 'nvim-cmp'
            }
          },
          ['core.norg.dirman'] = {
            config = {
              workspaces = {
                notes = '~/notes'
              },
              default_workspace = 'notes',
            }
          },
          ['core.norg.journal'] = {
            config = {
              workspace = 'notes',
              journal_folder = 'journal'
            }
          },
          ['core.presenter'] = {
            config = {
              zen_mode = 'zen-mode'
            }
          },
        }
      }
    end,
    defer = true
  };

  {
    'ckolkey/ts-node-action',
    config = function()
      require('utils').nmap('<leader>t', require('ts-node-action').node_action, 'Trigger node action')
    end
  };

  {
    'eandrju/cellular-automaton.nvim',
    config = function()
      local nmap = require('utils').nmap
      nmap('<f3>', function() vim.cmd.CellularAutomaton('make_it_rain') end, 'Make it rain')
    end,
  };

  {
    'tamton-aquib/duck.nvim',
    config = function()
      local nmap = require('utils').nmap
      nmap('<f4>', require('duck').hatch, 'Hatch Duck')
      nmap('<f5>', require('duck').cook, 'Cook Duck')
    end
  };

  {
    'shortcuts/no-neck-pain.nvim',
    config = function()
      require('no-neck-pain').setup {
        width = 120
      }
    end
  };
}
