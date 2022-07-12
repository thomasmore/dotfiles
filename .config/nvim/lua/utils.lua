local M = {}

local function map(mode, from, to, opts)
  opts = opts or { silent = true }
  vim.keymap.set(mode, from, to, opts)
end

M.map = function(from, to, opts)
  map('', from, to, opts)
end

M.xmap = function(from, to, opts)
  map('x', from, to, opts)
end

M.omap = function(from, to, opts)
  map('o', from, to, opts)
end

M.imap = function(from, to, opts)
  map('i', from, to, opts)
end

M.replace_termcodes = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.aucmd = function(event, group, opts)
  if type(group) == 'string' then
    group = vim.api.nvim_create_augroup(group, { clear = true })
  end
  opts.group = group
  vim.api.nvim_create_autocmd(event, opts)
  return group
end

return M
