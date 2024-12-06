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

local function max_elem_len(a)
  local max = 0
  for _, v in ipairs(a) do
    if max < #v then
      max = #v
    end
  end
  return max
end

local function rooter_find_root(path, root_names)
  root_names = root_names or {}
  local set = toset(root_names)
  for dir in vim.fs.parents(path) do
    local base_name = vim.fs.basename(dir)
    if set[base_name] then
      return dir
    end
  end
  return nil
end

local function rooter_find_parent(path, parent_names)
  parent_names = parent_names or {}
  local set = toset(parent_names)
  for dir in vim.fs.parents(path) do
    local parent = vim.fs.basename(vim.fs.dirname(dir))
    if set[parent] then
      return dir
    end
  end
  return nil
end

local function rooter_find_in_root(path, in_root_names)
  in_root_names = in_root_names or {}
  local root_file = vim.fs.find(in_root_names, { path = path, upward = true, limit = 1 })[1]
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

M.aucmd = function(event, group, pattern, callback)
  if type(group) == 'string' then
    group = vim.api.nvim_create_augroup(group, { clear = true })
  end
  local opts = {}
  opts.group = group
  opts.pattern = pattern
  opts.callback = callback
  vim.api.nvim_create_autocmd(event, opts)
  return group
end

local rooter_cache = {}

M.rooter = function(root_names, parent_names, in_root_names)
  local buf_name = vim.api.nvim_buf_get_name(0)
  if buf_name == '' then
    buf_name = vim.fn.getcwd() .. '/tmp.tmp'
  end
  if buf_name:find('://', 1, true) then
    return
  end
  local dir_name = vim.fs.dirname(buf_name)
  local root = rooter_cache[dir_name]
  if not root then
    root = rooter_find_root(buf_name, root_names) or
      rooter_find_parent(buf_name, parent_names) or
      rooter_find_in_root(buf_name, in_root_names)
    rooter_cache[dir_name] = root
  end
  if root then
    vim.fn.chdir(root)
  end
end

M.simple_fold = function()
  local fs, fe = vim.v.foldstart, vim.v.foldend
  local start_line = vim.fn.getline(fs):gsub("\t", ("\t"):rep(vim.opt.ts:get()))
  local end_line = vim.trim(vim.fn.getline(fe))
  local lines = string.format("  [ %d lines ]", fe - fs + 1)
  local spaces = (" "):rep( vim.o.columns - start_line:len() - end_line:len() - 7 - lines:len())
  return start_line .. "  " .. end_line .. lines .. spaces
end

M.run_file = function()
    local fts = {
        python     = 'python %',
        ruby       = 'ruby %',
        java       = 'java %',
        lua        = 'luajit %',
        typescript = 'bin/es2panda --opt-level=2 --output=temp.abc % && bin/ark --boot-panda-files=plugins/ets/etsstdlib.abc --load-runtimes=ets temp.abc ETSGLOBAL::main'
    }

    local cmd = fts[vim.bo.ft]
    if not cmd then
      vim.cmd.echo('"No command for this filetype"')
    else
      vim.cmd.TermExec('cmd="' .. cmd .. '"')
    end
end

M.popup = function(text, user_opts)
  if type(text) == 'string' then
    text = vim.split(text, "\n", { plain = true, trimempty = true })
  end
  user_opts = user_opts or {}

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, text)

  local default_opts = {
    width = max_elem_len(text),
    height = #text,
    relative = 'cursor',
    col = 0,
    row = 1,
    focusable = false,
    style = 'minimal',
    border = 'rounded'
  }
  local opts = vim.tbl_extend('force', default_opts, user_opts)
  return vim.api.nvim_open_win(buf, false, opts)
end

M.strip_windows_line_ending = function()
  local saved_view = vim.fn.winsaveview()
  -- do this for the whole buffer currently
  pcall(vim.cmd, '%s/\r//')
  vim.fn.winrestview(saved_view)
end

return M
