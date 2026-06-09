-- =====================
-- MONITOR CONFIGURATION
-- =====================
-- Use preferred resolution, auto position, auto scale
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

-- =====================
-- AUTOSTART
-- =====================
-- Launch status bar on session start
hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
end)

-- =====================
-- MAIN MODIFIER KEY
-- =====================
local mainMod = "SUPER"

-- =====================
-- INPUT
-- =====================
hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "altgr-intl",
		follow_mouse = 1,
	},

	-- =====================
	-- GENERAL
	-- =====================
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		layout = "dwindle",
	},

	-- =====================
	-- DECORATION
	-- =====================
	decoration = {
		rounding = 8,
	},
})

-- =====================
-- MOUSE BINDS
-- =====================
-- Hold SUPER + left click to drag floating windows
-- Hold SUPER + right click to resize floating windows
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- =====================
-- KEYBINDS
-- =====================

-- Terminal
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty"))

-- File explorer
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))

-- Close active window
hl.bind(mainMod .. " + C", hl.dsp.window.close())

-- Exit Hyprland
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch exit"))

-- App launcher
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("wofi --show drun"))

-- Toggle floating
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Toggle fullscreen
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

-- =====================
-- FOCUS MOVEMENT
-- =====================
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- =====================
-- WORKSPACE SWITCHING
-- =====================
for i = 1, 5 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end

-- =====================
-- MOVE WINDOW TO WORKSPACE
-- =====================
for i = 1, 3 do
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- =====================
-- MEDIA KEYS (volume)
-- =====================
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)

hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- =====================
-- MEDIA KEYS (brightness)
-- =====================
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

-- =====================
-- SCREENSHOTS
-- =====================
-- Region screenshot (copy to clipboard)
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

-- Full screenshot (save to file)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"))

-- =====================
-- MOVE WINDOWS WITHIN WORKSPACE
-- =====================
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- =====================
-- SWAP WORKSPACES
-- =====================
-- Swaps all windows between the active workspace and a target workspace.
-- Usage: SUPER + CTRL + [1-5] swaps current workspace with that number.
local function swap_workspaces(target)
	local active_ws = hl.get_active_workspace()
	if active_ws == nil then
		return
	end
	local active_id = active_ws.id

	-- Don't swap with itself
	if active_id == target then
		return
	end

	-- Get all windows and move them between workspaces
	local windows = hl.get_windows()
	for _, w in ipairs(windows) do
		if w.workspace ~= nil then
			if w.workspace.id == active_id then
				hl.dispatch(hl.dsp.window.move({ workspace = target, window = w }))
			elseif w.workspace.id == target then
				hl.dispatch(hl.dsp.window.move({ workspace = active_id, window = w }))
			end
		end
	end

	-- Follow focus to the target workspace
	hl.dispatch(hl.dsp.focus({ workspace = target }))
end

for i = 1, 5 do
	hl.bind(mainMod .. " + CTRL + " .. i, function()
		swap_workspaces(i)
	end)
end

-- =====================
-- MOVE WORKSPACE TO MONITOR
-- =====================
-- Move the current workspace to the next/previous monitor
-- (requires multi-monitor setup)
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.exec_cmd("hyprctl dispatch moveworkspacetomonitor e+0 +1"))
hl.bind(mainMod .. " + SHIFT + bracketleft", hl.dsp.exec_cmd("hyprctl dispatch moveworkspacetomonitor e+0 -1"))

-- =====================
-- MOVE FLOATING WINDOWS
-- =====================
-- Move floating window pixel by pixel with SUPER + ALT + arrows
hl.bind(
	mainMod .. " + ALT + left",
	hl.dsp.exec_cmd("hyprctl dispatch movewindowpixel -20 0,floating"),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + ALT + right",
	hl.dsp.exec_cmd("hyprctl dispatch movewindowpixel 20 0,floating"),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + ALT + up",
	hl.dsp.exec_cmd("hyprctl dispatch movewindowpixel 0 -20,floating"),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + ALT + down",
	hl.dsp.exec_cmd("hyprctl dispatch movewindowpixel 0 20,floating"),
	{ repeating = true }
)

-- =====================
-- RESIZE WINDOWS
-- =====================
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

-- =====================
-- MEDIA PLAYBACK CONTROL
-- =====================
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- =====================
-- SHOW DESKTOP / LOCK / SUSPEND
-- =====================
-- Show desktop script
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("/home/manuelmanriquez/.config/hypr/scripts/show-desktop.sh"))

-- Lock screen
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- Suspend system
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend"))
