--===-- init.lua: Hammerspoon configuration ------------------------------------

local key = hs.hotkey
local app = hs.application

local kbd = {}
kbd.type = hs.eventtap.keyStrokes

local pboard = {}
pboard.content = hs.pasteboard.getContents

local window = {}
window.active = hs.window.focusedWindow
window.resize = function(win, x, y, w, h)
	local f = win:frame()

	f.x = x
	f.y = y
	f.w = w
	f.h = h

	win:setFrame(f, 0)
end

--===-- Options ----------------------------------------------------------------

local terminal_app_id = "com.apple.Terminal"
local editor_app_id = "org.gnu.Emacs"
local browser_app_id = "com.apple.Safari"

--===-- Functions --------------------------------------------------------------

--- Open (or focus) the configured terminal emulator.
function focus_terminal()
	app.open(terminal_app_id)
end

--- Open (or focus) the configured text editor.
function focus_editor()
	app.open(editor_app_id)
end

--- Open (or focus) the configured web browser.
function focus_browser()
	app.open(browser_app_id)
end

--- Paste (auto-type) the contents of the clipboard as plaintext.
function plaintext_paste()
	kbd_type(clipboard_content())
end

--- Snap a window using a ratio of the available screen space.
function snap_ratio(xr, yr, wr, hr)
	local win = window.active()
	local screen = win:screen():frame()

	window.resize(win, screen.w * xr, screen.h * yr, screen.w * wr, screen.h * hr)
end

--===-- Bindings ---------------------------------------------------------------

local cmd_alt = { "cmd", "alt" }

key.bind(cmd_alt, "`", focus_terminal)
key.bind(cmd_alt, "e", focus_editor)
key.bind(cmd_alt, "w", focus_browser)
key.bind(cmd_alt, "v", plaintext_paste)

local ctrl_alt = { "ctrl", "alt" }

-- Snap to the upper left quadrant of the screen.
key.bind(ctrl_alt, "o", function()
	snap_ratio(0, 0, 0.5, 0.5)
end)

-- Snap to the upper right quadrant of the screen.
key.bind(ctrl_alt, "p", function()
	snap_ratio(0.5, 0, 0.5, 0.5)
end)

-- Snap to the bottom left quadrant of the screen.
key.bind(ctrl_alt, "k", function()
	snap_ratio(0, 0.5, 0.5, 0.5)
end)

-- Snap to the bottom right quadrant of the screen.
key.bind(ctrl_alt, "l", function()
	snap_ratio(0.5, 0.5, 0.5, 0.5)
end)

-- Snap to the left half of the screen.
key.bind(ctrl_alt, "[", function()
	snap_ratio(0, 0, 0.5, 1)
end)

-- Snap to the right half of the screen.
key.bind(ctrl_alt, "]", function()
	snap_ratio(0.5, 0, 0.5, 1)
end)
