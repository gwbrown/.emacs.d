;; gwbrown's emacs config

;; Adjust UI
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode t)

;; Various settings
(setq vc-follow-symlinks t) ;; don't ask for confirmation when opening symlinked file
(setq inhibit-startup-screen t) ;; inhibit useless and old-school startup screen
(setq ring-bell-function 'ignore) ;; silent bell when you make a mistake
(setq coding-system-for-read 'utf-8) ;; use utf-8 by default
(setq coding-system-for-write 'utf-8)
(setq sentence-end-double-space nil)

;; Recent files list
(recentf-mode 1)
(setq-default recent-save-file "~/.emacs.d/recentf")

;; Font
(add-to-list 'default-frame-alist '(font . "Iosevka Term 13"))

;; Generally nice
(add-hook 'prog-mode-hook #'electric-pair-mode)
;; Packages
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")))
(package-initialize)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Vim mode
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

;; Theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))

;; Helm
(use-package helm
  :ensure t
  :init
  (setq helm-M-x-fuzzy-match t
	helm-mode-fuzzy-match t
	helm-buffers-fuzzy-matching t
	helm-recentf-fuzzy-match t
	;;helm-locate-fuzzy-match t ;; doesn't work on macos afaict
	helm-semantic-fuzzy-match t
	helm-imenu-fuzzy-match t
	helm-completion-in-region-fuzzy-match t
	helm-candidate-number-list 150
	helm-split-window-in-side-p t
	helm-move-to-line-cycle-in-source t
	helm-echo-input-in-header-line t
	helm-autoresize-max-height 0
	helm-autoresize-min-height 20
	helm-ff-file-name-history-use-recentf t
	helm-locate-command "locate %s %s")
  :config
  (helm-mode 1))

;; Which Key
(use-package which-key
  :ensure t
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode 1))

;; Line numbers
(global-linum-mode t)

;; Magit
(use-package magit
  :ensure t
  :pin melpa-stable)

(use-package evil-magit
  :ensure t
  :init
  (require 'evil-magit)
  :pin melpa-stable)

;; Movement
(use-package ace-jump-mode
  :ensure t)

;; Custom keybinding
(use-package general
  :ensure t
  :config (general-define-key
	   :states '(normal visual insert emacs)
	   :prefix "SPC"
	   :non-normal-prefix "C-SPC"
	   ;; "/"   '(counsel-rg :which-key "ripgrep") ; You'll need counsel package for this
	   "TAB" '(switch-to-prev-buffer :which-key "previous buffer")
	   "SPC" '(helm-M-x :which-key "M-x")
	   ;; File browsing
	   "ff"  '(helm-find-files :which-key "find files")
	   "fj"  '(helm-mini :which-key "helm mini")
	   ;; Buffers
	   "bb"  '(helm-buffers-list :which-key "buffers list")
	   "bx"  '(evil-delete-buffer :which-key "delete buffer")
	   "bk"  '(kill-buffer :which-key "kill buffer")
	   ;; Window
	   "wl"  '(windmove-right :which-key "move right")
	   "wh"  '(windmove-left :which-key "move left")
	   "wk"  '(windmove-up :which-key "move up")
	   "wj"  '(windmove-down :which-key "move bottom")
	   "w/"  '(split-window-right :which-key "split right")
	   "w-"  '(split-window-below :which-key "split bottom")
	   "wx"  '(delete-window :which-key "delete window")
	   ;; Movement
	   "jj"  '(ace-jump-mode :which-key "ace jump")
	   ;; Magit
	   "gg"  '(magit-status :which-key "magit status")
	   ;; Evaluation
	   "eb"  '(eval-buffer :which-key "evalutate buffer")
	   "ee"  '(eval-last-sexp :which-key "evaluate last expression")
	   ;; Others
	   "at"  '(ansi-term :which-key "open terminal")
	   ))

;; Fancy titlebar for MacOS
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(setq ns-use-proxy-icon  nil)
(setq frame-title-format nil)

;; Projectile
(use-package projectile
  :ensure t
  :init
  (setq projectile-require-project-root nil)
  :config
  (projectile-mode 1))

;; All The Icons
(use-package all-the-icons :ensure t)

;; NeoTree
(use-package neotree
  :ensure t
  :init
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

;; Show matching parens
(setq show-paren-delay 0)
(show-paren-mode 1)

(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; Languages
;; ---------

;; Scheme
(use-package geiser
  :ensure t
  :init
  (setq geiser-active-implementations '(racket)
	geiser-racket-binary "/usr/local/bin/racket")
  :pin melpa-stable)

;; Lisp
(use-package slime
  :ensure t
  :init
  (setq inferior-lisp-program "/usr/local/bin/sbcl"
	slime-contribs '(slime-fancy)))

;; Asciidoc
(use-package adoc-mode
  :ensure t
  :mode "\\.asciidoc\\'")

;; Markdown
(use-package markdown-mode
  :ensure t
  :mode
  ("README\\.md\\'" . gfm-mode)
  ("\\.md\\'" . markdown-mode))

;; Disable backup files
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

;; All this is auto generated
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (markdown-mode adoc-mode ace-jump-mode slime geiser evil-magit magit rainbow-delimiters neotree all-the-icons projectile general which-key helm doom-themes evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
