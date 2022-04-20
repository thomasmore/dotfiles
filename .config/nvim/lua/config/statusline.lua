local gps = require('nvim-gps')
local cmake = require('cmake')

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

gps.setup()

require('lualine').setup {
  options = {
    theme = 'tokyonight',
    section_separators = { left = '', right = ''},
    component_separators = '',
    always_divide_middle = false,
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
    },
    lualine_y = {
      { 'filetype' },
      { get_lsp_client, padding = { left = 0, right = 1 } },
    },
    lualine_z = {'progress'},
    -- lualine_z = {'location'}
  },
}
