local wezterm = require("wezterm") ---@type Wezterm
local config = wezterm.config_builder() ---@type Config
local act = wezterm.action
local font = wezterm.font("FiraMono Nerd Font Mono")

config.macos_hide_from_tasks = true
config.notification_handling = "SuppressFromFocusedTab"
config.prefer_to_spawn_tabs = true

-- State/Size
config.remember_window_state = true
config.remember_window_position = true

-- TABS:
config.use_fancy_tab_bar = true
local fancy_bar = require("modules.fancy_bar")
fancy_bar.build_fancy_bar(config)
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
-- config.hide_tab_bar_if_only_one_tab = true

-- Styling
config.color_scheme = "Catppuccin Frappe"
config.font = font
config.font_size = 14
config.window_decorations = "RESIZE"
config.window_padding = {
	top = 20,
	right = 20,
	bottom = 0,
	left = 20,
}

config.colors = {
	split = "black",
	background = "#2b2f3f",
}
config.inactive_pane_hsb = {
	saturation = 1.0,
	brightness = 1.3,
}

-- KEY BINDS
-- config.disable_default_key_bindings = true
config.leader = { key = "Space", mods = "ALT", timeout_milliseconds = 2000 }
config.keys = {
	{ mods = "SUPER", key = "q", action = act.QuitApplication },
	{ mods = "SUPER", key = "c", action = act.CopyTo("Clipboard") },
	{ mods = "SUPER", key = "v", action = act.PasteFrom("Clipboard") },
	{ mods = "LEADER|ALT", key = "w", action = act.CloseCurrentPane({ confirm = true }) },

	{ mods = "LEADER|ALT", key = "/", action = act.QuickSelect },

	-- Panes
	{ mods = "ALT", key = "l", action = act.ActivatePaneDirection("Right") },
	{ mods = "ALT", key = "k", action = act.ActivatePaneDirection("Up") },
	{ mods = "ALT", key = "j", action = act.ActivatePaneDirection("Down") },
	{ mods = "ALT", key = "h", action = act.ActivatePaneDirection("Left") },
	{ mods = "LEADER|ALT", key = "l", action = act.SplitPane({ direction = "Right" }) },
	{ mods = "LEADER|ALT", key = "k", action = act.SplitPane({ direction = "Up" }) },
	{ mods = "LEADER|ALT", key = "j", action = act.SplitPane({ direction = "Down" }) },
	{ mods = "LEADER|ALT", key = "h", action = act.SplitPane({ direction = "Left" }) },

	{ mods = "ALT", key = "z", action = act.TogglePaneZoomState },

	-- Resize panes
	-- { mods = "", key = "", action = act. },
	-- { mods = "", key = "", action = act. },
	-- { mods = "", key = "", action = act. },
	-- { mods = "", key = "", action = act. },
	-- { mods = "", key = "", action = act. },

	-- Tabs
	{ mods = "LEADER|ALT", key = "n", action = act.SpawnCommandInNewTab({ cwd = "$HOME" }) },
	{ mods = "ALT|SHIFT", key = "l", action = act.ActivateTabRelative(1) },
	{ mods = "ALT|SHIFT", key = "h", action = act.ActivateTabRelative(-1) },
}

wezterm.on("window-config-reloaded", function(window, pane)
	window:toast_notification("WezTerm", "configuration reloaded!", nil, 1000)
end)

return config
