local wezterm = require 'wezterm'
local act =  wezterm.action
local nf = wezterm.nerdfonts
local COLORSCHEME = 'Catppuccin Macchiato'
local colors = wezterm.color.get_builtin_schemes()[COLORSCHEME]

local default_domain = nil
if wezterm.running_under_wsl() then
    default_domain = 'WSL:Ubuntu'
end

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
        family = 'VictorMono Nerd Font',
    },
    default_domain = default_domain,
    freetype_load_target = 'Light',
    freetype_load_flags = 'NO_HINTING|NO_AUTOHINT',
    hyperlink_rules =  wezterm.default_hyperlink_rules(),
    color_scheme = COLORSCHEME,
    switch_to_last_active_tab_when_closing_tab = true,
    leader = { key = '\\', mods = '', timeout_milliseconds = 1000 },
    disable_default_key_bindings = true,
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
        { key = 'h', mods = 'LEADER', action = act.SpawnCommandInNewTab { args = { 'htop' } } },
        { key = 'o', mods = 'LEADER', action = act.ActivateLastTab },
        { key = ' ', mods = 'LEADER', action = act.QuickSelect },
        { key = 'c', mods = 'LEADER', action = act.ActivateCopyMode },
        { key = 's', mods = 'LEADER', action = act.Search 'CurrentSelectionOrEmptyString' },
        { key = 'Tab', mods = 'LEADER', action = act.ActivateTabRelative(1) },
        { key = 'Tab', mods = 'LEADER|SHIFT', action = act.ActivateTabRelative(-1) },
        { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
        { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
        { key = 'C', mods = 'CTRL|SHIFT', action = act.CopyTo 'ClipboardAndPrimarySelection' },
        { key = 'V', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
    },
    use_fancy_tab_bar = false,
    show_new_tab_button_in_tab_bar = false,
    tab_max_width = 32,
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

wezterm.on('update-right-status', function(window)
    if counter <= 0 then
        local success, stdout, _ = wezterm.run_child_process{'curl', 'wttr.in/Moscow?format=1'}
        if success and stdout:len() < 100 then
            weather = stdout
        else
            weather = ''
        end
        counter = INTERVAL
    else
        counter = counter - 1
    end

    local _, cpu, _ = wezterm.run_child_process{'bash', os.getenv('HOME')..'/.config/wezterm/cpu.sh'}
    local _, mem, _ = wezterm.run_child_process{'bash', os.getenv('HOME')..'/.config/wezterm/mem.sh'}

    buf_shift(cpu_buf, tonumber(cpu))
    buf_shift(mem_buf, tonumber(mem))

    local separator = nf.ple_lower_right_triangle
    -- local separator_left = nf.ple_lower_left_triangle
    -- local separator_inner = nf.ple_forwardslash_separator
    -- local separator_inner_left = nf.ple_backslash_separator

    local base_color = wezterm.color.parse(colors.tab_bar.background)
    window:set_right_status(wezterm.format {
        { Foreground = { Color = base_color:lighten_fixed(0.1) } },
        { Text = separator },
        { Background = { Color = base_color:lighten_fixed(0.1) } },
        { Foreground = { Color = '#795F80' } },
        { Text = table.concat(mem_buf, '') .. ' ' },
        { Foreground = { Color = base_color:lighten_fixed(0.2) } },
        { Text = separator },
        { Background = { Color = base_color:lighten_fixed(0.2) } },
        { Foreground = { Color = '#658CBB' } },
        { Text = table.concat(cpu_buf, '') .. ' ' },
        { Foreground = { Color = base_color:lighten_fixed(0.3) } },
        { Text = separator },
        { Background = { Color = base_color:lighten_fixed(0.3) } },
        { Foreground = { Color = '#cccccc' } },
        { Text = weather },
    })
end)

local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on('format-tab-title', function(tab)
    local edge_background = ''
    local edge_foreground = ''
    local separator = nf.ple_lower_left_triangle
    local cells = {}

    local title = ' ' .. tab_title(tab)

    if tab.is_active then
        title = title .. ' '
        edge_background = colors.tab_bar.inactive_tab.bg_color
        edge_foreground = colors.tab_bar.active_tab.bg_color
        if tab.tab_index ~= 0 then
            table.insert(cells, { Background = { Color = edge_foreground } })
            table.insert(cells, { Foreground = { Color = edge_background } })
            table.insert(cells, { Text = separator })
        end
    else
        edge_background = colors.tab_bar.inactive_tab.bg_color
        edge_foreground = colors.tab_bar.inactive_tab.bg_color
    end

    table.insert(cells, { Text = title })
    table.insert(cells, { Background = { Color = edge_background } })
    table.insert(cells, { Foreground = { Color = edge_foreground } })
    table.insert(cells, { Text = separator })

    return cells
end)

return config
