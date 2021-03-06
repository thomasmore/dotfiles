-- any better way to do shallowcopy?
local function shallowcopy(tbl)
  return vim.tbl_extend('force', {}, tbl)
end

local Path = require('plenary.path')
local cmake = require('cmake')
local cmake_utils = require('cmake.utils')
local build_progress = '[...]'
cmake.target = ''
cmake.build_type = ''
cmake.progress_color = ''
local cmake_dap_configuration = shallowcopy(require('dap').configurations.cpp[1])
cmake_dap_configuration.program = nil
cmake_dap_configuration.cwd = nil
cmake.setup({
  build_dir = tostring(Path:new('{cwd}', '..', 'builds', vim.fn.fnamemodify(vim.loop.cwd(), ':t')..'-{build_type}')),
  configure_args = {},
  dap_configuration = cmake_dap_configuration,  -- TODO: cd into build directory before debugging TODO: add commands to open terminal/nvim-tree in build dir
  dap_open_command = false,
  quickfix = {
    only_on_error = true,
  },
  on_build_output = function(lines)
    local match = string.match(lines[#lines], "(%[.*%%%])")
    if match then
      build_progress = string.gsub(match, "%%", "%%%%")
    end
  end
})

function cmake_progress()
  if cmake_utils.last_job then
    return cmake.target .. '(' .. cmake.build_type .. ')' .. ': ' .. build_progress
  end
  return ''
end

function cmake_build()
  cmake.progress_color = 'lualine_c_normal'
  local project_config = require('cmake.project_config').new()
  cmake.target = project_config.json.current_target
  cmake.build_type = string.sub(project_config.json.build_type, 1, 1)
  local job = cmake.build()
  if job then
    job:after(vim.schedule_wrap(
      function(_, exit_code)
        if exit_code == 0 then
          cmake.progress_color = 'lualine_x_diagnostics_info_normal'
          cmake_utils.notify("Target was built successfully", vim.log.levels.INFO)
        else
          cmake.progress_color = 'lualine_x_diagnostics_warn_normal'
          cmake_utils.notify("Target build failed", vim.log.levels.ERROR)
        end
      end
    ))
  end
end
