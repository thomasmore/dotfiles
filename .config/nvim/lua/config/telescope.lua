local ext = require('telescope._extensions')
local builtins = require('telescope.builtin')
local sorters = require('telescope.sorters')
local frecency_db = require('telescope._extensions.frecency.db_client')


local function frecency_score(self, prompt, line, entry)
  if prompt == nil or prompt == '' then
    for _, file_entry in ipairs(self.state.frecency) do
      local filepath = entry.cwd .. '/' .. entry.value
      if file_entry.filename == filepath then
        return 9999 - file_entry.score
      end
    end

    return 9999
  end

  return self.default_scoring_function(self, prompt, line, entry)
end

local function frecency_start(self, prompt)
  if self.default_start then
    self.default_start(self, prompt)
  end

  if not self.state.frecency then
    self.state.frecency = frecency_db.get_file_scores()
  end
end

local frecency_sorter = function(opts)
  local sorter = sorters.get_fuzzy_file()

  sorter.default_scoring_function = sorter.scoring_function
  sorter.default_start = sorter.start
  sorter.scoring_function = frecency_score
  sorter.start = frecency_start

  return sorter
end

require('telescope').setup({
  defaults = {
    file_sorter = frecency_sorter,
  },
})
