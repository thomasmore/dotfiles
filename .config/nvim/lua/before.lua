local g = vim.g

-- better whitespaces
g.better_whitespace_enabled = 1
g.strip_whitespace_on_save = 1
g.strip_only_modified_lines = 1
g.show_spaces_that_precede_tabs = 1

-- vim-rooter
g.rooter_patterns = { '.git' }
g.rooter_silent_chdir = 1

-- startify
g.startify_session_persistence = 1
g.startify_fortune_use_unicode = 1
g.startify_lists = {
  { type = 'dir', header = { '   MRU ' .. vim.fn.getcwd() } },
  { type = 'sessions', header = { '   Sessions' } },
  { type = 'files', header = { '   MRU' } }
}

-- vim-notes
g.notes_directories = { '~/nvimnotes' }

-- copilot
g.copilot_no_tab_map = true
