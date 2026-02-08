local log = hs.logger.new("kitlog", "debug")
log.i("Initializing")

-- -- ~Reload HS config~ (not needed, just open it and click reload)
-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "r", function()
-- 	hs.reload()
-- end)

hs.hotkey.bind({ "cmd", "shift" }, "l", function()
	local wezterm = hs.application.find("WezTerm", true)
	if wezterm then
		if wezterm and wezterm:isFrontmost() then
			wezterm:hide()
		else
			wezterm:activate()
		end
	else
		hs.application.launchOrFocus("WezTerm")
	end
end)

-- Show/hide terminal
-- hs.hotkey.bind({ "cmd", "shift" }, "k", function()
-- 	local kitty = hs.application.find("kitty", true)
-- 	if kitty then
-- 		if kitty and kitty:isFrontmost() then
-- 			kitty:hide()
-- 		else
-- 			kitty:activate()
-- 		end
-- 	else
-- 		hs.application.launchOrFocus("kitty")
-- 	end
-- end)

-- Show/hide Ghosttty
hs.hotkey.bind({ "cmd", "shift" }, "h", function()
	local ghostty = hs.application.find("Ghostty", true)
	if ghostty then
		if ghostty and ghostty:isFrontmost() then
			ghostty:hide()
		else
			ghostty:activate()
		end
	else
		hs.application.launchOrFocus("Ghostty")
	end
end)

-- -- Window Mgmt (wip)
-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "Up", function()
-- 	hs.alert.show("Up")
-- 	local frontmost = hs.application.frontmostApplication()
-- 	frontmost.focusedWindow()
-- end)
-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "Down", function()
-- 	hs.alert.show("Down")
-- end)
-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "Left", function()
-- 	hs.alert.show("Left")
-- end)
-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "Right", function()
-- 	hs.alert.show("Right")
-- end)
