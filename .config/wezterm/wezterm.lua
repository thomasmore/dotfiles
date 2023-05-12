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
    freetype_load_target = 'Light',
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
    hide_tab_bar_if_only_one_tab = true,
    quick_select_patterns = {
        'git push --set-upstream .*'
    },
}

table.insert(config.hyperlink_rules, {
    regex = [[['']([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)['']?]],
    format = 'https://www.github.com/$1/$3',
})

local INTERVAL = 5*60
local counter = 0
local weather = ''
local cpu_buf = {}
local mem_buf = {}
local LENGTH = 7

local function buf_init(buf, n)
    for i = 1, n do
        buf[i] = '▁'
    end
end

local function bar(num)
    local dots = math.ceil(num / 12.5)
    if dots == 0 then dots = 1 end
    local unicode = {'▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'}
    return unicode[dots]
end

local function buf_shift(buf, num)
    table.remove(buf, 1)
    buf[LENGTH] = bar(num)
end

buf_init(cpu_buf, LENGTH)
buf_init(mem_buf, LENGTH)

wezterm.on('update-right-status', function(window, pane)
    if counter <= 0 then
        local success, stdout, _ = wezterm.run_child_process{'curl', 'wttr.in/Moscow?format=1'}
        if success then
            weather = stdout
        end
        counter = INTERVAL
    else
        counter = counter - 1
    end

    local _, cpu, _ = wezterm.run_child_process{'bash', '$HOME/.config/wezterm/cpu.sh'}
    local _, mem, _ = wezterm.run_child_process{'bash', '$HOME/.config/wezterm/mem.sh'}

    buf_shift(cpu_buf, tonumber(cpu))
    buf_shift(mem_buf, tonumber(mem))

    window:set_right_status(wezterm.format {
        { Foreground = { Color = '#795F80' } },
        { Text = table.concat(cpu_buf, '') .. ' ' },
        { Foreground = { Color = '#658CBB' } },
        { Text = table.concat(mem_buf, '') .. ' ' },
        { Foreground = { Color = '#cccccc' } },
        { Text = weather },
    })
end)

return config
