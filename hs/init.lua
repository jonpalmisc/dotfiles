--===-- init.lua: Hammerspoon configuration ------------------------------------

local key = hs.hotkey
local app = hs.application

local kbd = {}
kbd.type = hs.eventtap.keyStrokes

local pboard = {}
pboard.content = hs.pasteboard.getContents

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

--===-- Bindings ---------------------------------------------------------------

local cmd_alt = { "cmd", "alt" }

key.bind(cmd_alt, "`", focus_terminal)
key.bind(cmd_alt, "e", focus_editor)
key.bind(cmd_alt, "w", focus_browser)
key.bind(cmd_alt, "v", plaintext_paste)
