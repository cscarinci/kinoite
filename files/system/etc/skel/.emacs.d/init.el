;; init.el -*- lexical-binding: t; -*-

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

(straight-use-package 'use-package)

(use-package ef-themes
  :straight t
  :init
  (ef-themes-take-over-modus-themes-mode 1)
  :bind
  (("<f5>" . modus-themes-rotate)
   ("C-<f5>" . modus-themes-select)
   ("M-<f5>" . modus-themes-load-random))
  :config
  (setq modus-themes-mixed-fonts t)
  (setq modus-themes-italic-constructs t)
  (modus-themes-load-theme 'ef-owl))

(use-package doom-modeline
  :straight t
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-height 25
        doom-modeline-bar-width 3
        doom-modeline-minor-modes t))

(use-package exec-path-from-shell
  :straight t
  :config
  (exec-path-from-shell-initialize))

(require 'server)
(when (and (not (server-running-p))
           (file-exists-p server-auth-dir))
  (delete-directory server-auth-dir t))
(unless (server-running-p)
  (server-start))

(use-package magit
  :straight t
  :bind (("C-x C-g" . magit-status)))

(defun cs--modus-themes-get-all-color-values (symbols)
  "Insert Modus theme colors for SYMBOLS, one per line."
  (dolist (sym symbols)
    (insert
     (format "\n %s | %s"
             (modus-themes-get-color-value sym)
	     sym))))

(defvar cs--modus-themes-color-symbols
  '(cursor
    bg-main
    bg-dim
    bg-alt
    fg-main
    fg-dim
    fg-alt
    bg-active
    bg-inactive
    border
    red
    red-warmer
    red-cooler
    red-faint
    green
    green-warmer
    green-cooler
    green-faint
    yellow
    yellow-warmer
    yellow-cooler
    yellow-faint
    blue
    blue-warmer
    blue-cooler
    blue-faint
    magenta
    magenta-warmer
    magenta-cooler
    magenta-faint
    cyan
    cyan-warmer
    cyan-cooler
    cyan-faint
    bg-red-intense
    bg-green-intense
    bg-yellow-intense
    bg-blue-intense
    bg-magenta-intense
    bg-cyan-intense
    bg-red-subtle
    bg-green-subtle
    bg-yellow-subtle
    bg-blue-subtle
    bg-magenta-subtle
    bg-cyan-subtle
    bg-added
    bg-added-faint
    bg-added-refine
    fg-added
    bg-changed
    bg-changed-faint
    bg-changed-refine
    fg-changed
    bg-removed
    bg-removed-faint
    bg-removed-refine
    fg-removed
    bg-mode-line-active
    fg-mode-line-active
    bg-completion
    bg-hover
    bg-hover-secondary
    bg-hl-line
    bg-paren-match
    bg-err
    bg-warning
    bg-info
    bg-region))

(defun reload-init-file ()
  "Safely reload Emacs configuration."
  (interactive)
  (let ((debug-on-error t))
    (load-file user-init-file)
    (message "Configuration reloaded successfully!")))
(global-set-key (kbd "<f12>") 'reload-init-file)

(use-package recentf
  :straight (:type built-in)
  :bind (:map global-map ("C-x C-r" . recentf-open)) ; override `find-file-read-only'
  :init
  (recentf-mode 1))

(use-package savehist
  :straight (:type built-in)
  :init
  (savehist-mode 1))

(use-package emacs
  :straight (:type built-in)
  :init
  (save-place-mode 1))

(use-package undo-fu
  :straight t)

(use-package undo-fu-session
  :straight t
  :config
  (undo-fu-session-global-mode))

(use-package evil
  :straight t
  :init
  (setq evil-want-fine-undo t)
  (setq evil-undo-system 'undo-fu)
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode))

(use-package evil-collection
  :straight t
  :after evil
  :config
  (evil-collection-init))

(use-package which-key
  :straight (:type built-in)
  :init
  (which-key-mode))

(use-package rainbow-mode
  :straight t
  :hook ((prog-mode . rainbow-mode)
  	 (text-mode . rainbow-mode))
  :config
  (setq rainbow-x-colors nil))

(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic)))

(use-package consult
  :straight t
  :bind (("C-s" . consult-line)
  	 ("C-M-s" . consult-ripgrep)
  	 ("C-x b" . consult-buffer)
  	 ("C-x C-b" . consult-project-buffer)
  	 ("C-x c i" . consult-imenu)
  	 ("C-x c m" . consult-mark)
  	 ("C-x c g" . consult-global-mark)
  	 ("C-x r r" . consult-register)
  	 ("C-x r l" . consult-register-load)
  	 ("C-x r s" . consult-register-store))
  :config
  (setq consult-narrow-key "<")
  (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help))

(use-package marginalia
  :straight t
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package vertico
  :straight
  (vertico :files (:defaults "extensions/*"))
  :custom
  (vertico-cycle t)
  :config
  (vertico-mode))

(use-package vertico-quick
  :after vertico
  :config
  (keymap-set vertico-map "C-." #'vertico-quick-exit))

(use-package embark
  :straight t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
  		 nil
  		 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :straight t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package project
  :straight (:type built-in)
  :custom
  (project-list-file "~/.emacs.d/project-list")
  (project-mode-line t)
  (project-kill-buffers-display-buffer-list t))

(use-package cape 
  :straight t
  :bind ("C-c p" . cape-prefix-map)
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-history)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-tex)
  )

(use-package prescient
  :straight t
  :config
  (prescient-persist-mode 1))

(use-package vertico-prescient
  :straight t
  :after vertico prescient
  :custom
  (vertico-prescient-enable-sorting t)
  (vertico-prescient-override-sorting nil)
  (vertico-prescient-enable-filtering nil)
  :config
  (vertico-prescient-mode 1))

(use-package corfu-prescient
  :straight t
  :after corfu prescient
  :custom
  (corfu-prescient-enable-sorting t)
  (corfu-prescient-override-sorting nil)
  (corfu-prescient-enable-filtering nil)
  :config
  (corfu-prescient-mode 1))


(use-package cs-tex
  :load-path "~/.emacs.d/")


