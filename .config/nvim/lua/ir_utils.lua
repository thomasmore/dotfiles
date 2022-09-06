local M = {}

local function ltrim(s)
  return s:match'^%s*(.*)'
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

local function get_input_def_cursor()
  local word = vim.call('expand','<cword>')
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
    for j, pattern in ipairs(patterns) do
      matched, _ = string.find(prev_lines[i], pattern, 1, true)
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
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, result)
  local opts = {
    width = max_elem_len(result),
    height = 2,
    relative = 'cursor',
    col = 0,
    row = 1,
    focusable = false,
    style = 'minimal',
    border = 'rounded'
  }
  local win = vim.api.nvim_open_win(buf, false, opts)
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'ModeChanged', 'WinScrolled' }, { once = true, callback = function()
    if win then
      vim.api.nvim_win_close(win, true)
      win = nil
    end
  end })
end

M.jump_to_input_def = function()
  local def_cursor = get_input_def_cursor()
  if def_cursor then
    vim.api.nvim_win_set_cursor(0, def_cursor)
  end
end

return M