vim.notify = require("notify")

require('indent_blankline').setup {
  char = '▏',
  use_treesitter = true,
  show_first_indent_level = false,
  filetype_exclude = { 'json', 'startify' },
  buftype_exclude = { 'terminal' }
}

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  }
}

require('kommentary.config').configure_language("default", {
  prefer_single_line_comments = true,
  ignore_whitespace = false,
})

require('neoscroll').setup()


require'lightspeed'.setup {
  ignore_case = true,
  jump_to_unique_chars = false,
  match_only_the_start_of_same_char_seqs = true,
  limit_ft_matches = 7,
  labels = nil,
  cycle_group_fwd_key = nil,
  cycle_group_bwd_key = nil,
}

require'nvim-tree'.setup {
  renderer = {
    indent_markers = {
      enable = true
    }
  }
}
