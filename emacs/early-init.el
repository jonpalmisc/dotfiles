;;; --- early-init.el -------------------- -*- lexical-binding: t; -*-

;; Since we are using `straight.el' for package management, avoid
;; needlessly loading `package.el' and slowing down startup.
(setq package-enable-at-startup nil)

(defun jp/gc-raise ()
  "Raise garbage collection thresholds to limit pauses."
  (setq gc-cons-threshold most-positive-fixnum
	gc-cons-percentage 1.0))

(defun jp/gc-restore ()
  "Restore garbage collection settings to reasonable runtime values."
  (setq gc-cons-threshold (* 128 1024 1024)
        gc-cons-percentage 0.2))

(defun jp/gc-restore-deferred ()
  "Restore GC settings, with a delay."
  (run-at-time 1 nil #'jp/gc-restore))

;; Disable garbage collection at startup.
(jp/gc-raise)

;; Put custom stuff in separate file.
(setopt custom-file (locate-user-emacs-file "custom.el"))


;;; --- Performance --------------------------------------------------


;; Suppress modeline and redisplay during startup to avoid unnecessary
;; renders; both are restored on the first user interaction.
(put 'mode-line-format 'initial-value (default-value 'mode-line-format))
(setq-default mode-line-format nil)
(setq inhibit-redisplay t
      inhibit-message t)

(defun jp/restore-startup-inhibits ()
  (setq-default mode-line-format (get 'mode-line-format 'initial-value))
  (setq inhibit-redisplay nil
	inhibit-message nil)
  (redisplay)
  (remove-hook 'post-command-hook #'jp/restore-startup-inhibits))

(add-hook 'post-command-hook #'jp/restore-startup-inhibits)

;; Don't warn when visiting a file already open in another buffer.
(setopt find-file-suppress-same-file-warnings t)

;; Don't try to ping domain-like path segments as hostnames.
(setopt ffap-machine-p-known 'accept)

;; Skip case-insensitive second pass over 'auto-mode-alist'.
(setopt auto-mode-case-fold nil)

;; Disable special file handlers temporarily.
(defvar jp/file-name-handler-alist-backup file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Restore special file handlers after startup is complete.
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq file-name-handler-alist jp/file-name-handler-alist-backup)))

;; Disable bidirectional text support.
(setq bidi-inhibit-bpa t)
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)

;; Increase output buffer for subprocesses; important for LSP.
(setq read-process-output-max (* 4 1024 1024))

;; Keep read buffer sizes stable; shrinking on idle hurts throughput.
(setq process-adaptive-read-buffering nil)

;; Don't compact font caches.
(setq inhibit-compacting-font-caches t)

;; Don't fontify while input is pending.
(setq redisplay-skip-fontification-on-input t)

;; Allegedly saves rendering time.
(setopt cursor-in-non-selected-windows nil)
(setopt highlight-nonselected-windows nil)


;;; --- Native & byte compilation ------------------------------------


;; Prefer loading newer files over older, byte-compiled ones.
;;
;; This is particularly important when iterating on a config.
(setq load-prefer-newer t)

;; Silence annoying and confusing bytecode warnings.
(setopt byte-compile-warnings '(not obsolete)
	warning-suppress-log-types '((comp) (bytecomp))
	native-comp-async-report-warnings-errors 'silent)


;;; --- Early UI tweaks ----------------------------------------------


;; Disable toolbar & menubar; configure the default window size.
;;
;; Configuring these options here yields better startup time than
;; performing the same configuration in 'init.el'.
(setopt default-frame-alist
	'((menu-bar-lines . 0)
	  (tool-bar-lines . 0)
	  (ns-transparent-titlebar . t)
	  (vertical-scroll-bars . nil)
	  (width . 104)
	  (height . 64)
	  (font . "MD IO Medium")))

;; Use a bit more line height in GUI Emacs.
(setopt line-spacing 0.1)

;; Allow window sizes that aren't perfect multiples of the grid cell
;; dimensions. Without this, macOS window snapping behaves weirdly.
;;
;; Also a startup performance improvement as resizing the frame (due
;; to font change) can be costly without these options.
(setopt frame-resize-pixelwise t
	frame-inhibit-implied-resize t)

;; Set the scratch buffer to fundamental mode for faster startup time
;; and remove the initial content.
(setopt initial-major-mode 'fundamental-mode
	initial-scratch-message nil)

;; Silence startup messages.
(setopt inhibit-startup-message t
	inhibit-startup-echo-area-message (user-login-name))
