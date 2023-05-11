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
local cpu_buf = {'▁', '▁', '▁', '▁', '▁'}
local mem_buf = {'▁', '▁', '▁', '▁', '▁'}
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

    local _, cpu, _ = wezterm.run_child_process{'bash', '$HOME/.local/bin/cpu.sh'}
    local _, mem, _ = wezterm.run_child_process{'bash', '$HOME/.local/bin/mem.sh'}

    weather = weather:gsub('\n', '')
    cpu = tonumber(cpu)
    mem = tonumber(mem)

    table.remove(cpu_buf, 1)
    cpu_buf[5] = bar(cpu)

    table.remove(mem_buf, 1)
    mem_buf[5] = bar(mem)

    window:set_right_status(wezterm.format {
        { Foreground = { Color = '#795F80' } },
        { Text = table.concat(cpu_buf, '') .. ' ' },
        { Foreground = { Color = '#658CBB' } },
        { Text = table.concat(mem_buf, '') .. ' ' },
        { Foreground = { Color = '#cccccc' } },
        { Text = weather },
    })
end)

--[[
    cpu.sh:
#!/bin/bash

sleepDurationSeconds=0.2

previousDate=$(date +%s%N | cut -b1-13)
previousLine=$(cat /proc/stat | head -n 1)

sleep $sleepDurationSeconds

currentDate=$(date +%s%N | cut -b1-13)
currentLine=$(cat /proc/stat | head -n 1)

user=$(echo "$currentLine" | awk -F " " '{print $2}')
nice=$(echo "$currentLine" | awk -F " " '{print $3}')
system=$(echo "$currentLine" | awk -F " " '{print $4}')
idle=$(echo "$currentLine" | awk -F " " '{print $5}')
iowait=$(echo "$currentLine" | awk -F " " '{print $6}')
irq=$(echo "$currentLine" | awk -F " " '{print $7}')
softirq=$(echo "$currentLine" | awk -F " " '{print $8}')
steal=$(echo "$currentLine" | awk -F " " '{print $9}')
guest=$(echo "$currentLine" | awk -F " " '{print $10}')
guest_nice=$(echo "$currentLine" | awk -F " " '{print $11}')

prevuser=$(echo "$previousLine" | awk -F " " '{print $2}')
prevnice=$(echo "$previousLine" | awk -F " " '{print $3}')
prevsystem=$(echo "$previousLine" | awk -F " " '{print $4}')
previdle=$(echo "$previousLine" | awk -F " " '{print $5}')
previowait=$(echo "$previousLine" | awk -F " " '{print $6}')
previrq=$(echo "$previousLine" | awk -F " " '{print $7}')
prevsoftirq=$(echo "$previousLine" | awk -F " " '{print $8}')
prevsteal=$(echo "$previousLine" | awk -F " " '{print $9}')
prevguest=$(echo "$previousLine" | awk -F " " '{print $10}')
prevguest_nice=$(echo "$previousLine" | awk -F " " '{print $11}')

PrevIdle=$((previdle + previowait))
Idle=$((idle + iowait))

PrevNonIdle=$((prevuser + prevnice + prevsystem + previrq + prevsoftirq + prevsteal))
NonIdle=$((user + nice + system + irq + softirq + steal))

PrevTotal=$((PrevIdle + PrevNonIdle))
Total=$((Idle + NonIdle))

totald=$((Total - PrevTotal))
idled=$((Idle - PrevIdle))

CPU_Percentage=$(awk "BEGIN {print ($totald - $idled)/$totald*100}")

echo $CPU_Percentage

   mem.sh:
#!/bin/bash

free | grep Mem | awk '{print $3/$2 * 100.0}'
]]
return config
