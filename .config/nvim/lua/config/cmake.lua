local nmap = require('utils').nmap
local Path = require('plenary.path')
local dap = require('dap')

local cmake = require('cmake')
local cmake_utils = require('cmake.utils')
local cmake_project_config = require('cmake.project_config')

-- any better way to do shallowcopy?
local function shallowcopy(tbl)
  return vim.tbl_extend('force', {}, tbl)
end

local last_frame = 0
local function animate()
  local frames = { '⠏', '⠛', '⠹', '⠼', '⠶', '⠧'}
  last_frame = (last_frame + 1) % #frames
  return frames[last_frame + 1]
end

local function reset_progress(target_name)
  cmake.build_progress = '[...]'
  cmake.color = 'lualine_c_normal'
  cmake.in_progress = true

  local project_config = cmake_project_config.new()
  cmake.target = target_name and target_name or project_config.json.current_target
  cmake.build_type = string.sub(project_config.json.build_type, 1, 1)
end

local function show_progress()
  if cmake_utils.last_job then
    local throbber = ''
    if cmake.in_progress then
      throbber = animate()
    end
    return throbber .. ' ' .. cmake.target .. '(' .. cmake.build_type .. ')' .. ': ' .. cmake.build_progress
  end
  return ''
end

local function on_output(lines)
  local last_line = lines[#lines]
  local match = string.match(last_line, "(%[%s*%d.*%])")
  if match then
    cmake.build_progress = string.gsub(match, "%%", "%%%%")
  end
end

local function on_exit(_, exit_code)
  cmake.in_progress = false
  if exit_code == 0 then
    cmake.color = 'lualine_x_diagnostics_info_normal'
    cmake_utils.notify("Target was built successfully", vim.log.levels.INFO)
  else
    cmake.color = 'lualine_x_diagnostics_warn_normal'
    cmake_utils.notify("Target build failed", vim.log.levels.ERROR)
  end
end

local function progress_wrapper(callback, target_name)
  reset_progress(target_name)
  local job = callback()
  if job then
    job:after(vim.schedule_wrap(on_exit))
  end
end

cmake.color = ''
cmake.target = ''
cmake.build_type = ''
cmake.build_progress = ''
cmake.in_progress = false
cmake.progress = show_progress

local cmake_dap_configuration = shallowcopy(dap.configurations.cpp[1])
cmake_dap_configuration.program = nil
cmake_dap_configuration.cwd = nil

cmake.setup({
  build_dir = tostring(Path:new('{cwd}', '..', 'builds', '{cwd_base}-{build_type}')),
  configure_args = {'-GNinja'},
  dap_configuration = cmake_dap_configuration,
  dap_open_command = false,
  quickfix = {
    only_on_error = true,
  },
  on_build_output = on_output
})

local function cmake_build()
  progress_wrapper(cmake.build)
end

local function cmake_configure()
  progress_wrapper(cmake.configure, 'cmake')
end

nmap('<leader>m', cmake_build, 'Build target')
nmap('<leader>ct', cmake.select_target, 'Select target')
nmap('<leader>d', cmake.debug, 'Debug target')
nmap('<leader>cc', cmake_configure, 'CMake configure')
nmap('<leader>cr', cmake.run, 'CMake run')
