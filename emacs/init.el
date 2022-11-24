;;; --- init.el -------------------------- -*- lexical-binding: t; -*-


;; Raising the garbage collection threshold while the minibuffer is
;; open can make the minibuffer more performant and less freeze-prone.
(add-hook 'minibuffer-setup-hook #'jp/gc-raise)
(add-hook 'minibuffer-exit-hook #'jp/gc-restore-deferred)

;; Some packages/functions have annoying and not-very-helpful messages
;; that pollute the minibuffer. These messages can be easily silenced
;; by wrapping the problem function with this one using `advice-add'.
(defun jp/silence-mb (f &rest args)
  "Run a function and suppress its minibuffer output."
  (let ((inhibit-message t))
    (apply f args)))

;; Free dopamine if this number is under 0.25 seconds.
(defun jp/show-startup-stats ()
  "Show initialization duration in the minibuffer after startup."
  (message
   "Emacs started in %s seconds"
   (format "%.2f" (float-time
                   (time-subtract after-init-time before-init-time)))))

;; Show total startup time once Emacs has finished loading.
(add-hook 'emacs-startup-hook #'jp/show-startup-stats)

;; Hide the default startup message.
(setq inhibit-startup-message t)

;; Instruct the customize system to use a different file for storing
;; customized settings, then load that file. By default, init.el (this
;; file) will be used, which is not only annoying but results in
;; frequent, useless changes which dirty the Git state.
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))


;;;
;;; --- Environment Configuration ------------------------------------
;;;


;; This is the bulk of the work done by `jp/load-env-file'. It has
;; been extracted into a separate function for readability.
(defun jp/process-env-buffer ()
  "Load environment variables from the current buffer."
  (when-let (env (read (current-buffer)))
    ;; Populate standard environment variables from the file.
    (setq-default process-environment
                  (append env (default-value 'process-environment)))

    ;; Configure `exec-path' from the `PATH' environment variable.
    (setq-default exec-path
                  (append (split-string (getenv "PATH") path-separator t)
                          (list exec-directory)))

    ;; Set the preferred terminal shell using the `SHELL' variable.
    (setq-default shell-file-name
                  (or (getenv "SHELL")
                      (default-value 'shell-file-name)))))

(defun jp/load-env-file (file)
  "Load serialized environment variables at FILE (if it exists)."
  (if (null (file-exists-p file))
      (message "No environment variable file found at " file)
    (with-temp-buffer
      (insert-file-contents file)
      (jp/process-env-buffer))))

;; It is VERY important that the environment is configured before
;; straight (or any external package) is loaded, otherwise GCC JIT
;; might not work correctly if Emacs cannot find the appropriate
;; libraries in the environment on macOS.
(jp/load-env-file (concat user-emacs-directory "env.el"))


;;;
;;; --- Package Management -------------------------------------------
;;;


;; By default, `straight.el' likes to check for modifications to
;; packages at startup, which comes at the cost of startup time. This
;; tweak inhibits this behavior, opting to only check for changes when
;; package files are edited and saved from inside Emacs.
(setq straight-check-for-modifications
      '(check-on-save find-when-checking))

;; Load `straight.el' (or download and load if not installed).
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         user-emacs-directory))
      (bootstrap-version 5))

  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Get `use-package' for easier package management/configuration and
;; configure `use-package' to always use build packages from source
;; using `straight.el'.
(straight-use-package 'use-package)
(use-package straight
  :custom (straight-use-package-by-default t))

;; Instruct `use-package' to always install all declared packages.
(setq use-package-always-ensure t)


;;;
;;; --- Editor Setup -------------------------------------------------
;;;


(setq make-backup-files nil)        ; Freedom from tilde-hell
(setq create-lockfiles nil)         ; Don't create lock files
(setq-default truncate-lines t)     ; Truncate long lines (don't wrap)
(setq ring-bell-function 'ignore)   ; Disable flashing bell

(global-auto-revert-mode)           ; Reload files from disk on change
(electric-pair-mode 1)              ; Auto-close parentheses, etc.
(column-number-mode)                ; Show column numbers in mode line

(global-display-fill-column-indicator-mode) ; Show fill column ruler

(defun jp/set-fill-length-70 ()
  "Set the current buffer's fill length to 70 columns."
  (setq fill-column 70))

;; Wrap text to 80 columns by default, but use 70 columns for Elisp.
(setq-default fill-column 80)
(add-hook 'emacs-lisp-mode-hook #'jp/set-fill-length-70)

(setq sentence-end-double-space nil)      ; It is no longer the 1900s
(setq-default show-trailing-whitespace t) ; Show trailing spaces
(setq require-final-newline t)            ; End files with a newline

;; Remove trailing whitespace before saving buffers.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Emacs can be particularly stubborn about indentation. This is most
;; problematic (Objective-)C(++) modes; it is best to mimic the
;; existing indentation style which can be guessed from the buffer
;; using the `dtrt-indent' package.
(use-package dtrt-indent
  :commands (dtrt-indent-mode)
  :hook ((c-mode c++-mode objc-mode python-mode) . dtrt-indent-mode))


;;;
;;; --- Org ----------------------------------------------------------
;;;


(defun jp/org-babel-clear-results ()
  "Clear all result blocks in an Org buffer."
  (interactive)
  (org-babel-remove-result-one-or-many t))

(defun jp/config-org-appearance ()
  "Disable line numbers and fill indicator in Org buffers."
  (display-fill-column-indicator-mode -1)
  (display-line-numbers-mode -1))

;; Org likes to load lots of modules by default; startup time can be
;; significantly improved by not loading these. Org is also deferred
;; here to save even more time on startup since I use it infrequently.
(use-package org
  :defer
  :preface (defvar org-modules '())
  :custom (org-startup-indented t)
  :hook ((org-mode . turn-on-auto-fill)
         (org-mode . jp/config-org-appearance)))

(require 'ox-man)


;;;
;;; --- Language/Mode Support ----------------------------------------
;;;


(use-package cmake-mode
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

(use-package cmake-font-lock
  :hook (cmake-mode . cmake-font-lock-activate))

(use-package modern-cpp-font-lock
  :hook (c++-mode . modern-c++-font-lock-mode))

(use-package go-mode
  :mode ("\\.go\\'" . go-mode))

(use-package rust-mode
  :mode ("\\.rs\\'" . rust-mode)
  :hook (rust-mode . eglot-ensure))

(use-package zig-mode
  :mode ("\\.zig\\'" . zig-mode)
  :hook (zig-mode . eglot-ensure)
  :custom
  (zig-format-on-save nil)
  (zig-format-show-buffer nil))

(use-package lua-mode
  :mode ("\\.lua\\'" . lua-mode))

(use-package json-mode
  :mode ("\\.json\\'" . json-mode))

(use-package yaml-mode
  :mode ("\\.yml\\'" . yaml-mode))

;; Needed for indirect editing via `markdown-mode'
(use-package edit-indirect :defer)

(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode)
  :custom (markdown-command "multimarkdown"))

(use-package auctex
  :defer t
  :custom (TeX-engine 'luatex))

(use-package graphviz-dot-mode
  :defer
  :config
  (setq graphviz-dot-indent-width 4))


;;;
;;; --- IDE Features -------------------------------------------------
;;;

(use-package magit
  :commands magit-status
  :config

  ;; Some sections in Magit's status output are particularly expensive
  ;; to compute. Disabling them results in the status buffer opening
  ;; more quickly.
  (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
  (remove-hook 'magit-status-sections-hook 'magit-insert-merge-log)
  (remove-hook 'magit-status-sections-hook 'magit-insert-stashes)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)

  ;; Make all popup menus inside Magit's UI closable with ESC.
  (define-key transient-map [escape] #'transient-quit-one)

  :custom
  (magit-git-executable (executable-find "git"))

  ;; Don't auto-save repo buffers; this is unnecessary and auto-saving
  ;; can cause unwanted side effects.
  (magit-save-repository-buffers nil)

  ;; Hide related refs because they aren't particularly useful and
  ;; have a negative impact on performance.
  (magit-revision-insert-related-refs nil)

  ;; Magit likes to create splits for new windows by default; this is
  ;; annoying and not particularly useful. Instead, open new Magit
  ;; windows in the current window, replacing the current buffer.
  (magit-display-buffer-function
   'magit-display-buffer-same-window-except-diff-v1))

(use-package eglot
  :hook ((c-mode c++-mode objc-mode python-mode) . eglot-ensure)
  :custom
  (eglot-sync-connect nil)
  (eglot-highlight-symbol-face highlight)
  (eglot-ignored-server-capabilities '(:hoverProvider))
  :bind (("C-; r" . eglot-rename)
	 ("C-; a" . eglot-code-actions)))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-scroll-margin 2)

  :hook ((prog-mode . corfu-mode)))

;; Use `deadgrep' for awesome text search.
(use-package deadgrep
  :bind ("C-c C-f" . deadgrep))


;;;
;;; --- Keybindings --------------------------------------------------
;;;


(use-package bind-key
  :commands bind-key
  :config
  (bind-key "C-x C-b" 'switch-to-buffer)
  (bind-key "C-c C-e" 'eval-buffer)
  (bind-key "C-c r" 'replace-regexp)
  (bind-key "C-c o" 'overwrite-mode)

  (bind-key "C-x C-p" 'project-find-file)

  ;; Use familiar browser zoom hotkeys to increase/decrease text size.
  (bind-key "C-=" 'text-scale-increase)
  (bind-key "C--" 'text-scale-decrease))


;;;
;;; --- Interface ----------------------------------------------------
;;;


;; Vertico offers a "vertical completion" interface which makes
;; minibuffer completion in Emacs nicer and easier overall.
(use-package vertico
  :init (vertico-mode)

  ;; Show fewer completion results at a time to prevent the minibuffer
  ;; from occupying too much of the screen.
  :custom (vertico-count 6))

;; Orderless provides nice "multiple and fuzzy" completion that works
;; very well in conjunction with Vertico.
(use-package orderless
  :custom (completion-styles '(orderless)))

;; Configure UI font
(defun jp/config-mono-font ()
  "Set the default font if it is available."
  (setq jp/mono-font "Berkeley Mono Variable")
  (when (member jp/mono-font (font-family-list))
    (set-face-attribute 'default nil :font jp/mono-font)
    (set-face-attribute 'fixed-pitch nil :font jp/mono-font)))

(jp/config-mono-font)


;;;
;;; --- Personal -----------------------------------------------------
;;;


(defun jp/open-in-ns-terminal ()
  "Open the current working directory in Terminal on macOS."
  (interactive)
  (shell-command (concat "open -a Terminal " default-directory)))

(defun jp/open-in-ns-finder ()
  "Open the current working directory in Finder on macOS."
  (interactive)
  (shell-command (concat "open " default-directory)))

(setq jp/clang-format-styles
      '("Default" "LLVM" "Google" "Chromium" "Mozilla" "WebKit" "Microsoft" "GNU"))

(defun jp/clang-format ()
  "Format the current buffer in place using clang-format."
  (interactive)

  ;; Save a reference to the current buffer, as well as the point and
  ;; window start positions before formatting.
  (let ((input-buffer (current-buffer))
        (saved-point (point))
        (saved-window-start (window-start))

        ;; Create a temporary buffer and file for use in formatting.
        (temp-buffer (generate-new-buffer "*jp-clang-format*"))
        (temp-file (make-temp-file "jp-clang-format"))

        ;; Prompt for the format style to use.
        (format (completing-read "Format style: " jp/clang-format-styles)))

    ;; Run clang-format on the content of the current buffer.
    (call-process-region
     nil nil "clang-format" nil `(,temp-buffer ,temp-file) nil

     ;; Pass style argument if using non-default format.
     (if (string-equal format "Default")
	 "--style=file" (concat "--style=" format)))

    ;; Replace the contents of the input buffer with its formatted
    ;; equivalent produced by clang-format.
    (with-current-buffer temp-buffer
      (copy-to-buffer input-buffer (point-min) (point-max)))

    ;; Restore the point and window positions to their previous values.
    (goto-char saved-point)
    (set-window-start (selected-window) saved-window-start)

    ;; Remove the temporary file and buffer used during formatting.
    (delete-file temp-file)
    (when (buffer-name temp-buffer) (kill-buffer temp-buffer))))


;;; ------------------------------------------------------------------


;; Bring the GC threshold down to normal levels now that all
;; initialization is complete.
(jp/gc-restore)
