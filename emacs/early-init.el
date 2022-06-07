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

;; Increase process throughput for better performance with LSP, etc.
(setq read-process-output-max (* 1024 1024))

;; Disable package.el entirely (and at startup) since straight.el will
;; be used for package management instead.
(setq package-enable-at-startup nil
      site-run-file nil)

;; Disable all window chrome, etc. and configure the default window
;; dimensions. Configuring these options here yields better startup
;; time than performing the same configuration in init.el.
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(push '(width . 100) default-frame-alist)
(push '(height . 64) default-frame-alist)

(setq frame-inhibit-implied-resize t)
(setq frame-resize-pixelwise t)

;; Loading modes for the scratch buffer can increase startup time.
(setq initial-major-mode 'fundamental-mode
      initial-scratch-message nil)

;; Disable special file handlers at startup for better performance.
(defvar jp/file-name-handler-alist-backup file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Restore special file handlers after startup is complete.
(add-hook 'emacs-startup-hook
  (lambda ()
    (setq file-name-handler-alist jp/file-name-handler-alist-backup)))
