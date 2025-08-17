;;; --- init.el -------------------------- -*- lexical-binding: t; -*-


;; Raising the garbage collection threshold while the minibuffer is
;; open can make the minibuffer more performant and less freeze-prone.
(add-hook 'minibuffer-setup-hook #'jp/gc-raise)
(add-hook 'minibuffer-exit-hook #'jp/gc-restore-deferred)

(defun jp/show-startup-stats ()
  "Show initialization duration in the minibuffer after startup."
  (message
   "Emacs started in %s seconds"
   (format "%.2f" (float-time
                   (time-subtract after-init-time before-init-time)))))

;; Show total startup time once Emacs has finished loading.
(add-hook 'emacs-startup-hook #'jp/show-startup-stats)

(load custom-file :no-error-if-file-is-missing)


;;;
;;; --- Package management -------------------------------------------
;;;


(require 'package)
(package-initialize)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(when (< emacs-major-version 29)
  (unless (package-installed-p 'use-package)
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'use-package)))

(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))

;; Always require packages specified in this config to be present.
(require 'use-package-ensure)
(setq use-package-always-ensure t)


;;;
;;; --- Basic editing & options --------------------------------------
;;;


;; Do not create the annoying backfiles (tildes) or lockfiles (hash)
;; that Emacs likes to create by default.
(setopt make-backup-files nil
	create-lockfiles nil)

(setopt truncate-lines t)		; Don't wrap long lines
(setopt ring-bell-function 'ignore)	; Disable flashing bell

;; Automatically reload files from disk on change.
(setopt auto-revert-avoid-polling t)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode)

(electric-pair-mode 1)              ; Auto-close parentheses, etc.
(column-number-mode)                ; Show column numbers in mode line

(global-hl-line-mode)			    ; Highlight cursor line
(global-display-fill-column-indicator-mode) ; Show fill column ruler

(defun jp/set-fill-length-70 ()
  "Set the current buffer's fill length to 70 columns."
  (setq fill-column 70))

;; Wrap text to 80 columns by default, but use 70 columns for Elisp.
(setopt fill-column 80)
(add-hook 'emacs-lisp-mode-hook #'jp/set-fill-length-70)

(setopt sentence-end-double-space nil)	; It is no longer the 1900s
(setopt show-trailing-whitespace t)	; Show trailing spaces
(setopt require-final-newline t)	; End files with a newline

;; Remove trailing whitespace before saving buffers.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Prevent the "ls does not support dired" message by not attempting
;; to use use the flag at all on Darwin.
(when (string= system-type "darwin")
  (setq dired-use-ls-dired nil))

;; Emacs has very strange defaults for indentation, and formatting
;; styles vary from project to project. It is best to mimic the
;; existing indentation style, which can be guessed from the buffer
;; using the 'dtrt-indent' package.
(use-package dtrt-indent
  :hook ((c-mode c++-mode objc-mode python-mode js-mode) . dtrt-indent-mode))


;;;
;;; --- User interface -----------------------------------------------
;;;


;; Live help for long key combos.
(use-package which-key
  :config
  (which-key-mode))

;; Modern & minimal text-completion popup.
(use-package corfu
  :hook ((prog-mode . corfu-mode))
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-auto-prefix 2)
  (corfu-scroll-margin 2))

;; Better minibuffer completion.
(use-package vertico
  :hook (after-init . vertico-mode))

;; Multiple & fuzzy completion style that works very well in
;; conjunction with Vertico.
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(defun jp/config-mono-font ()
  "Set the default font if it is available."
  (setq jp/mono-font "MD IO")

  (when (member jp/mono-font (font-family-list))
    (set-face-attribute 'default nil :font jp/mono-font)
    (set-face-attribute 'fixed-pitch nil :font jp/mono-font))

  (setopt line-spacing 0.1))

(jp/config-mono-font)

(use-package modus-themes
  :config (load-theme 'modus-operandi :no-confirm-loading))


;;;
;;; --- IDE-like features --------------------------------------------
;;;


;; Graphical, interactive Git interface.
(use-package magit
  :commands magit-status
  :custom
  ;; Don't incessantly ask to save changes.
  (magit-save-repository-buffers nil)

  ;; Replace the current window when opening Magit, rather than
  ;; creating a new one.
  (magit-display-buffer-function
   'magit-display-buffer-same-window-except-diff-v1))

;; Integration with language servers for completion.
(use-package eglot
  :hook ((c-mode c++-mode objc-mode python-mode js-mode) . eglot-ensure)
  :bind (("C-; r" . eglot-rename)
	 ("C-; a" . eglot-code-actions))
  :custom
  (eglot-sync-connect nil)
  (eglot-highlight-symbol-face highlight)
  (eglot-ignored-server-capabilities '(:inlayHintProvider
				       :documentOnTypeFormattingProvider)))

;; Good integration with Ripgrep.
(use-package rg
  :bind (("C-c s" . rg-menu)))


;;;
;;; --- Org ----------------------------------------------------------
;;;


(defun jp/org-babel-clear-results ()
  "Clear all result blocks in an Org buffer."
  (interactive)
  (org-babel-remove-result-one-or-many t))

(defun jp/org-config-appearance ()
  "Disable line numbers and fill indicator in Org buffers."
  (display-fill-column-indicator-mode -1)
  (display-line-numbers-mode -1))

(defun jp/org-agenda ()
  "Open personal Org agenda view."
  (interactive)
  (org-agenda nil "A"))

(defun jp/org-capture-task ()
  "Capture a new task."
  (interactive)
  (org-capture nil "t"))

(use-package org
  :bind (("C-c a" . org-agenda)
	 ("C-c A" . jp/org-agenda)
	 ("C-c c" . org-capture)
	 ("C-c t" . jp/org-capture-task))
  :hook ((org-mode . turn-on-auto-fill)
         ((org-mode org-agenda-mode) . jp/org-config-appearance))
  :custom
  (org-startup-indented t)
  (org-agenda-files '("~/Global.org"))
  (org-default-notes-file "~/Global.org")
  (org-agenda-window-setup 'only-window)

  (org-agenda-custom-commands
   '(("A" "Personal agenda"
      ((agenda "" ((org-agenda-overriding-header "Last week\n")
		   (org-agenda-span 'week)
		   (org-agenda-start-day "-7d")))
       (agenda "" ((org-agenda-overriding-header "This week\n")
		   (org-agenda-span 'week)
		   (org-agenda-start-day "+0d")))
       (agenda "" ((org-agenda-overriding-header "Next week\n")
		   (org-agenda-span 'week)
		   (org-agenda-start-day "+7d")))
       (todo nil ((org-agenda-overriding-header "Backlog\n")
		  (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled)))))

      ((org-agenda-scheduled-leaders '("" ""))
       (org-agenda-remove-tags nil)
       (org-agenda-prefix-format "  ")
       (org-agenda-sorting-strategy '(time-up todo-state-down priority-down)))))))


;;;
;;; --- Extra keybindings --------------------------------------------
;;;


(use-package emacs
  :bind (("C-x C-b" . switch-to-buffer)
	 ("C-c C-e" . eval-buffer)
	 ("C-c r" . replace-regexp)
	 ("C-c o" . overwrite-mode)

	 ("C-x C-p" . project-find-file)

	 ("C-=" . text-scale-increase)
	 ("C--" . text-scale-decrease)))


;;--------------------------------------------------------------------


;; Bring the GC threshold down to normal levels now that all
;; initialization is complete.
(jp/gc-restore)
