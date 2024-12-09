local log = hs.logger.new("kitlog", "debug")
log.i("Initializing")

-- Reload HS config
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "r", function()
	hs.reload()
end)

-- Show/hide terminal
hs.hotkey.bind({ "cmd", "shift" }, "l", function()
	kitty = hs.application.find("kitty", true)
	frontmost = hs.application.frontmostApplication()

	if kitty then
		if frontmost:bundleID() == kitty:bundleID() then
			kitty:hide()
		else
			kitty:activate()
		end
	else
		hs.application.launchOrFocus("kitty")
	end
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "Up", function()
	hs.alert.show("Up")
	frontmost = hs.application.frontmostApplication()
	window = frontmost.focusedWindow()
end)
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "Down", function()
	hs.alert.show("Down")
end)
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "Left", function()
	hs.alert.show("Left")
end)
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "Right", function()
	hs.alert.show("Right")
end)
