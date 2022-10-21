local telescope = require('telescope')
local builtins = require('telescope.builtin')
local themes = require('telescope.themes')
local config = require('telescope.config')

local nmap = require('utils').nmap


local vimgrep_arguments = { unpack(config.values.vimgrep_arguments) }
table.insert(vimgrep_arguments, '--no-ignore')

telescope.setup{
  defaults = {
    layout_config = {
      vertical = { width = 0.9 },
      horizontal = { width = 0.9, preview_width = 0.5 },
    },
    layout_strategy = 'vertical',
  },
  pickers = {
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
    }
  }
}
telescope.load_extension('zf-native')

local function spell_suggest()
  builtins.spell_suggest(
    themes.get_cursor {
      prompt_title = "",
      layout_config = {
        height = 0.6,
        width = 0.25
      }
    }
  )
end

nmap('<c-p>', builtins.find_files, 'Find file')
nmap('<c-l>', builtins.current_buffer_fuzzy_find, 'Live search in current file')
nmap('<c-h>', builtins.oldfiles, 'Open recent file')
nmap('<leader>gg', builtins.grep_string, 'Grep for word under the cursor')
nmap('<leader>gp', builtins.lsp_dynamic_workspace_symbols, 'Live Grep for workspace symbol')
nmap('<leader>gl', builtins.live_grep, 'Live grep for typed string')
nmap('<leader>b', builtins.buffers, 'List open buffers')
nmap('gco', builtins.git_branches, 'List git branches')
nmap('gr', builtins.lsp_references, 'List references')
nmap('gd', builtins.lsp_definitions, 'Go to definition')
nmap('gi', builtins.lsp_implementations, 'List implementations')
nmap('<leader>sp', spell_suggest, 'Spell suggestions')
