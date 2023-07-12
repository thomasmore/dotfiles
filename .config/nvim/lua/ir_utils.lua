local popup = require('utils').popup

local M = {}

local function ltrim(s)
  return s:match'^%s*(.*)'
end

local function get_input_def_cursor()
  local word = vim.call('expand', '<cword>')
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local prev_lines = vim.api.nvim_buf_get_lines(0, 0, cur_line, false)
  local patterns = {
    'INST(' .. word .. ', Opcode::',
    'CONSTANT(' .. word .. ', ',
    'PARAMETER(' .. word .. ', '
  }
  local found_row = 0
  local found_col = 0
  local matched = nil
  for i = #prev_lines, 1, -1 do
    for _, pattern in ipairs(patterns) do
      matched = string.find(prev_lines[i], pattern, 1, true)
      if matched then
        break
      end
    end
    if matched then
      found_row = i
      found_col = matched - 1
      break
    end
  end
  if not matched then
    return nil
  end
  return { found_row, found_col }
end

M.show_input_context = function()
  local def_cursor = get_input_def_cursor()
  if not def_cursor then
    return
  end

  local line_index = def_cursor[1]
  local context = vim.api.nvim_buf_get_lines(0, line_index - 2, line_index, true)
  local result = { ltrim(context[1]), ltrim(context[2]) }
  local win = popup(result)
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'ModeChanged', 'WinScrolled' }, { once = true, callback = function()
    if win ~= 0 then
      vim.api.nvim_win_close(win, true)
      win = nil
    end
  end })
end

M.jump_to_input_def = function()
  local def_cursor = get_input_def_cursor()
  if def_cursor then
    vim.cmd.normal("m'")  -- Add current position to jumplist
    vim.api.nvim_win_set_cursor(0, def_cursor)
  end
end

return M
