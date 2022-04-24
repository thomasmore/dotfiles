local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode-14',
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
