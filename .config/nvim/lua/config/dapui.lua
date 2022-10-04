local dapui = require('dapui')
local dap = require('dap')
local nmap = require('utils').nmap
local vmap = require('utils').vmap

dapui.setup {
  mappings = {
    expand = { '<cr>', '<RightMouse>' },
    open = { 'o', '<2-LeftMouse>' },
  },
  layouts = {
    {
      elements = {
        { id = 'scopes', size = 0.25 },
        'breakpoints',
        'stacks',
        'watches',
      },
      size = 40,
      position = 'left',
    },
    {
      elements = {
        'repl',
      },
      size = 0.25,
      position = 'bottom',
    },
  },
}

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end

nmap(',e', dapui.eval, 'Eval word under cursor')
vmap(',e', dapui.eval, 'Eval in debug')
nmap(',q', function()
  if dap.session() then
    dap.terminate()
  end
  dapui.close()
end, 'Close debug UI')
