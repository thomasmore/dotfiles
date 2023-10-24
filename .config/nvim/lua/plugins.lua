local nmap = require('utils').nmap
local vmap = require('utils').vmap
local tmap = require('utils').tmap
local xmap = require('utils').xmap

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
  'tpope/vim-sleuth';

  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      local hooks = require('ibl.hooks')
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require('ibl').setup {
        indent = { char = '▏', },
        scope = { enabled = false },
        exclude = {
          filetypes = { 'josn', 'startify' },
          buftypes = { 'terminal' },
        }
      }
    end
  };

  {
    'karb94/neoscroll.nvim',
    config = function()
      if not vim.g.neovide then
        require('neoscroll').setup()
      end
    end
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
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<cr>',
            node_incremental = '<cr>',
            node_decremental = '<bs>',
          }
        }
      }
    end
  };
  'nvim-treesitter/nvim-treesitter-context';

  {
    'chrisgrieser/nvim-spider',
    config = function()
      local spider = require('spider')
      vim.keymap.set({'n', 'o', 'x'}, 'w', function() spider.motion('w', {}) end, { desc = 'Move to next subword begin' })
      vim.keymap.set({'n', 'o', 'x'}, 'e', function() spider.motion('e', {}) end, { desc = 'Move to next subword end' })
      vim.keymap.set({'n', 'o', 'x'}, 'b', function() spider.motion('b', {}) end, { desc = 'Move to previous subword begin' })
      vim.keymap.set({'n', 'o', 'x'}, 'ge', function() spider.motion('ge', {}) end, { desc = 'Move to previous subword end' })
    end
  };
  {
    'chrisgrieser/nvim-various-textobjs',
    config = function()
      require('various-textobjs').setup {
        useDefaultKeymaps = true
      }
    end
  };
  {
    'echasnovski/mini.ai',
    config = function() require('mini.ai').setup() end
  };
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
    'folke/neodev.nvim',
    config = function()
      require('neodev').setup {}
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

  {
    'andymass/vim-matchup',
    defer = true
  };

  {
    'hrsh7th/nvim-insx',
    config = function()
      require('insx.preset.standard').setup()
    end,
  };

  {
    'alvarosevilla95/luatab.nvim',
    config = function()
      require('luatab').setup {
        windowCount = function() return '' end,
      }
    end
  };

  'tpope/vim-fugitive';
  {
    'tanvirtin/vgit.nvim',
    config = function()
      local vgit = require('vgit')
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
      nmap('<leader>gh', function() vim.cmd.DiffviewFileHistory('%') end, 'View Git history for current file')
      vmap('<leader>gh', ':DiffviewFileHistory<cr>', 'View Git history for selected range')
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
      nmap('<leader>f', function() vim.cmd.ToggleTerm('direction=float'); vim.opt.winblend=15 end, 'Floating terminal')
      tmap('<leader>j', vim.cmd.ToggleTerm, 'Close terminal')
    end
  };

  {
    'kyazdani42/nvim-tree.lua',
    config = function()
      local ntree = require('nvim-tree')
      local ntree_api = require('nvim-tree.api').tree
      ntree.setup {
        view = { width = {} },  -- dynamic width
        renderer = {
          indent_markers = {
            enable = true
          },
        },
      }
      nmap('<leader>e', function()
        ntree_api.toggle({ find_file = true, update_root = true, focus = true })
      end, 'File explorer')
      nmap('<leader>cd', function()
        local project_config = require('cmake.project_config').new()
        local build_dir = project_config:get_build_dir()
        ntree_api.open({ path = build_dir.filename, focus = true })
      end, 'Open Nvim Tree for build dir')
      nmap('<leader>wt', function()
        local notes_dir = require('neorg.modules.core.dirman.module').public.get_workspaces()['notes']
        ntree_api.open({ path = notes_dir, focus = true })
      end, 'Toggle personal wiki')
    end,
    defer = true
  };

  'natecraddock/telescope-zf-native.nvim';
  'nvim-telescope/telescope-live-grep-args.nvim';
  {
    'nvim-telescope/telescope.nvim',
    config = function()
      require('config.telescope')
    end,
    defer = true
  };
  {
    'simrat39/symbols-outline.nvim',
    config = function()
      local symbols = require('symbols-outline')
      symbols.setup()
      nmap('<leader>u', symbols.toggle_outline, 'SymbolsOutline')
    end
  };

  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end
  };

  {
    'mfussenegger/nvim-dap',
    config = function() require('config.dap') end
  };
  {
    'rcarriga/nvim-dap-ui',
    config = function() require('config.dapui') end,
    defer = true
  };
  {
    'thomasmore/neovim-cmake',
    config = function() require('config.cmake') end
  };

  'SmiteshP/nvim-navic';

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
      require('iswap').setup{
        hl_snipe = 'HopNextKey',
        autoswap = true
      }
      nmap('<leader>s', vim.cmd.ISwapWith, 'Swap nodes')
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
      sub.setup{}
      nmap('gr', sub.operator, 'Replace motion with default register')
      nmap('grr', sub.line, 'Replace line with default register')
      nmap('gR', sub.eol, 'Replace til EOL with default register')
      xmap('gr', sub.visual, 'Replace visual selection with default register')
    end
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
    'nvim-neorg/neorg',
    run = function() vim.cmd.Neorg('sync-parsers') end,
    config = function()
      require('neorg').setup {
        load = {
          ['core.defaults'] = {},
          ['core.concealer'] = {
            config = {
              folds = false,
            }
          },
          ['core.completion'] = {
            config = {
              engine = 'nvim-cmp'
            }
          },
          ['core.dirman'] = {
            config = {
              workspaces = {
                notes = '~/notes'
              },
              default_workspace = 'notes',
            }
          },
          ['core.journal'] = {
            config = {
              workspace = 'notes',
              journal_folder = 'journal'
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
      nmap('<leader>t', require('ts-node-action').node_action, 'Trigger node action')
    end
  };

  {
    'tamton-aquib/duck.nvim',
    config = function()
      nmap('<f3>', require('duck').hatch, 'Hatch Duck')
      nmap('<f4>', require('duck').cook, 'Cook Duck')
    end
  };

  {
    'shortcuts/no-neck-pain.nvim',
    config = function()
      require('no-neck-pain').setup {
        mappings = {
          enabled = false,
        },
        width = 120
      }
    end
  };

  {
    'chomosuke/term-edit.nvim',
    config = function()
      require('term-edit').setup {
        prompt_end = '[🔥💩] '
      }
    end
  };

  {
    'willothy/flatten.nvim',
    config = function() require('flatten').setup{} end
  };

  {
    'willothy/wezterm.nvim',
    config = function()
      require('wezterm').setup {
        create_commands = false
      }
    end
  };

  {
    'm4xshen/hardtime.nvim',
    config = function()
      require('hardtime').setup {
        disable_mouse = false,
        notification = false,
        disabled_keys = {
          ['<Up>'] = {},
          ['<Down>'] = {},
          ['<Left>'] = {},
          ['<Right>'] = {},
        },
        restricted_keys = {
          ['h'] = { 'n', 'x' },
          ['j'] = { 'n', 'x' },
          ['k'] = { 'n', 'x' },
          ['l'] = { 'n', 'x' },
          ['-'] = { 'n', 'x' },
          ['+'] = { 'n', 'x' },
          ['gj'] = { 'n', 'x' },
          ['gk'] = { 'n', 'x' },
          ['<CR>'] = { 'n', 'x' },
          ['<C-M>'] = { 'n', 'x' },
          ['<C-N>'] = { 'n', 'x' },
        },
      }
    end
  };
}
