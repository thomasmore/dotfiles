local wezterm = require 'wezterm' 
local act =  wezterm.action

local config = {
    window_decorations = 'RESIZE',
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    font_size = 13,
    font =  wezterm.font {
        family = 'VictorMono NF',
        weight = 'Medium',
    },
    default_domain = 'WSL:Ubuntu-20.04',
    --freetype_load_target = 'Light',
    freetype_load_flags = 'NO_HINTING|NO_AUTOHINT',
    hyperlink_rules =  wezterm.default_hyperlink_rules(),
    color_scheme = 'Catppuccin Macchiato',
    switch_to_last_active_tab_when_closing_tab = true,
    leader = { key = '\\', mods = '', timeout_milliseconds = 1000 },
    keys = {
        { key = '\\', mods = 'LEADER', action = act.SendKey { key = '\\' } },
        { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
        { key = 'f', mods = 'LEADER', action = act.ToggleFullScreen },
        { key = 'q', mods = 'LEADER', action = act.ActivateTab(0) },
        { key = 'w', mods = 'LEADER', action = act.ActivateTab(1) },
        { key = 'e', mods = 'LEADER', action = act.ActivateTab(2) },
        { key = 'r', mods = 'LEADER', action = act.ActivateTab(3) },
        { key = 'p', mods = 'LEADER', action = act.ActivateCommandPalette },
        { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } },
        { key = 't', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
        --{ key = 'h', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
        --{ key = 'j', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
        --{ key = 'k', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
        --{ key = 'l', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
        { key = 'h', mods = 'LEADER', action = act.SpawnCommandInNewTab { args = { 'htop' } } },
        { key = 'o', mods = 'LEADER', action = act.ActivateLastTab },
    },
    use_fancy_tab_bar = false,
    show_new_tab_button_in_tab_bar = false,
    tab_max_width = 32,
}

table.insert(config.hyperlink_rules, {
    regex = [[['']([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)['']?]],
    format = 'https://www.github.com/$1/$3',
})
table.insert(config.hyperlink_rules, {
    regex = [[\bpanda#(\d+)\b]],
    format = 'https://rnd-gitlab-msc.huawei.com/rus-os-team/virtual-machines-and-tools/panda/-/issues/$1',
})

--[[
local colors = wezterm.color.get_default_colors()

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_lower_left_triangle

function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = colors.background
    local background = colors.brights[1]
    local foreground = colors.foreground
    if tab.is_active then
      background = colors.ansi[7]
      foreground = colors.background
    elseif hover then
      background = colors.ansi[6]
      foreground = colors.background
    end
    local edge_foreground = background

    local title = tab_title(tab)
    title = wezterm.truncate_right(title, max_width - 2)

    return {
        { Background = { Color = edge_background } },
        { Foreground = { Color = edge_foreground } },
        { Text = SOLID_LEFT_ARROW },
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title },
        { Background = { Color = edge_background } },
        { Foreground = { Color = edge_foreground } },
        { Text = SOLID_RIGHT_ARROW },
    }
  end
)
--]]
 
return config
