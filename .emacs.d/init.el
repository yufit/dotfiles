:;; -*- Mode: Emacs-Lisp ; Coding: utf-8; lexical-binding: t -*-

;;; load-pathを追加する関数（Emacs実践入門より）
(defun my:add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;;; load-pathに追加
(my:add-to-load-path "elisp" "conf" "public_repos" "elpa")

;; @init-loader
;;; 分割した設定ファイルを読み込む
(require 'init-loader)
(init-loader-load "~/.emacs.d/conf")

;;@linum
;;行番号はデフォルト表示しない
(require 'linum)
(setq linum-format "%3d")
;(global-linum-mode t)


;;TABの表示幅　
(setq-default tab-width 4)
;(seq-default indent-tabs-mode t)



;;@color-theme(Emacs built-in)
(add-to-list 'custom-theme-load-path
			 (concat user-emacs-directory  "elisp/replace-colorthemes"))
(load-theme 'charcoal-black  t t)
(enable-theme 'charcoal-black)
 

;;font設定(Source Code Pro)
(set-face-attribute 'default nil
					:family "Source Code Pro"
					:height 120)


;;現在行のハイライト設定
(defface my-hl-line-face
	;;背景色がdarkならば背景色を紺に
'((((class color) (background dark))
	 (:background "NavyBlue" t))
	;;背景色がlightならば背景色を緑に
	(((class color) (background light))
	 (:background "LightGoldenrodYello" t))
	(t (:bold t)))
	"hl-line's my face")

(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)

;;対応する括弧のハイライト
;; paren-mode:対応する括弧を強調して表示する
(setq show-paren-delay 0) ;表示までの秒数.初期値は0.125
(show-paren-mode t) ;有効化
;; parenのスタイル: expressionは括弧内も強調表示
(setq show-paren-style 'expression)
;;フェイスを変更する
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")



;; @auto-install
;; auto-installの設定
(when (require 'auto-install nil t)	; ←1●
  ;; 2●インストールディレクトリを設定する 初期値は ~/.emacs.d/auto-install/
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWikiに登録されているelisp の名前を取得する
  (auto-install-update-emacswiki-package-name t)
  ;; 必要であればプロキシの設定を行う
  ;; (setq url-proxy-services '(("http" . "localhost:8339")))
  ;; 3●install-elisp の関数を利用可能にする
  (auto-install-compatibility-setup)) ; 4●
;; ------------------------------------------------------------------------

;; @package
(when (require 'package nil t)
	;;パッケージリポジトリにMarmaladeと開発者運営のELPAを追加
	(add-to-list 'package-archives 
				 ;;	 '("melpa" . "http://melpa.milkbox.net/packages/") t)
				 '("melpa" . "http://melpa.org/packages/") t)
	(add-to-list 'package-archives 
				 '("marmalade" . "http://marmalade-repo.org/packages/"))
	(add-to-list 'package-archives
				 '("ELPA" . "http://tromey.com/elpa/"))
	(add-to-list 'package-archives
				 '("gnu" . "http://elpa.gnu.org/packages/"))
	;;インストールしたパッケージにロードパスを通して読み込
	(package-initialize))


;;@auto-complete
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories 
    "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))



;;@color-moccur
;; color-moccurの設定
(when (require 'color-moccur nil t)
  ;; M-oにoccur-by-moccurを割り当て
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索のとき除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  ;; Migemoを利用できる環境であればMigemoを使う
  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (setq moccur-use-migemo t)))

;;@moccur-edit
;; moccur-editの設定
(require 'moccur-edit nil t)
;; moccur-edit-finish-editと同時にファイルを保存する
(defadvice moccur-edit-change-file
	(after save-after-moccur-edit-buffer activate)
	(save-buffer))

;;@wgrep
;;wgrepの設定
(require 'wgrep nil t)

;;@undohist
;; undohistの設定
(when (require 'undohist nil t)
  (undohist-initialize))

;; undo-treeの設定
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))


;;@multi-term
;;multi-termの設定
(when (require 'multi-term nil t)
	;;使用するシェルの設定
	(setq muti-term-program "/usr/bin/bash"))


;;@redo+
;;redo+の設定
(when (require 'redo+ nil t)
	;;C-.にリドゥを割り当てる
	(global-set-key (kbd "C-.") 'redo))



;; ------------------------------------------------------------------------
;; @ shell
(require 'shell)
(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "bash.exe")
  (setq shell-command-switch "-c")
  (setq shell-file-name "bash.exe")
  
  ;; (M-! and M-| and compile.el)
  (setq shell-file-name "bash.exe")
  (modify-coding-system-alist 'process ".*sh\\.exe" 'utf-8)
  
  ;; shellモードの時の^M抑制
  (add-hook 'comint-output-filter-functions 'shell-strip-ctrl-m nil t)
  
  ;; shell-modeでの補完 (for drive letter)
  (setq shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@'`.,;()-")
  
  ;; エスケープシーケンス処理の設定
  (autoload 'ansi-color-for-comint-mode-on "ansi-color"
	"Set `ansi-color-for-comint-mode' to t." t)
  
  (setq shell-mode-hook
		(function
		 (lambda ()
		   
		   ;; シェルモードの入出力文字コード
		   (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix)
		   (set-buffer-file-coding-system    'utf-8-unix)
		   ))))

;; ------------------------------------------------------------------------

;; @elscreen
;; ElScreenのプレフィックスキーを変更する(初期値はC-z)
;; (setq elscreen-prefix-key (kbd "C-h"))
;; APEL非依存版 (Emacs 24の場合)
(when (>= emacs-major-version 24)
	(elscreen-start))

;; APEL依存版 (Emacs 23以下の場合)
(when (< emacs-major-version 24)
	(when (require 'elscreen nil t)
		;; C-z C-zをタイプした場合にデフォルトのC-zを利用する
		(if window-system
				(define-key elscreen-map (kbd "C-z") 'iconify-or-deiconify-frame)
			(define-ke elscreen-map (kbd "C-z") 'suspend-emacs))))

;;@howm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.7 メモ・情報整理                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P144-146 メモ書き・ToDo管理──howm
;; howmメモ保存の場所
(setq howm-directory (concat user-emacs-directory "howm"))
;; howm-menuの言語を日本語に
(setq howm-menu-lang 'ja)
;; howmメモを1日1ファイルにする
; (setq howm-file-name-format "%Y/%m/%Y-%m-%d.howm")
;; howm-modeを読み込む
(when (require 'howm-mode nil t)
  ;; C-c,,でhowm-menuを起動
  (define-key global-map (kbd "C-c ,,") 'howm-menu))
;; howmメモを保存と同時に閉じる
(defun howm-save-buffer-and-kill ()
  "howmメモを保存と同時に閉じます。"
  (interactive)
  (when (and (buffer-file-name)
             (string-match "\\.howm" (buffer-file-name)))
    (save-buffer)
    (kill-buffer nil)))

;; C-c C-cでメモの保存と同時にバッファを閉じる
(define-key howm-mode-map (kbd "C-c C-c") 'howm-save-buffer-and-kill)


;;@el-get
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)



;;@epc
(require 'epc)

;;@jedi
(require 'jedi)

;; (when (eq system-type 'windows-nt)
;;   (setq jedi:server-command
;; 		(list "C:/Python33/python.exe" jedi:server-script)))
;;
;; (when (eq system-type 'gnu/linux)
;;   (setq jedi:server-command
;; 		(list "/usr/bin/python3" jedi:server-script)))

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;;@python
;; (require 'python-mode)
(require 'python)
;; eldocは python.elでは動作せず
;; (add-hook 'python-mode-hook				
;;           '(lambda () (eldoc-mode 1)) t)
(setq python-shell-interpreter "ipython")
(setq python-shell-interpreter-args "--pylab")



;;@octave-mode
(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))

;;;@auto-complete-clang
(when (require 'auto-complete-clang))

(setq ac-clang-flags
      (mapcar (lambda (item)(concat "-I" item))
              (split-string
               "
 /usr/include/c++/4.9
 /usr/include/x86_64-linux-gnu/c++/4.9
 /usr/include/c++/4.9/backward
 /usr/lib/gcc/x86_64-linux-gnu/4.9/include
 /usr/local/include
 /usr/lib/gcc/x86_64-linux-gnu/4.9/include-fixed
 /usr/include/x86_64-linux-gnu
 /usr/include
"
               )))

(setq ac-auto-start t)
(setq ac-quick-help-delay 0.5)
;; (ac-set-trigger-key "TAB")
;; (define-key ac-mode-map  [(control tab)] 'auto-complete)
(define-key ac-mode-map  [(control tab)] 'auto-complete)
(defun my-ac-config ()
  (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
  ;; (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
  (add-hook 'css-mode-hook 'ac-css-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))
(defun my-ac-cc-mode-setup ()
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
;; ac-source-gtags
(my-ac-config)

;; @yasnippet
(when (require 'yasnippet)
  (yas-global-mode 1))


;; @helm
(when (require 'helm-config)
  (global-set-key (kbd "C-c h") 'helm-mini)
  (helm-mode 1))
;; @flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

;; @ctags
;; 「Emacs実践入門」より引用
(when (require 'ctags nil t))

;; debug
(setq debug-on-error t)
(set-coding-system-priority 'utf-8)

;; @smooth-scroll
;;; smooth-scroll
(require 'smooth-scroll)
(smooth-scroll-mode t)

;; @egg
;; git front-end tool
(when (executable-find "git")
  (require 'egg nil t))


;; @smart-mode-line + @powerline
;;引用元：　http://rubikitch.com/2014/08/16/smart-mode-line/

(require 'smart-mode-line)
;;; 桁番号も表示させる
(column-number-mode 1)
;;; 読み込み専用バッファは%で表示
(setq sml/read-only-char "%%")

;;; helm-modeとauto-complete-modeのモードライン表示を隠す
(setq sml/hidden-modes '(" Helm" " AC"))
(setq sml/extra-filler 0)
;;; sml/replacer-regexp-listはモードラインでのファイル名表示方法を制御
(add-to-list 'sml/replacer-regexp-list '("^.+/junk/[0-9]+/" ":J:") t)
;;; これを入れないとsmart-mode-lineを読み込むたびに
;;; Loading a theme can run Lisp code.  Really load? (y or n)
;;; と聞いてくる。
(setq sml/no-confirm-load-theme t)
(sml/apply-theme 'powerline)
(sml/setup)
;;; その他のtheme 一覧
;(sml/apply-theme 'respectful)
;(sml/apply-theme 'dark)
;(sml/apply-theme 'light)

;; @mozc
(when (eq system-type 'gnu/linux)
  (require 'mozc)
  (setq default-input-method "japanese-mozc")
  (set-language-environment "Japanese"))
;; setting coding-system
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)
;;


