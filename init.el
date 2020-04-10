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

;; Tabs are awful & don't play nice with parinfer-mode
(setq-default indent-tabs-mode nil)

;; Recent files list
(recentf-mode 1)
(setq-default recent-save-file "~/.emacs.d/recentf")

;; Font
(add-to-list 'default-frame-alist '(font . "JetBrains Mono 13"))

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
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :ensure t
  :config
  (evil-collection-init))

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
        helm-google-suggest-use-curl-p t
        helm-locate-command "locate %s %s")
  :config
  (helm-mode 1)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action))
  

;; Which Key
(use-package which-key
  :ensure t
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode 1))

;; Line numbers
(setq display-line-number t)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Magit
(use-package magit
  :ensure t)

(use-package evil-magit
  :ensure t
  :init
  (require 'evil-magit))

;; Magithub is nice but is just way too slow with big repos like ES
;; (use-package magithub
;;   :ensure t
;;   :config
;;   (magithub-feature-autoinject t))

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
           "bx"  '(kill-this-buffer :which-key "delete buffer")
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
           "at"  '(shell :which-key "open terminal")
           "/"   '(comment-line :which-key "comment/uncomment line(s)")))
           

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
(use-package racket-mode
  :ensure t
  :init
  (progn
    (setq racket-program "/usr/local/bin/racket")
    (add-hook 'racket-mode-hook #'racket-xp-mode))
  :config
  (general-define-key
   :states '(normal visual insert emacs)
   :keymaps 'racket-mode-map
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   "msf" '(racket-mode-start-faster :which-key "start faster")
   "mer" '(racket-send-region :which-key "eval region")
   "med" '(racket-send-definition :which-key "eval definition")
   "mes" '(racket-send-last-sexp :which-key "eval last sexp")
   "meb" '(racket-run :which-key "racket run")
   "mee" '(racket-run-and-switch-to-repl :which-key "run and goto repl")
   "mem" '(racket-run-module-at-point :which-key "run module at point")
   "mep" '(racket-profile-mode :which-key "prfile")
   "ml"  '(racket-insert-lambda :which-key "insert lambda")
   "mvm" '(racket-visit-module :which-key "visit module")
   "mvv" '(racket-unvisit :which-key "unvisit")
   "mtt" '(racket-test :which-key "run tests")
   "mtf" '(racket-fold-all-tests :which-key "fold tests")
   "mtF" '(racket-unfold-all-tests :which-key "unfold tests")
   "mfr" '(racket-tidy-requires :which-key "format requires")
   "mfR" '(racket-trim-requires :which-key "minimize requires")
   "mfb" '(racket-base-requires :which-key "racket -> racket/base")
   "mc"  '(racket-cycle-paren-shapes :which-key "cycle paren shape")
   "ml"  '(racket-logger :which-key "logger mode")
   "mxx" '(racket-xp-mode :which-key "xp mode")
   "mxn" '(racket-xp-next-error :which-key "next error")
   "mxp" '(racket-xp-previous-error :which-key "previous error")
   "mxd" '(racket-xp-describe :which-key "describe at point")
   "mxr" '(racket-xp-rename :which-key "rename")
   "mxD" '(racket-xp-documentation :which-key "HTML doc at point")
   "mxg" '(racket-xp-visit-definition :which-key "visit definition")))

;; Lisp
(use-package sly
  :ensure t
  :init
  (setq inferior-lisp-program "/usr/local/bin/ros -Q run")
  :config
  (general-define-key
   :states '(normal visual insert emacs)
   :keymaps 'lisp-mode-map
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   "mm"  '(sly             :which-key "start sly")
   "mer" '(sly-eval-region :which-key "eval region")
   "med" '(sly-eval-defun  :which-key "eval defun")))

(use-package parinfer
  :ensure t
  :init
  (progn
    (setq parinfer-extensions '(defaults pretty-parens evil smart-tab))
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)
    (add-hook 'racket-mode-hook #'parinfer-mode))
  :config
  (progn
    (general-define-key
     :states '(normal visual insert emacs)
     :keymaps
     '(emacs-lisp-mode-map
       clojure-mode-map
       common-lisp-mode-map
       scheme-mode-map
       lisp-mode-map)
     "TAB" 'parinfer-smart-tab:dwim-right
     "<tab>" 'parinfer-smart-tab:dwim-right
     "S-TAB" 'parinfer-smart-tab:dwim-left
     "<backtab>" 'parinfer-smart-tab:dwim-left)
    (parinfer-strategy-add 'default
      '("parinfer-smart-tab"))
    ;; Disable electric pair of parens in parinfer-mode
    (add-hook 'parinfer-mode-hook
              (lambda ()
                (setq-local electric-pair-inhibit-predicate
                            `(lambda (c)
                               (if (char-equal c 40) t (,electric-pair-inhibit-predicate c))))))))

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

;; Elasticsearch
(use-package es-mode
  :ensure t
  :config
  (progn
    ;; I don't ever want to see unformatted json, honestly
    (setq es-always-pretty-print t)
    ;; Default username/password
    (add-to-list 'es-default-headers (cons "Authorization" (concat "Basic " (base64-encode-string "elastic:password"))))
    (add-hook 'es-result-mode-hook 'hs-minor-mode)
    (general-define-key
     :states '(normal visual insert emacs)
     :keymaps 'es-mode-map
     :prefix "SPC"
     "me"  '(es-execute-request-dwim :which-key "execute request")
     "mu"  '(es-set-endpoint-url     :which-key "set endpoint url")
     "my"  '(es-copy-as              :which-key "copy as")))
  :mode
  ("\\.es$" . es-mode))

;; Disable backup files
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files
(setq create-lockfiles nil)  ; stop making .#lock files

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (racket-mode which-key use-package sly rainbow-delimiters projectile parinfer neotree markdown-mode helm general geiser faceup evil-magit evil-collection es-mode doom-themes all-the-icons adoc-mode ace-jump-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.

