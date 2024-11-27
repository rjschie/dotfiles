hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "r", function()
	hs.reload()
end)

local log = hs.logger.new("kitlog", "debug")
log.i("Initializing")

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
