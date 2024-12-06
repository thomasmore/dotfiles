local nmap = require('utils').nmap
local navic = require('nvim-navic')

local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  nmap('gD', vim.lsp.buf.declaration, 'Go to declaration')
  nmap('H', vim.lsp.buf.hover, 'Hover window for word under cursor')
  nmap('<c-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.hover()<cr>', 'ctrl-click to hover word')
  nmap('gp', function() vim.diagnostic.jump{ count = -1, float = true } end, 'Go to previous diagnostic')
  nmap('gn', function() vim.diagnostic.jump{ count = 1, float = true } end, 'Go to next diagnostic')
  nmap('<leader>q', vim.diagnostic.setloclist, 'Move diagnostic into location list')
  nmap('<leader>ln', vim.diagnostic.open_float, 'Diagnostic for current line')
  nmap('<leader>lf', function() vim.lsp.buf.format({ async = false }) end, 'Format code')
end

vim.diagnostic.config({
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

local capabilites = require('cmp_nvim_lsp').default_capabilities()
local nvim_lsp = require('lspconfig')
local servers = { 'clangd', 'solargraph', 'bashls', 'lua_ls', 'pylsp' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilites = capabilites
  }
end
