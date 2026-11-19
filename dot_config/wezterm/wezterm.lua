local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.audible_bell = "Disabled"
config.font = wezterm.font_with_fallback({ "0xProto Nerd Font Mono", "Symbols Nerd Font" })
config.font_size = 20

config.hide_tab_bar_if_only_one_tab = true
config.window_frame = {
	active_titlebar_bg = "#232a2e",
	inactive_titlebar_bg = "#232a2e",
}
-- Everforest, as the Linux machines show it: the terminal colors of Noctalia's "Everforest" palette
-- (dark), which Noctalia gives foot there (api.noctalia.dev/palettes/Everforest). The tab bar uses
-- the palette's surface colors.
config.colors = {
	foreground = "#d3c6aa",
	background = "#1e2326",
	cursor_bg = "#e69875",
	cursor_border = "#e69875",
	cursor_fg = "#4c3743",
	selection_fg = "#d3c6aa",
	selection_bg = "#4c3743",
	split = "#475258",
	ansi = { "#7a8478", "#e67e80", "#a7c080", "#dbbc7f", "#7fbbb3", "#d699b6", "#83c092", "#f2efdf" },
	brights = { "#a6b0a0", "#f85552", "#8da101", "#dfa000", "#3a94c5", "#df69ba", "#35a77c", "#fffbef" },
	tab_bar = {
		inactive_tab_edge = "#2d353b",
		active_tab = { bg_color = "#1e2326", fg_color = "#d3c6aa" },
		inactive_tab = { bg_color = "#232a2e", fg_color = "#859289" },
		inactive_tab_hover = { bg_color = "#2d353b", fg_color = "#d3c6aa" },
		new_tab = { bg_color = "#232a2e", fg_color = "#859289" },
		new_tab_hover = { bg_color = "#2d353b", fg_color = "#d3c6aa" },
	},
}

config.default_prog = { "nu.exe" }

config.leader = { key = "z", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "F11",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "o",
		mods = "LEADER",
		action = wezterm.action.RotatePanes("Clockwise"),
	},
	{
		key = "o",
		mods = "LEADER|SHIFT",
		action = wezterm.action.RotatePanes("CounterClockwise"),
	},
	{
		key = "h",
		mods = "ALT",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "l",
		mods = "ALT",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "j",
		mods = "ALT",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "k",
		mods = "ALT",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "l",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "h",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Left",
			size = { Percent = 50 },
		}),
	},
	{
		key = "j",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "k",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Up",
			size = { Percent = 50 },
		}),
	},
	{
		key = "l",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "{",
		mods = "CTRL|SHIFT",
		action = wezterm.action.MoveTabRelative(-1),
	},
	{
		key = "}",
		mods = "CTRL|SHIFT",
		action = wezterm.action.MoveTabRelative(1),
	},
}

return config
