vim.notify = require("notify")

require('indent_blankline').setup {
  char = '▏',
  use_treesitter = true,
  show_first_indent_level = false,
  filetype_exclude = { 'json', 'startify' },
  buftype_exclude = { 'terminal' }
}

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  buf_set_keymap('n', 'H', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  buf_set_keymap('n', '<c-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.hover()<cr>', opts)
  buf_set_keymap('n', 'gp', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
  buf_set_keymap('n', 'gn', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
  buf_set_keymap('n', '<Leader>q', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
  buf_set_keymap('n', '<Leader>ln', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
  buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  buf_set_keymap('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  buf_set_keymap('v', '<Leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<cr>', opts)
  buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  buf_set_keymap('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
end

local nvim_lsp = require('lspconfig')
nvim_lsp.clangd.setup{
  on_attach = on_attach,
  cmd = {
    "clangd", "--background-index=0", "--clang-tidy", "--pch-storage=memory"
  },
  capabilites = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

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

local servers = { 'cmake', 'solargraph' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilites = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  }
end

local get_lsp_client = function ()
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return ''
  end

  for _,client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes,buf_ft) ~= -1 then
      return ''
    end
  end
  return ''
end

local gps = require("nvim-gps")
gps.setup()

require('lualine').setup {
  options = {
    theme = 'tokyonight',
    section_separators = { left = '', right = ''},
    component_separators = '',
    globalstatus = true,
  },
  extensions = { 'quickfix', 'nvim-tree', 'fugitive', 'toggleterm' },
  sections = {
    lualine_a = {
      {'mode', fmt = function(mode_name) return mode_name:sub(1, 1) end}
    },
    lualine_b = {'branch'},
    lualine_c = {
      {'filename', file_status = true, symbols = {modified = '*', readonly = '[-]'}},
      { gps.get_location, cond = gps.is_available },
    },
    lualine_x = {
      { 'cmake_progress()', color = function(_) return build_progress_color end },
      {
        'diagnostics',
        sources = {'nvim_diagnostic'},
        symbols = {
          error = ' ',
          warn = ' ',
          info = ' '
        }
      },
      { 'filetype' },
      { get_lsp_client },
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  }
}

vim.g.tokyonight_italic_comments = false
vim.g.tokyonight_italic_keywords = false

require('kommentary.config').configure_language("default", {
  prefer_single_line_comments = true,
  ignore_whitespace = false,
})

require('neoscroll').setup()

require"toggleterm".setup{
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  insert_mappings = false
}
local Terminal  = require('toggleterm.terminal').Terminal
local term = Terminal:new()
local vertterm = Terminal:new({direction='vertical'})
local floatterm = Terminal:new({direction='float'})

function TermToggle()
  term:toggle()
end
function VertTermToggle()
  vertterm:toggle()
end
function FloatTermToggle()
  floatterm:toggle()
end

require'lightspeed'.setup {
  ignore_case = true,
  jump_to_unique_chars = false,
  match_only_the_start_of_same_char_seqs = true,
  limit_ft_matches = 5,
  -- full_inclusive_prefix_key = '<c-x>',
  -- By default, the values of these will be decided at runtime,
  -- based on `jump_to_first_match`
  labels = nil,
  cycle_group_fwd_key = nil,
  cycle_group_bwd_key = nil,
}

local cb = require'diffview.config'.diffview_callback

require'diffview'.setup {}

require('luatab').setup{}

vim.g.nvim_tree_indent_markers = 1
require'nvim-tree'.setup()

local autosave = require("autosave")
autosave.setup(
  {
    execution_message = ""
  }
)

require('vgit').setup()

local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode-10',
  name = "lldb"
}
dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function() return vim.fn.input({
      prompt = 'Path to executable: ',
      completion = 'file'})
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    args = function() return vim.split(vim.fn.input({prompt = 'Args: '}), ' ') end, -- TODO: 1) filter out empty args 2) save for subsequent runs
    runInTerminal = false,
  },
}
dap.configurations.c = dap.configurations.cpp

local dapui = require("dapui")
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- any better way to do shallowcopy?
local function shallowcopy(tbl)
  return vim.tbl_extend('force', {}, tbl)
end

local Path = require('plenary.path')
local cmake = require('cmake')
local cmake_utils = require('cmake.utils')
local cmake_project = require('cmake.project_config')
build_progress = '[...]'
target = ''
build_type = ''
local cmake_dap_configuration = shallowcopy(dap.configurations.cpp[1])
cmake_dap_configuration.program = nil
cmake_dap_configuration.cwd = nil
cmake.setup({
  build_dir = tostring(Path:new('{cwd}', '..', 'builds', vim.fn.fnamemodify(vim.loop.cwd(), ':t')..'-{build_type}')),
  configure_args = {},
  dap_configuration = cmake_dap_configuration,  -- TODO: cd into build directory before debugging TODO: add commands to open terminal/nvim-tree in build dir
  dap_open_command = false,
  quickfix_only_on_error = true,
  on_build_output = function(line)
    local match = string.match(line, "(%[.*%%%])")
    if match then
      build_progress = string.gsub(match, "%%", "%%%%")
    end
  end
})

local ProjectConfig = require('cmake.project_config')
function cmake_progress()
  if cmake_utils.last_job then
    return target .. '(' .. build_type .. ')' .. ': ' .. build_progress
  end
  return ''
end

function cmake_build()
  build_progress_color = 'lualine_c_normal'
  local project_config = ProjectConfig.new()
  target = project_config.json.current_target
  build_type = string.sub(project_config.json.build_type, 1, 1)
  local job = cmake.build()
  job:after(vim.schedule_wrap(
    function(_, exit_code)
      if exit_code == 0 then
        build_progress_color = 'lualine_x_diagnostics_info_normal'
        cmake_utils.notify("Target was built successfully", vim.log.levels.INFO)
      else
        build_progress_color = 'lualine_x_diagnostics_warn_normal'
        cmake_utils.notify("Target build failed", vim.log.levels.ERROR)
      end
    end
  ))
end

require('legendary').setup()
