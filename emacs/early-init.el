;;; --- early-init.el -------------------- -*- lexical-binding: t; -*-


(defun jp/gc-raise ()
  "Raise garbage collection thresholds to limit pauses."
  (setq gc-cons-threshold most-positive-fixnum
	gc-cons-percentage 0.6))

(defun jp/gc-restore ()
  "Restore garbage collection settings to reasonable runtime values."
  (setq gc-cons-threshold (* 32 1024 1024)
        gc-cons-percentage 0.1))

(defun jp/gc-restore-deferred ()
  "Restore GC settings, with a delay."
  (run-at-time 1 nil #'jp/gc-restore))

;; Disable garbage collection at startup.
(jp/gc-raise)

;; Put custom stuff in separate file.
(setq custom-file (locate-user-emacs-file "custom.el"))

;; Prefer loading newer files over older, byte-compiled ones.
;;
;; This is particularly important when iterating on a config.
(setq load-prefer-newer t)

;; Silence annoying and confusing bytecode warnings.
(setopt byte-compile-warnings '(not obsolete)
	warning-suppress-log-types '((comp) (bytecomp))
	native-comp-async-report-warnings-errors 'silent)

;; Disable toolbar & menubar; configure the default window size.
;;
;; Configuring these options here yields better startup time than
;; performing the same configuration in 'init.el'.
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(ns-transparent-titlebar . t) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(push '(width . 100) default-frame-alist)
(push '(height . 64) default-frame-alist)

;; Allow window sizes that aren't perfect multiples of the grid cell
;; dimensions. Without this, macOS window snapping behaves weirdly.
(setopt frame-resize-pixelwise t
	frame-inhibit-implied-resize t)

;; Set the scratch buffer to fundamental mode for faster startup time
;; and remove the initial content.
(setopt initial-major-mode 'fundamental-mode
	initial-scratch-message nil)

;; Disable special file handlers at startup for better performance.
(defvar jp/file-name-handler-alist-backup file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Silence startup messages.
(setopt inhibit-startup-message t
	inhibit-startup-echo-area-message (user-login-name))

;; Restore special file handlers after startup is complete.
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq file-name-handler-alist jp/file-name-handler-alist-backup)))
