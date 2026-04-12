;; early-init.el -*- lexical-binding: t; -*-

(setq site-run-file nil
      inhibit-startup-screen t
      inhibit-message nil
      use-short-answers t)

(defvar cs-emacs--gc-cons-threshold gc-cons-threshold)
(defvar cs-emacs--gc-cons-percentage gc-cons-percentage)
(defvar cs-emacs--vc-handled-backends vc-handled-backends)

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)
(setq vc-handled-backends nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold cs-emacs--gc-cons-threshold
                  gc-cons-percentage cs-emacs--gc-cons-percentage
                  vc-handled-backends cs-emacs--vc-handled-backends)))

(setq package-enable-at-startup nil)

(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(set-fringe-mode 0)

(setq-default pixel-scroll-mode t)
(setq-default warning-minimum-level :error)
(setq-default display-line-numbers-type 'nil)
(setq-default mode-line-format nil)

(add-hook 'emacs-startup-hook #'global-display-line-numbers-mode)
;; (add-to-list 'default-frame-alist '(font . "Fira Code-13"))
(add-to-list 'default-frame-alist '(font . "Hack-13"))
;; (add-to-list 'default-frame-alist '(undecorated . t))

(setq backup-directory-alist '(("." . "~/.emacs.d/backups/")))
(setq auto-save-file-name-transforms
      '((".*" "~/.emacs.d/backups/" t)))
(make-directory "~/.emacs.d/backups" t)
(setq create-lockfiles nil)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(setq temporary-file-directory "~/.emacs.d/tmp/")
(make-directory temporary-file-directory t)
