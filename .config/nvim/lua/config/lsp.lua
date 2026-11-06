local nmap = require('utils').nmap
local navic = require('nvim-navic')

local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  local function bmap(from, to, desc)
    nmap(from, to, desc, { silent = true, buffer = bufnr })
  end

  bmap('gD', vim.lsp.buf.declaration, 'Go to declaration')
  bmap('H', vim.lsp.buf.hover, 'Hover window for word under cursor')
  bmap('<leader>q', vim.diagnostic.setloclist, 'Move diagnostic into location list')
  bmap('<leader>ln', vim.diagnostic.open_float, 'Diagnostic for current line')
  bmap('<leader>lf', function() vim.lsp.buf.format({ async = false }) end, 'Format code')
end

vim.diagnostic.config({
  -- builtin ]d/[d/]D/[D show the float after jumping
  jump = {
    on_jump = function(diagnostic, bufnr)
      if diagnostic then
        vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor', focus = false })
      end
    end,
  },
  virtual_text = false,
  update_in_insert = false,
  underline = false,
  signs = {
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    },
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { 'clangd', 'solargraph', 'bashls', 'lua_ls', 'pylsp', 'ts_ls' }
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, { on_attach = on_attach, capabilities = capabilities })
end
vim.lsp.enable(servers)
