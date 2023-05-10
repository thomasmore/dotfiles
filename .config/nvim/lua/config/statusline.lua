local popup = require('utils').popup
local navic = require('nvim-navic')
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

local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "Recording @" .. recording_register
  end
end

vim.o.shortmess = vim.o.shortmess .. "S"

_G.status_win = nil

require('lualine').setup {
  options = {
    theme = 'catppuccin',
    section_separators = { left = '', right = ''},
    component_separators = '',
    always_divide_middle = false,
    globalstatus = true,
    refresh = {
      statusline = 150,
    },
  },
  extensions = { 'quickfix', 'nvim-tree', 'fugitive', 'toggleterm' },
  sections = {
    lualine_a = {
      {'mode', fmt = function(mode_name) return mode_name:sub(1, 1) end}
    },
    lualine_b = {
      {
        'branch' ,
        on_click = function()
          if _G.status_win then
            vim.api.nvim_win_close(_G.status_win, true)
            _G.status_win = nil
          else
            local scriptname = './git_branch.sh'
            if vim.fn.filereadable(scriptname) == 0 then
              return
            end
            local output = vim.fn.system(scriptname)
            _G.status_win = popup(output, { relative = 'mouse', anchor = 'SW', row = 0 })
          end
        end
      }
    },
    lualine_c = {
      {'filename', file_status = true, path = 1, symbols = {modified = '*', readonly = '[-]'}},
      { function() return navic.get_location() end, cond = function() return navic.is_available() end },
    },
    lualine_x = {
      { show_macro_recording },
      {
        'searchcount',
        on_click = function() vim.cmd.nohlsearch() end
      },
      {
        cmake.progress ,
        color = function(_) return cmake.color end,
        on_click = function() cmake.select_build_type() end
      },
      {
        'diagnostics',
        sources = {'nvim_diagnostic'},
        symbols = {
          error = ' ',
          warn = ' ',
          info = ' '
        },
        on_click = function() vim.diagnostic.setloclist() end,
      },
    },
    lualine_y = {
      { 'filetype' },
      { get_lsp_client, padding = { left = 0, right = 1 } },
    },
    lualine_z = {'location'}
  },
}
