local M = {}

local function map(mode, from, to, desc, opts)
  opts = opts or { silent = true }
  opts.desc = desc
  vim.keymap.set(mode, from, to, opts)
end

local function toset(arr)
  local set = {}
  for _, v in ipairs(arr) do
    set[v] = true
  end
  return set
end

local function rooter_find_parent(path, parent_names)
  parent_names = parent_names or {}
  local set = toset(parent_names)
  for dir in vim.fs.parents(path) do
    parent = vim.fs.basename(vim.fs.dirname(dir))
    if set[parent] then
      return dir
    end
  end
  return nil
end

local function rooter_find_root(path, root_names)
  root_names = root_names or {}
  local root_file = vim.fs.find(root_names, { path = path, upward = true, limit = 1 })[1]
  if root_file == nil then
    return nil
  end
  return vim.fs.dirname(root_file)
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

local rooter_cache = {}

M.rooter = function(parent_names, root_names)
  local buf_name = vim.api.nvim_buf_get_name(0)
  if buf_name == '' then
    buf_name = vim.fn.getcwd() .. '/tmp.tmp'
  end
  local dir_name = vim.fs.dirname(buf_name)
  local root = rooter_cache[dir_name] or
    rooter_find_parent(buf_name, parent_names) or
    rooter_find_root(buf_name, root_names)
  if root then
    rooter_cache[dir_name] = root
    vim.fn.chdir(root)
  end
end

return M
