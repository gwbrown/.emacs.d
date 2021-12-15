;; gwbrown's emacs config

;; Don't need to GC aggressively during starting
(setq gc-cons-threshold (* 50 1024 1024)) ;; 50 MB

;; Always compile, if native compilation is available

(if (and (fboundp 'native-comp-available-p)
        (native-comp-available-p))
    (setq comp-deferred-compilation t)
    (setq package-native-compile t))

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

;; Set these variables BEFORE loading evil stuff
(setq evil-want-integration t
      evil-want-keybinding nil
      evil-collection-want-unimpaired-p nil
      evil-collection-calendar-want-org-bindings t
      evil-collection-setup-minibuffer t)

;; Vim mode
(use-package evil
  :ensure t
  :diminish
  :config
  (evil-mode 1))

;; Let Esc act like C-g
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package evil-collection
  :ensure t
  :config
  (evil-collection-init))

(use-package command-log-mode
  :commands command-log-mode)

(use-package delight
  :ensure t)

(use-package company
  :ensure t
  :delight " cA"
  :config (global-company-mode))

(use-package company-quickhelp
  :ensure t
  :requires company
  :config (company-quickhelp-mode))

(use-package company-quickhelp-terminal
  :ensure t
  :requires (company company-quickhelp)
  :config (company-quickhelp-terminal-mode))

;; Theme
(use-package doom-themes
  :ensure t
  :config
  (progn
    (load-theme 'doom-manegarm t)
    (doom-themes-visual-bell-config)))

;; Helm
(use-package helm
  :ensure t
  :delight " H"
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
  :diminish
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode 1))

