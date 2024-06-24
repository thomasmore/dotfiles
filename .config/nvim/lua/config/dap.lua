local dap = require('dap')
local nmap = require('utils').nmap

dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode-16',
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
    stopOnEntry = false,
    args = function() return vim.split(vim.fn.input({prompt = 'Args: '}), ' ', { trimempty = true }) end,
    runInTerminal = false,
  },
}
dap.configurations.c = dap.configurations.cpp

nmap(',c', dap.continue, 'Continue')
nmap(',n', dap.step_over, 'Next (step over)')
nmap(',i', dap.step_into, 'Step into')
nmap(',f', dap.step_out, 'Finish (step out)')
nmap(',b', dap.toggle_breakpoint, 'Breakpoint toggle')
nmap(',B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, 'Breakpoint conditional')
nmap(',r', dap.run_to_cursor, 'Run to cursor')
