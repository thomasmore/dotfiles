local function normalize(p)
  if type(p) == 'string' then p = { p } end
  return {
    src = p.url or (p[1]:match('^https?://') and p[1]) or ('https://github.com/' .. p[1]),
    name = p.as,      -- nil: vim.pack infers it from src
    version = p.branch,
    data = { config = p.config, defer = p.defer, build = p.build },
  }
end

local function run_build(build, path)
  if type(build) == 'function' then
    build()
  elseif build:sub(1, 1) == ':' then
    vim.cmd(build:sub(2))
  else
    vim.system(vim.split(build, '%s+', { trimempty = true }), { cwd = path })
  end
end

return function(plugins)
  -- Must exist before vim.pack.add() to catch fresh installs
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local d = ev.data
      local build = d.spec.data and d.spec.data.build
      if build and (d.kind == 'install' or d.kind == 'update') then
        if not d.active then vim.cmd.packadd(d.spec.name) end
        run_build(build, d.path)
      end
    end,
  })

  local now, later = {}, {}
  vim.pack.add(vim.tbl_map(normalize, plugins), {
    load = function(p)
      if p.spec.data.defer then
        table.insert(later, p.spec)
      else
        vim.cmd.packadd({ p.spec.name, bang = true })
        table.insert(now, p.spec)
      end
    end,
  })

  -- Run configs only after every plugin is on 'rtp', so configs can require
  -- plugins listed below them
  for _, s in ipairs(now) do
    if s.data.config then s.data.config() end
  end

  vim.defer_fn(function()
    for _, s in ipairs(later) do
      vim.cmd.packadd(s.name)
      if s.data.config then s.data.config() end
    end
  end, 500)
end