;; Line numbers
(column-number-mode)
;;(setq display-line-number t)
;;(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Magit
(use-package magit
  :commands magit-status
  :ensure t)

;; Movement
(use-package ace-jump-mode
  :commands ace-jump-mode
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
           "w"   '(other-window :which-key "switch to other window")
           "SPC" '(helm-M-x :which-key "M-x")
           ;; File browsing
           "ff"  '(helm-find-files :which-key "find files")
           "fj"  '(helm-mini :which-key "helm mini")
           ;; Buffers
           "q"  '(kill-this-buffer :which-key "delete buffer")
           ;; Movement
           "j"  '(ace-jump-mode :which-key "ace jump")
           ;; Magit
           "g"  '(magit-status :which-key "magit status")
           ;; Smartparens
           "s"  '(sp-forward-slurp-sexp :which-key "slurp forward")
           "S"  '(sp-backward-slurp-sexp :which-key "slurp backward")
           "b"  '(sp-forward-barf-sexp :which-key "barf forward")
           "B"  '(sp-backward-barf-sexp :which-key "barf backward")
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
  :delight '(:eval (concat " P[" (projectile-project-name) "]"))
  :init
  (setq projectile-require-project-root nil)
  :config
  (projectile-mode 1))

;; Show matching parens
(setq show-paren-delay 0)
(show-paren-mode 1)

(use-package rainbow-delimiters
  :ensure t
  :hook ((racket-mode prog-mode) . rainbow-delimiters-mode))

;; Languages
;; ---------

;; Scheme
(use-package racket-mode
  :ensure t
  :init
  (progn
    (setq racket-program "/usr/local/bin/racket"))
  :mode "\\.rkt\\'"
  ;; :hook (racket-mode . racket-xp-mode)
  :config
  (general-define-key
   :states '(normal visual insert emacs)
   :keymaps 'racket-mode-map
   :prefix ","
   :non-normal-prefix "C-,"
   "sf" '(racket-mode-start-faster :which-key "start faster")
   
   "er" '(racket-send-region :which-key "eval region")
   "ed" '(racket-send-definition :which-key "eval toplevel form")
   "es" '(racket-send-last-sexp :which-key "eval last exp")
   "eb" '(racket-run :which-key "save and eval buffer")
   "ee" '(racket-run-and-switch-to-repl :which-key "save, eval, & goto repl")
   "em" '(racket-run-module-at-point :which-key "save & eval module at point")
   "ep" '(racket-profile :which-key "save, eval, & profile module at point")
   "eM" '(racket-stepper-mode :which-key "expansion stepper mode")
   
   "l"  '(racket-insert-lambda :which-key "insert lambda")
   
   "vm" '(racket-visit-module :which-key "visit module")
   "vv" '(racket-unvisit :which-key "unvisit")
   
   "tt" '(racket-test :which-key "run tests")
   "tf" '(racket-fold-all-tests :which-key "fold tests")
   "tF" '(racket-unfold-all-tests :which-key "unfold tests")
   
   "fr" '(racket-tidy-requires :which-key "format requires")
   "fR" '(racket-trim-requires :which-key "minimize requires")
   "fb" '(racket-base-requires :which-key "racket -> racket/base")
   
   "c"  '(racket-cycle-paren-shapes :which-key "cycle paren shape")
   "l"  '(racket-logger :which-key "logger mode")
   
   "xx" '(racket-xp-mode :which-key "xp mode")
   "xn" '(racket-xp-next-error :which-key "next error")
   "xp" '(racket-xp-previous-error :which-key "previous error")
   "xd" '(racket-xp-describe :which-key "describe at point")
   "xr" '(racket-xp-rename :which-key "rename")
   "xD" '(racket-xp-documentation :which-key "HTML doc at point")
   "xg" '(racket-xp-visit-definition :which-key "visit definition")))

;; Lisp
(use-package sly
  :ensure t
  :init
  (setq inferior-lisp-program "/usr/local/bin/ros -Q run")
  :mode ("\\.li?sp\\|.cl\\'" . lisp-mode)
  :config
  (general-define-key
   :states '(normal visual insert emacs)
   :keymaps '(lisp-mode-map sly-mrepl-mode-map)
   :prefix ","
   :non-normal-prefix "C-,"
   "m"  '(sly             :which-key "start sly")
   "es" '(sly-mrepl-sync  :which-key "sync repl package & dir")
   "er" '(sly-eval-region :which-key "eval region")
   "eD" '(sly-eval-defun  :which-key "eval toplevel form")
   "el" '(sly-eval-last-expression :which-key "eval last exp")
   "ei" '(sly-interactive-eval :which-key "interactive eval")
   "ev" '(sly-edit-value :which-key "edit value")
   "eu" '(sly-undefine-function :which-key "undefine symbol at point")
   "em" '(sly-expand-1    :which-key "expand 1 at point")
   "eM" '(sly-macroexpand-all :which-key "fully expand at point")
   "ed" '(sly-compile-defun :which-key "compile toplevel form")
   "eB" '(sly-compile-and-load-file :which-key "compile & load file")
   "eR" '(sly-compile-region :which-key "compile region")
   
   "nc" '(sly-remove-notes :which-key "clear notes")
   "nj" '(sly-next-note :which-key "next note")
   "nk" '(sly-previous-node :which-key "previous note")
   
   "gd" '(sly-edit-definition :which-key "go to definition")
   "gD" '(sly-pop-find-definition-stack :which-key "go back")
   "gw" '(sly-edit-definition-other-window :which-key "open def in other window")
   "gu" '(sly-edit-uses :which-key "find uses")
   "gc" '(sly-who-calls :which-key "find callers")
   "gC" '(sly-calls-who :which-key "find callees")
   "gr" '(sly-who-references :which-key "find global var refs")
   "gb" '(sly-who-binds :which-key "find global var bindings")
   "ga" '(sly-who-sets :which-key "find assignments of global var")
   "gs" '(sly-who-specializes :which-key "find specialized methods")

   "dd" '(sly-describe-symbol :which-key "describe symbol at point")
   "df" '(sly-describe-function :which-key "describe function at point")
   "da" '(sly-apropos :which-key "regex search external symbols")
   "dA" '(sly-apropos-all :which-key "regex search all symbols")
   "dp" '(sly-apropos-package :which-key "describe package")
   "dh" '(sly-hyperspec-lookup :which-key "hyperspec lookup at point")
   "d#" '(hyperspec-lookup-reader-macro :which-key "lookup reader macro in hyperspec")
   "d~" '(hyperspec-lookup-format :which-key "lookup format character in hyperspec")

   "i"  '(sly-inspect :which-key "inspect value")

   "ss" '(sly-stickers-dwim :which-key "stickers dwim")
   "sr" '(sly-stickers-replay :which-key "replay stickers")
   "sb" '(sly-stickers-toggle-break-on-stickers :which-key "toggle break on stickers")
   "sf" '(sly-stickers-fetch :which-key "fetch latest results")
   "sj" '(sly-stickers-next-sticker :which-key "next sticker")
   "sk" '(sly-stickers-prev-sticker :which-key "previous sticker")
   
   "tt" '(sly-trace-dialog-toggle-trace :which-key "toggle sly trace")
   "tT" '(sly-trace-dialog :which-key "trace dialog")
   "tc" '(sly-untrace-all :which-key "untrace all functions")))

(use-package smartparens
  ;; This package handles all prog-mode auto-pairing, so we don't need electric pair mode
  :ensure t
  :hook (((markdown-mode sly-mrepl-mode racket-mode prog-mode) . turn-on-smartparens-strict-mode))
  :init
  (progn
    (require 'smartparens-config)))

(use-package evil-cleverparens
  :ensure t
  :after smartparens
  :hook ((clojure-mode emacs-lisp-mode sly-mrepl-mode lisp-mode scheme-mode racket-mode) . evil-cleverparens-mode)
  :init
  (progn
    (require 'evil-cleverparens-text-objects)))

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
     :prefix ","
     "e"  '(es-execute-request-dwim :which-key "execute request")
     "u"  '(es-set-endpoint-url     :which-key "set endpoint url")
     "y"  '(es-copy-as              :which-key "copy as")))
  :mode
  ("\\.es$" . es-mode))

(use-package erc
  :ensure t
  :commands erc
  :init
  (progn
    (remove-hook 'erc-text-matched-hook 'erc-hide-fools) ;; Dim fools rather than hide entirely
    (setq erc-nick "Arcsech"
          erc-user-full-name "Gordon Brown"
          erc-pals  '()
          erc-fools '()
          erc-keywords '("\\belasticsearch\\b" "\\bADHD\\b" "\\badhd\\b" "\\bArcsech\\b" "\\bGordon\\b")
          erc-autojoin-channels-alist '(("irc.libera.chat"
                                         "#emacs"
                                         "#lisp"
                                         "#commonlisp"
                                         "#elasticsearch"
                                         "#java"
                                         "#scheme"
                                         "#racket"
                                         "#sbcl")))))

;; Disable backup files
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files
(setq create-lockfiles nil)  ; stop making .#lock files

;; Set GC threshold back down so that GC pauses don't take forever
(setq gc-cons-threshold (* 2 1024 1024))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages
   '(command-log-mode delight diminish evil-smartparens which-key use-package sly rainbow-delimiters racket-mode projectile markdown-mode magit helm general evil-collection evil-cleverparens es-mode doom-themes company-quickhelp-terminal adoc-mode ace-jump-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
