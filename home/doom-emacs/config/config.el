;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Brandon Orther"
      user-mail-address "brandon@orther.dev")
(setq auth-sources '("~/.config/doom/.authinfo.gpg"))

(setq doom-modeline-buffer-file-name-style 'truncate-upto-root)

(setq show-trailing-whitespace t)
(add-hook! minibuffer-setup (setq-local show-trailing-whitespace nil))

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "MonoLisa" :size 12))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.


;; (setq which-key-idle-delay 0.8
;;       which-key-allow-regexps nil
;;       which-key-allow-evil-operators 1)

(after! which-key
  (setq which-key-idle-delay 0.25)
  (setq which-key-idle-secondary-delay 0))

(setq company-idle-delay 0.1)


;; TypeScript config copied from https://github.com/orther/doom-emacs-private/blob/mbp-laptop/config.org#typescript
(after! typescript-mode
  (add-hook 'typescript-mode-hook #'flycheck-mode)
  (setq typescript-indent-level 2))

(setq js-indent-level 2
      js2-basic-offset 2)

(setq +set-eslint-checker nil)
(after! lsp-ui
  ;; for whatever reason, this was running twice.
  (setq lsp-ui-sideline-show-hover t)
  (when (not +set-eslint-checker)
    (progn
      (setq +set-eslint-checker t)
      (flycheck-add-mode 'javascript-eslint 'web-mode)
      (flycheck-add-next-checker 'lsp-ui  'javascript-eslint)))
      (when (not flycheck-javascript-eslint-executable)
        (setq flycheck-javascript-eslint-executable "eslint_d")))

(after! web-mode
  (add-hook 'web-mode-hook #'flycheck-mode)

  (setq web-mode-markup-indent-offset 2 ;; Indentation
        web-mode-code-indent-offset 2
        web-mode-enable-auto-quoting nil ;; disbale adding "" after an =
        web-mode-auto-close-style 2))

(after! web-mode
  (remove-hook 'web-mode-hook #'+javascript-init-lsp-or-tide-maybe-h)
  (add-hook 'web-mode-local-vars-hook #'+javascript-init-lsp-or-tide-maybe-h))

;; Controls whether Projectile will automatically register known projects.
;; When set to nil you'll have always add projects explicitly with
;; `projectile-add-known-project'.
(setq projectile-track-known-projects-automatically nil)

;; TODO enable org-mode once we have everything else working with nix home-manager
;; ;; If you use `org' and don't want your org files in the default location below,
;; ;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")
;; (setq org-roam-directory "~/org-roam/")

;; (after! org-roam
;;   (map! :leader
;;         :prefix "n"
;;         :desc "org-roam" "l" #'org-roam
;;         :desc "org-roam-insert" "i" #'org-roam-insert
;;         :desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
;;         :desc "org-roam-find-file" "f" #'org-roam-find-file
;;         :desc "org-roam-show-graph" "g" #'org-roam-show-graph
;;         :desc "org-roam-insert" "i" #'org-roam-insert
;;         :desc "org-roam-capture" "c" #'org-roam-capture))

;; (use-package org-journal
;;   :bind
;;   ("C-c n j" . org-journal-new-entry)
;;   :custom
;;   (org-journal-dir "~/org-roam/")
;;   (org-journal-date-prefix "#+TITLE: ")
;;   (org-journal-file-format "%Y-%m-%d.org")
;;   (org-journal-date-format "%A, %d %B %Y"))
;; (setq org-journal-enable-agenda-integration t)
