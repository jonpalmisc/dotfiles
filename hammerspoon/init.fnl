(local key-bind hs.hotkey.bind)
(local app-open hs.application.open)
(local pasteboard-content hs.pasteboard.getContents)
(local event-type hs.eventtap.keyStrokes)

;; -----------------------------------------------------------------------------

(local terminal-app-bundle-id "com.apple.terminal")
(local editor-app-bundle-id "org.gnu.Emacs")
(local browser-app-bundle-id "com.apple.Safari")

(fn focus-terminal []
  "Open the configured terminal application or focus it if already running."
  (app-open terminal-app-bundle-id))

(fn focus-editor []
  "Open the configured editor application or focus it if already running."
  (app-open editor-app-bundle-id))

(fn focus-browser []
  "Open the configured web browser or focus it if already running."
  (app-open browser-app-bundle-id))

(fn type-clipboard []
  "Type the contents of the clipboard, simulating a paste operation."
  (event-type (pasteboard-content)))

(key-bind [:cmd :alt] "`" #(focus-terminal))
(key-bind [:cmd :alt] "e" #(focus-editor))
(key-bind [:cmd :alt] "w" #(focus-browser))
(key-bind [:cmd :alt] "v" #(type-clipboard))
