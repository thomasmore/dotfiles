local M = {}

local function map(mode, from, to, desc, opts)
  opts = opts or { silent = true }
  opts.desc = desc
  vim.keymap.set(mode, from, to, opts)
end

for _, v in ipairs({'', 'n', 'x', 'o', 'i', 'v', 't'}) do
  M[v .. 'map'] = function(from, to, desc, opts)
    map(v, from, to, desc, opts)
  end
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
