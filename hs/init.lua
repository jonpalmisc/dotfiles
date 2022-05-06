--===-- init.lua: Hammerspoon configuration ------------------------------------

local terminalAppId = "com.apple.Terminal"
local editorAppId = "com.sublimetext.4"
local browserAppId = "com.apple.Safari"
local passwordsAppId = "com.markmcguill.strongbox.mac"

hs.window.animationDuration = 0 -- Disable window adjustment animations
hs.grid.setMargins "0,0" -- Remove margins between windows
hs.grid.setGrid "2x2" -- Use a 2x2 (4 quadrant) grid for window positioning

--===-- Functions --------------------------------------------------------------

--- Open (or focus) the configured terminal emulator.
function focusTerminal()
	hs.application.open(terminalAppId)
end

--- Open (or focus) the configured text editor.
function focusEditor()
	hs.application.open(editorAppId)
end

--- Open (or focus) the configured web browser.
function focusBrowser()
	hs.application.open(browserAppId)
end

--- Open (or focus) the configured password manager.
function focusPasswords()
	hs.application.open(passwordsAppId)
end

--- Paste (auto-type) the contents of the clipboard as plaintext.
function plaintextPaste()
	hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end

--- Snap a window to a grid cell.
function gridSnap(cell)
	hs.grid.set(hs.window.focusedWindow(), cell)
end

--===-- Bindings ---------------------------------------------------------------

local cmdAlt = { "cmd", "alt" }

hs.hotkey.bind(cmdAlt, "`", focusTerminal)
hs.hotkey.bind(cmdAlt, "e", focusEditor)
hs.hotkey.bind(cmdAlt, "w", focusBrowser)
hs.hotkey.bind(cmdAlt, "m", focusPasswords)
hs.hotkey.bind(cmdAlt, "v", plaintextPaste)

-- Snap the focused window to the upper left quadrant of the screen.
hs.hotkey.bind(cmdAlt, "o", function()
	gridSnap "0,0 1x1"
end)

-- Snap the focused window to the upper right quadrant of the screen.
hs.hotkey.bind(cmdAlt, "p", function()
	gridSnap "1,0 1x1"
end)

-- Snap the focused window to the bottom left quadrant of the screen.
hs.hotkey.bind(cmdAlt, "k", function()
	gridSnap "0,1 1x1"
end)

-- Snap the focused window to the bottom right quadrant of the screen.
hs.hotkey.bind(cmdAlt, "l", function()
	gridSnap "1,1 1x1"
end)

-- Snap the focused window to the left half of the screen.
hs.hotkey.bind(cmdAlt, "[", function()
	gridSnap "0,0 1x2"
end)

-- Snap the focused window to the right half of the screen.
hs.hotkey.bind(cmdAlt, "]", function()
	gridSnap "1,0 1x2"
end)

-- Snap the focused window to fill the screen.
hs.hotkey.bind(cmdAlt, "=", function()
	gridSnap "0,0 2x2"
end)

-- Move the focused window to the previous display.
hs.hotkey.bind(cmdAlt, ";", function()
	hs.window.focusedWindow():moveOneScreenWest()
end)

-- Move the focused window to the next display.
hs.hotkey.bind(cmdAlt, "'", function()
	hs.window.focusedWindow():moveOneScreenEast()
end)
