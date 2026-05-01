;;; --- init.el -------------------------- -*- lexical-binding: t; -*-


;; Raising the garbage collection threshold while the minibuffer is
;; open can make the minibuffer more performant and less freeze-prone.
(add-hook 'minibuffer-setup-hook #'jp/gc-raise)
(add-hook 'minibuffer-exit-hook #'jp/gc-restore-deferred)

(defun jp/show-startup-stats ()
  "Show initialization duration in the minibuffer after startup."
  (message
   "Emacs started in %s seconds with %d GCs."
   (format "%.2f" (float-time
                   (time-subtract after-init-time before-init-time)))
   gcs-done))

;; Show total startup time once Emacs has finished loading.
(add-hook 'emacs-startup-hook #'jp/show-startup-stats)

(load custom-file :no-error-if-file-is-missing)


;;;
;;; --- Package management -------------------------------------------
;;;


;; Saves a lot of startup time, and has no downsides since I'm not
;; developing packages.
(setopt straight-check-for-modifications nil)

;; Use Straight for package management, primarily for performance
;; reasons (among other, better ones).
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Hide excessive warnings, etc. related to native compilation.
(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))

(straight-use-package 'use-package)
(setopt straight-use-package-by-default t)
(setopt straight-vc-git-default-clone-depth '(1 single-branch))

;; Always require packages specified in this config to be present.
(require 'use-package-ensure)
(setopt use-package-always-ensure t)


;;;
;;; --- Basic editing & options --------------------------------------
;;;


;; Do not create the annoying backfiles (tildes) or lockfiles (hash)
;; that Emacs likes to create by default.
(setopt make-backup-files nil
	create-lockfiles nil)

(setopt truncate-lines t)		; Don't wrap long lines.
(setopt ring-bell-function 'ignore)	; Disable flashing bell.

(setopt use-short-answers t)		; Allow 'y' instead of 'yes'.

;; Automatically reload files from disk on change.
(setopt auto-revert-avoid-polling t)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode)

(setopt cursor-type 'bar)		; Use traditional bar cursor.
(global-hl-line-mode)			; Highlight cursor line.

(delete-selection-mode t)   ; Behave a little more like other editors.
(electric-pair-mode t)	    ; Auto-close parentheses, etc.
(column-number-mode t)	    ; Show column numbers in mode line.

(defun jp/set-fill-length-70 ()
  "Set the current buffer's fill length to 70 columns."
  (setq fill-column 70))

;; Wrap text to 80 columns by default, but use 70 columns for Elisp.
(setopt fill-column 80)
(add-hook 'emacs-lisp-mode-hook #'jp/set-fill-length-70)

(global-display-fill-column-indicator-mode) ; Show fill column ruler.

(setopt sentence-end-double-space nil)	; It is no longer the 1900s.
(setopt show-trailing-whitespace t)	; Show trailing spaces.
(setopt require-final-newline t)	; End files with a newline.

;; Disable support for bidirectional text (for performance).
(setq bidi-inhibit-bpa t)
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)

(setq redisplay-skip-fontification-on-input t)

;; Improve scrolling experience.
(setopt scroll-margin 6)
(setopt scroll-conservatively 8)
(setopt mouse-wheel-progressive-speed nil)

;; Prevent the "ls does not support dired" message by not attempting
;; to use use the flag at all on Darwin.
(when (string= system-type "darwin")
  (setopt dired-use-ls-dired nil))

;; Emacs has very strange defaults for indentation, and formatting
;; styles vary from project to project. It is best to mimic the
;; existing indentation style, which can be guessed from the buffer
;; using the 'dtrt-indent' package.
(use-package dtrt-indent
  :hook ((c-mode
	  c++-mode
	  objc-mode
	  rust-mode
	  python-mode
	  js-mode
	  json-mode) . dtrt-indent-mode))

;; This affects the way braces are indented automatically; the default
;; is the GNU-style. Gross.
(setopt c-default-style "bsd")


;;;
;;; --- User interface -----------------------------------------------
;;;


;; Enable mouse support in terminal mode.
(unless (display-graphic-p)
  (xterm-mouse-mode))

;; Allegedly saves rendering time.
(setopt cursor-in-non-selected-windows nil)
(setopt highlight-nonselected-windows nil)

;; Live help for long key combos.
(use-package which-key
  :hook (after-init . which-key-mode))

;; Sublime-style multiple cursors.
(use-package multiple-cursors
  ;; Adds a perceivable delay to startup time, but an imperceivable
  ;; delay when loaded on-demand; also used infrequently enough that
  ;; the on-demand delay is justified.
  :defer t
  :bind ("C-\\" . 'mc/mark-next-like-this)
  ;; Disable annoying prompt asking you if you would like to do the
  ;; exact thing you requested to do.
  :custom (mc/always-run-for-all t))

;; Modern & minimal text-completion popup.
(use-package corfu
  :hook (prog-mode . corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-auto-prefix 2)
  (corfu-scroll-margin 2))

(defun jp/corfu-terminal ()
  (unless (display-graphic-p)
    (corfu-terminal-mode +1)))

;; Corfu support for terminal Emacs.
;;
;; TODO: Remove when using Emacs 31+.
(use-package corfu-terminal
  :after corfu
  :hook (corfu-mode . jp/corfu-terminal))

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

(defun jp/macos-dark-mode-p ()
  "Is macOS currently in dark mode?"
  (string= (shell-command-to-string "defaults read -g AppleInterfaceStyle") "Dark\n"))

(use-package modus-themes
  :config
  (modus-themes-load-theme
   (if (jp/macos-dark-mode-p)
       'modus-vivendi
     'modus-operandi)))

(defun jp/macos-pbpaste ()
  "Get the contents of the macOS pasteboard."
  (shell-command-to-string "pbpaste"))

(defun jp/macos-pbcopy (text &optional push)
  "Set the contents of the macOS pasteboard."
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

;; When running in the terminal, we need to set these so copy/paste
;; syncs with the system clipboard properly.
(unless (display-graphic-p)
  (setq interprogram-cut-function 'jp/macos-pbcopy
	interprogram-paste-function 'jp/macos-pbpaste))


;;;
;;; --- Extra language support ---------------------------------------
;;;


(use-package rust-mode
  :mode (("\\.rs\\'" . rust-mode))
  ;; By default, this binding gets stolen by `rust-mode', which is
  ;; annoying. How else am I meant to wrap my comments?
  :bind (:map rust-mode-map ("M-q" . nil))
  ;; On that note, fill to the standard column for Rust.
  :hook (rust-mode . (lambda () (setq fill-column 100))))

(use-package cmake-mode
  :mode (("CMakeLists\\.txt\\'" . cmake-mode)
         ("\\.cmake\\'" . cmake-mode)))

(use-package yaml-mode
  :mode (("\\.ya?ml\\'" . yaml-mode))
  :custom ((yaml-indent-offset 2)))

(use-package toml-mode
  :mode "\\.toml\\'")

(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode))


;;;
;;; --- IDE-like features --------------------------------------------
;;;


;; Snippet engine; needed for auto-complete, etc.
(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :bind ("M-i" . 'yas-insert-snippet))

;; The primary YASnippet package does not include any snippets, only
;; the functionality for using them. The default snippet collection is
;; shipped separately in this package.
(use-package yasnippet-snippets
  :after yasnippet
  :config (yasnippet-snippets-initialize))

;; Graphical, interactive Git interface.
(use-package magit
  :commands magit-status
  :custom
  ;; Don't incessantly ask to save changes.
  (magit-save-repository-buffers nil)

  ;; Allegedly improves performance by eliminating the need to use the
  ;; shell to get $PATH.
  (magit-git-executable "/opt/homebrew/bin/git")

  ;; Show word-level diffs.
  (magit-diff-refine-hunk (quote all))

  ;; Replace the current window when opening Magit, rather than
  ;; creating a new one.
  (magit-display-buffer-function
   'magit-display-buffer-same-window-except-diff-v1))

(setq vc-handled-backends '(Git))	; Performance? Can't remember.

(defun jp/project-try-nearest-git (dir)
  (let ((root (locate-dominating-file dir ".git")))
    (when root
      (require 'vc-git)
      (list 'vc 'Git (expand-file-name root)))))

;; Always prefer the nearest Git repo when attempting to find the
;; appropriate project direcotry. Prevents always going to the root
;; repo when working with lots of submodules.
(add-hook 'project-find-functions #'jp/project-try-nearest-git)

(defun jp/project-has-noeglot-p ()
  "Return non-nil if the current project has a '.noeglot' file at its root."
  (when-let ((project (project-current)))
    (file-exists-p (expand-file-name ".noeglot" (project-root project)))))

(defun jp/eglot-ensure-most-of-the-time ()
  "Activate Eglot, unless requested otherwise or if it would be bad."
  (unless (or (file-remote-p default-directory)
              (jp/project-has-noeglot-p))
    (eglot-ensure)))

;; Integration with language servers for completion.
(use-package eglot
  :hook ((c-mode
	  c++-mode
	  objc-mode
	  python-mode
	  js-mode
	  rust-mode) . jp/eglot-ensure-most-of-the-time)
  :bind (("C-; r" . eglot-rename)
	 ("C-; a" . eglot-code-actions))
  :config
  (add-to-list 'eglot-server-programs '((python-mode) . ("ty" "server")))
  :custom
  ;; Auto-shutdown when the last buffer using a server is closed.
  (eglot-autoshutdown t)
  ;; Don't block UI while connecting.
  (eglot-sync-connect nil)
  ;; Use more subtle highlighting.
  (eglot-highlight-symbol-face highlight)
  ;; Unsure what this is; it line height from jumping around.
  (eglot-code-action-indications '(eldoc-hint))
  ;; Don't want either of these anti-features.
  (eglot-ignored-server-capabilities '(:inlayHintProvider
				       :documentOnTypeFormattingProvider)))

;; Good integration with Ripgrep.
(use-package rg
  :bind (("C-c s" . rg-menu))
  :custom (rg-show-header . nil))


;;;
;;; --- Org ----------------------------------------------------------
;;;


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
	 ("C-c t" . jp/org-capture-task)
	 ("C-c l" . org-store-link))
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
(jp/gc-restore-deferred)
