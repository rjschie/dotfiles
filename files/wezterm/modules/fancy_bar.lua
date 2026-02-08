local wezterm = require("wezterm")

local module = {}

local bg = "#232634"
local primary_button_bg = "hsl(316deg, 73%, 84%)"
local primary_button_fg = "black"

local button_bg = "hsl(227deg, 17%, 48%)"
local button_fg = "hsl(227deg, 70%, 90%)"
local button_hover_bg = "hsl(316deg, 63%, 89%)"
local button_hover_fg = "black"

local separator = "hsl(227deg, 17%, 28%)"

local tab = function(is_active)
	local rounding = 20
	local x = 12
	local y = 3
	return {
		bg_color = is_active and primary_button_bg or button_bg,
		fg_color = is_active and primary_button_fg or button_fg,
		hover_bg_color = is_active and primary_button_bg or button_hover_bg,
		hover_fg_color = is_active and primary_button_fg or button_hover_fg,
		margin = { left = 0, right = 0 },
		padding = { top = y, bottom = y, left = x, right = x },
		rounding = { top_left = rounding, top_right = rounding, bottom_right = rounding, bottom_left = rounding },
		-- border = { top = 0, left = 0, right = 0, bottom = 0 },
		-- border_color = { top = border, left = border, right = border, bottom = border },
	}
end

function module.build_fancy_bar(config)
	config.fancy_bar = {
		font = wezterm.font("Roboto"),
		font_size = 12,

		tab_placement = "right",
		tab_min_width = 150,
		tab_max_width = 350,
		tab_text_align = "center",

		-- Container
		background = bg,
		inactive_background = bg,
		padding = { top = 5, bottom = 5, left = 5, right = 5 },

		use_full_width = false,

		-- Tabs:
		active_tab = tab(true),
		inactive_tab = tab(false),

		tab_separator = {
			thickness = 1,
			color = separator,
			margin = { left = 7, right = 7 },
		},

		-- Buttons:
		active_close_tab_button = {
			bg_color = primary_button_bg,
			fg_color = primary_button_fg,
			hover_bg_color = button_hover_bg,
			hover_fg_color = button_hover_fg,
			text = wezterm.nerdfonts.close,
			padding = { left = 5, right = 5, top = 5, bottom = 5 },
			rounding = { top_left = 20, top_right = 20, bottom_left = 20, bottom_right = 20 },
			margin = { left = 0, right = 0 },
		},
		inactive_close_tab_button = {
			bg_color = button_bg,
			fg_color = button_fg,
			hover_bg_color = button_hover_bg,
			hover_fg_color = button_hover_fg,
			text = wezterm.nerdfonts.close,
			padding = { left = 5, right = 5, top = 5, bottom = 5 },
			rounding = { top_left = 20, top_right = 20, bottom_left = 20, bottom_right = 20 },
			margin = { left = 0, right = 0 },
		},

		new_tab_button = {
			bg_color = bg,
			fg_color = "white",
			hover_bg_color = primary_button_bg,
			hover_fg_color = primary_button_fg,
			text = wezterm.nerdfonts.plus,
			font_size = 19,
			padding = { left = 5, right = 5, top = 5, bottom = 5 },
			rounding = { top_left = 10, top_right = 10, bottom_left = 10, bottom_right = 10 },
			margin = { left = 5, right = 0 },
		},
	}
end

return module
