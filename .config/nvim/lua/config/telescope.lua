local telescope = require('telescope')
local builtins = require('telescope.builtin')
local config = require('telescope.config')

local nmap = require('utils').nmap

local vimgrep_arguments = { unpack(config.values.vimgrep_arguments) }
table.insert(vimgrep_arguments, '--no-ignore')

local picker_config = {}
for b, _ in pairs(builtins) do
  picker_config[b] = { fname_width = 60 }
end
local lga_actions = require('telescope-live-grep-args.actions')
telescope.setup{
  defaults = {
    mappings = {
      n = {
        ['l'] = require('telescope.actions').cycle_history_next,
        ['h'] = require('telescope.actions').cycle_history_prev,
      },
    },
    layout_config = {
      vertical = { width = 0.9 },
      horizontal = { width = 0.9, preview_width = 0.5 },
    },
    layout_strategy = 'vertical',
    path_display = { 'truncate' },
    file_ignore_patterns = { 'compile_commands.json', 'third_party' }
  },
  pickers = vim.tbl_extend('force', picker_config, {
    find_files = {
      layout_strategy = 'horizontal',
      no_ignore = true,
      no_ignore_parent = true
    },
    oldfiles = {
      layout_strategy = 'horizontal',
    },
    buffers = {
      layout_strategy = 'horizontal',
    },
    live_grep = {
      vimgrep_arguments = vimgrep_arguments,
    },
    grep_string = {
      vimgrep_arguments = vimgrep_arguments,
    },
    lsp_references = {
      include_declaration = false,
      fname_width = 60,
    },
  }),
  extensions = {
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ['<c-k>'] = lga_actions.quote_prompt(),
          ['<c-i>'] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
        },
      },
      vimgrep_arguments = vimgrep_arguments,
    }
  }
}
telescope.load_extension('zf-native')
telescope.load_extension('live_grep_args')

nmap('<c-p>', builtins.find_files, 'Find file')
nmap('<c-l>', builtins.current_buffer_fuzzy_find, 'Live search in current file')
nmap('<c-h>', builtins.oldfiles, 'Open recent file')
nmap('<leader>gg', builtins.grep_string, 'Grep for word under the cursor')
nmap('grr', builtins.lsp_references, 'List references')
nmap('gd', builtins.lsp_definitions, 'List definitions')
nmap('gri', builtins.lsp_implementations, 'List implementations')
nmap('<leader>lc', builtins.lsp_incoming_calls, 'List LSP incoming calls')
nmap('<leader>gp', builtins.lsp_dynamic_workspace_symbols, 'Live grep for workspace symbol')
nmap('<leader>gl', telescope.extensions.live_grep_args.live_grep_args, 'Live grep for typed string')
nmap('<leader>b', builtins.buffers, 'List open buffers')
nmap('gco', builtins.git_branches, 'List git branches')
nmap('<f1>', builtins.help_tags, 'Search in help')
nmap('<leader>wl', function() builtins.live_grep({ search_dirs = { '~/notes' } }) end, 'Live grep in wiki')
nmap('<leader>wf', function() builtins.find_files({ cwd = '~/notes' }) end, 'Find files in wiki')
