-- TODO:
--
-- lsp
--    floating window instead of virtual text
--    move errors to quickfix?
--    custom emoji for signs
--    convenience plugins? (view, signature helper)
--    code_action
--    update in insert (see chris's dotfiles lua/lsp/clangd.lua)
--
-- treesitter
--    folding
--    selection
--    commenter?
--    text objects (motion, select)
--    incremental selection
--
-- indentline blank lines
--
-- telescope
--    lsp code actions
--    perf tuning? (fzy-native, minimum_grep_characters = 3)
--
-- other plugins:
--    lsp installers?
--    snippets
--    treesitter supported colorscheme
--    blame line?
--    preview for %s

vim.o.completeopt = "menuone,noselect"

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  buf_set_keymap('n', 'H', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  buf_set_keymap('n', 'gp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', opts)
  buf_set_keymap('n', 'gn', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', opts)
end

require('lspconfig').clangd.setup{
    on_attach = on_attach,
    default_config = {
        cmd = {
            "clangd", "--background-index", "--clang-tidy", "--pch-storage=memory"
        }
    }
}
require'lspconfig'.cmake.setup{
    on_attach = on_attach
}
require'lspconfig'.solargraph.setup{
    on_attach = on_attach
}

require('compe').setup {
  enabled = true;
  autocomplete = false;
  debug = false;
  preselect = 'disable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    -- vsnip = true;  TODO: enable
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
