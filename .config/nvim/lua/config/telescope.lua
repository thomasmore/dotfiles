require('telescope').setup()
require('telescope').load_extension('zf-native')

local nmap = require('utils').nmap
local telescope = require('telescope.builtin')
local themes = require('telescope.themes')

local function spell_suggest()
  telescope.spell_suggest(
    themes.get_cursor {
      prompt_title = "",
      layout_config = {
        height = 0.6,
        width = 0.25
      }
    }
  )
end

nmap('<c-p>', telescope.find_files, 'Find file')
nmap('<c-l>', telescope.current_buffer_fuzzy_find, 'Live search in current file')
nmap('<c-h>', telescope.oldfiles, 'Open recent file')
nmap('<leader>gg', telescope.grep_string, 'Grep for word under the cursor')
nmap('<leader>lg', telescope.live_grep, 'Live grep for typed string')
nmap('<leader>b', telescope.buffers, 'List open buffers')
nmap('gco', telescope.git_branches, 'List git branches')
nmap('gr', telescope.lsp_references, 'List references')
nmap('gd', telescope.lsp_definitions, 'Go to definition')
nmap('gi', telescope.lsp_implementations, 'List implementations')
nmap('c-RightMouse', '<LeftMouse><cmd>Telescope lsp_definitions<cr>', 'Go to definition or list them')
nmap('<leader>sp', spell_suggest, 'Spell suggestions')
