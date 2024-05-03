local nmap = require('utils').nmap
local vmap = require('utils').vmap
local imap = require('utils').imap
local navic = require('nvim-navic')

local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  nmap('gD', vim.lsp.buf.declaration, 'Go to declaration')
  nmap('H', vim.lsp.buf.hover, 'Hover window for word under cursor')
  nmap('<c-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.hover()<cr>', 'ctrl-click to hover word')
  nmap('gp', vim.diagnostic.goto_prev, 'Go to previous diagnostic')
  nmap('gn', vim.diagnostic.goto_next, 'Go to next diagnostic')
  nmap('<leader>q', vim.diagnostic.setloclist, 'Move diagnostic into location list')
  nmap('<leader>ln', vim.diagnostic.open_float, 'Diagnostic for current line')
  nmap('<leader>lf', function() vim.lsp.buf.format({ async = false }) end, 'Format code')
end

for _, name in ipairs({"Error", "Warn", "Info", "Hint"}) do
  vim.fn.sign_define("DiagnosticSign" .. name, {text = "", numhl = "Diagnostic" .. name})
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    underline = false,
  }
)

local capabilites = require('cmp_nvim_lsp').default_capabilities()
local nvim_lsp = require('lspconfig')
local servers = { 'clangd', 'solargraph', 'bashls', 'lua_ls', 'pylsp' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilites = capabilites
  }
end
