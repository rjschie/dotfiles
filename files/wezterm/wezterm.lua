local wezterm = require("wezterm") ---@type Wezterm
local config = wezterm.config_builder() ---@type Config
local act = wezterm.action
local font = wezterm.font("FiraMono Nerd Font Mono")

config.macos_hide_from_tasks = true
config.notification_handling = "SuppressFromFocusedPane"
config.prefer_to_spawn_tabs = true
config.warn_about_missing_glyphs = false

-- State/Size
config.remember_window_state = true
config.remember_window_position = true
config.use_resize_increments = true

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

function reset_panes(active_pane)
	local tab = active_pane:tab()
	local active_pane_id = active_pane:pane_id()

	for i, info in ipairs(tab:panes_with_info()) do
		if info.pane:pane_id() ~= active_pane_id then
			tab:kill_pane(info.pane)
		end
	end
end

function perform_layout(id, pane)
	reset_panes(pane)

	if id == 1 then
		pane:split({ direction = "Right" })
		pane:split({ direction = "Bottom" })
	elseif id == 2 then
		pane:split({ direction = "Right" })
		pane:split({ direction = "Bottom" }):split({ direction = "Bottom" })
	end

	pane:activate()
end

function SetLayout(layout_id)
	local layout = layout_id or 1
	return wezterm.action_callback(function(window)
		local pane = window:active_pane()
		perform_layout(layout, pane)
	end)
end

-- KEY BINDS
config.disable_default_key_bindings = true
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

	{ mods = "CTRL|SHIFT", key = "=", action = act.EqualizePanes },
	{ mods = "ALT", key = "z", action = act.TogglePaneZoomState },

	-- Resize panes
	{ mods = "CTRL|SUPER", key = "l", action = act.AdjustPaneSize({ "Right", 2 }) },
	{ mods = "CTRL|SUPER", key = "h", action = act.AdjustPaneSize({ "Left", 2 }) },
	{ mods = "CTRL|SUPER", key = "k", action = act.AdjustPaneSize({ "Up", 2 }) },
	{ mods = "CTRL|SUPER", key = "j", action = act.AdjustPaneSize({ "Down", 2 }) },

	-- Tabs
	{
		mods = "LEADER|ALT",
		key = "n",
		action = act.SpawnCommandInNewTab({ cwd = "$HOME" }),
	},

	-- Copy Tab & Set Layout to 1
	{
		mods = "LEADER|ALT",
		key = "c",
		action = wezterm.action_callback(function(window, pane)
			local layout_id = 1
			local tab = pane:tab()
			local title = tab:get_title()

			local cwd = pane:get_current_working_dir()
			local cwd_str = cwd and cwd.file_path or nil

			window:perform_action(
				act.Multiple({
					act.SpawnCommandInNewTab({ tab_position = "+1", cwd = cwd_str }),
					SetLayout(layout_id),
				}),
				pane
			)

			local new_tab = window:mux_window():active_tab()
			new_tab:set_title(title)
		end),
	},

	{ mods = "ALT|SHIFT", key = "l", action = act.ActivateTabRelative(1) },
	{ mods = "ALT|SHIFT", key = "h", action = act.ActivateTabRelative(-1) },

	-- Windows
	{ mods = "LEADER|ALT|CTRL", key = "`", action = act.ActivateWindowRelative(1) },
	{ mods = "ALT", key = "`", action = act.ActivateWindowRelative(1) },

	-- Scrolling
	{ mods = "ALT|CTRL", key = "k", action = act.ScrollByLine(-5) },
	{ mods = "ALT|CTRL", key = "j", action = act.ScrollByLine(5) },

	-- Misc
	{ mods = "SHIFT", key = "Enter", action = act.SendString("\n") },
	{ mods = "LEADER|ALT", key = "s", action = act.ToggleSynchronizePanes },

	-- Key Tables
	{
		key = "Space",
		mods = "ALT|SHIFT",
		action = act.ActivateKeyTable({
			name = "shift_leader",
			one_shot = true,
			timeout_milliseconds = 2000,
		}),
	},
	{
		key = "Space",
		mods = "ALT|CTRL",
		action = act.ActivateKeyTable({
			name = "ctrl_leader",
			one_shot = true,
			timeout_milliseconds = 2000,
		}),
	},
}

config.key_tables = {
	ctrl_leader = {
		{
			-- New Window w/ no layout
			mods = "ALT|CTRL",
			key = "n",
			action = wezterm.action_callback(function(window, pane)
				local new_tab, new_pane = wezterm.mux.spawn_window({ cwd = "$HOME" })
			end),
		},
		{
			-- Copy Pane to new Window w/ Layout 1
			mods = "ALT|CTRL",
			key = "c",
			action = wezterm.action_callback(function(window, pane)
				local curr_tab = pane:tab()
				local title = curr_tab:get_title()

				local cwd = pane:get_current_working_dir()
				local cwd_str = cwd and cwd.file_path or nil

				local new_tab, new_pane = wezterm.mux.spawn_window({ cwd = cwd_str })
				new_tab:set_title(title)
				perform_layout(1, new_pane)
			end),
		},
	},
	shift_leader = {
		{ mods = "ALT|SHIFT", key = "~", action = act.ShowDebugOverlay },

		{ mods = "ALT|SHIFT", key = "w", action = act.CloseCurrentTab({ confirm = true }) },
		{ mods = "ALT|SHIFT", key = "n", action = act.SpawnCommandInNewTab({ tab_position = "+1", cwd = "$HOME" }) },

		-- Movement
		{ mods = "ALT|SHIFT", key = "{", action = act.MoveTabRelative(-1) },
		{ mods = "ALT|SHIFT", key = "}", action = act.MoveTabRelative(1) },

		-- Layouts
		{
			-- 0 layout
			mods = "ALT|SHIFT",
			key = ")", -- 0
			action = wezterm.action_callback(function(window, pane)
				reset_panes(pane)
			end),
		},
		{
			-- 1 layout
			mods = "ALT|SHIFT",
			key = "!", -- 1
			action = SetLayout(1),
		},
		{
			-- 2 layout
			mods = "ALT|SHIFT",
			key = "@", -- 2
			action = SetLayout(2),
		},
	},
}

wezterm.on("window-config-reloaded", function(window, pane)
	window:toast_notification("WezTerm", "configuration reloaded!", nil, 1000)
end)

return config
