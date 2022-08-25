local dapui = require('dapui')
local dap = require('dap')
local nmap = require('utils').nmap
local vmap = require('utils').vmap

dapui.setup {
  mappings = {
    expand = { '<cr>', '<RightMouse>' },
    open = { 'o', '<2-LeftMouse>' },
  },
}
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

nmap(',e', dapui.eval, 'Eval word under cursor')
vmap(',e', dapui.eval, 'Eval in debug')
