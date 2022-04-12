require('toggleterm').setup{
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
