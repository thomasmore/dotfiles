local wezterm = require 'wezterm'
local act = wezterm.action

local config = {
    window_decorations = "RESIZE",
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    font_size = 13,
    font = wezterm.font {
        family = "VictorMono NF",
        weight = "Medium",
    },
    default_domain = 'WSL:Ubuntu-20.04',
    --freetype_load_target = "Light",
    freetype_load_flags = "NO_HINTING|NO_AUTOHINT",
    hyperlink_rules = wezterm.default_hyperlink_rules(),
    color_scheme = 'Catppuccin Macchiato',
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
        { key = 't', mods = 'LEADER', action = act.ActivateTab(4) },
        { key = 'y', mods = 'LEADER', action = act.ActivateTab(5) },
        { key = 'u', mods = 'LEADER', action = act.ActivateTab(6) },
        { key = 'i', mods = 'LEADER', action = act.ActivateTab(7) },
        { key = 'p', mods = 'LEADER', action = act.ActivateCommandPalette },
        { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } },
    }
}

table.insert(config.hyperlink_rules, {
    regex = [[["']([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["']?]],
    format = 'https://www.github.com/$1/$3',
})
table.insert(config.hyperlink_rules, {
    regex = [[\bpanda#(\d+)\b]],
    format = 'https://rnd-gitlab-msc.huawei.com/rus-os-team/virtual-machines-and-tools/panda/-/issues/$1',
})
 
return config
