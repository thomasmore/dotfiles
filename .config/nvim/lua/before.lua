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

-- lexima
local dap_repl_group = vim.api.nvim_create_augroup('dap_repl', { clear = true })
vim.api.nvim_create_autocmd('FileType', { pattern = 'dap-repl', callback = function()
  vim.b.lexima_disabled = 1
end, group = dap_repl_group })
