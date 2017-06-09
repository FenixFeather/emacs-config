;;.emacs
;;Thomas Liu

(if (eq system-type 'windows-nt) (server-start))

(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/.emacs.d/lisp/ess-13.09-1/lisp")
(load "ess-site")

(setq scroll-preserve-screen-position t)

;;Windows specific
(add-hook 'LaTeX-mode-hook 'turn-on-reftex) 
(setq reftex-plug-into-AUCTeX t)
(setq-default ispell-program-name "aspell")

(defun load-ssh ()
  (interactive)
  (load-file "~/.ssh/agent.env.el")
  )

(setenv "SSH_ASKPASS" "git-gui--askpass")
(setq visible-bell 1)

;;;Windows backup
(setq version-control t ;; Use version numbers for backups.
      kept-new-versions 10 ;; Number of newest versions to keep.
      kept-old-versions 0 ;; Number of oldest versions to keep.
      delete-old-versions t ;; Don't ask to delete excess backup versions.
      backup-by-copying t) ;; Copy all files, don't rename them.
  ;; Default and per-save backups go here:
(setq backup-directory-alist '(("" . "~/.emacs.d/backup/per-save")))

(defun force-backup-of-buffer ()
  ;; Make a special "per session" backup at the first save of each
  ;; emacs session.
  (when (not buffer-backed-up)
    ;; Override the default parameters for per-session backups.
    (let ((backup-directory-alist '(("" . "~/.emacs.d/backup/per-session")))
	  (kept-new-versions 3))
      (backup-buffer)))
  ;; Make a "per save" backup on each save.  The first save results in
  ;; both a per-session and a per-save backup, to keep the numbering
  ;; of per-save backups consistent.
  (let ((buffer-backed-up nil))
    (backup-buffer)))

(add-hook 'before-save-hook  'force-backup-of-buffer)

;;Python
;;;Python mode
(add-to-list 'load-path "~/.emacs.d/python-mode")
(setq py-install-directory "~/.emacs.d/python-mode")
(require 'python-mode)

;; Web mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(setq web-mode-content-types-alist
  '(("jsx" . "\\.js[x]?\\'")))

;;Package
(require 'package)
(add-to-list 'package-archives
	     ;; '("melpa-stable" . "https://stable.melpa.org/packages/")
             ;; t)
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)
	     


;;Loading
(load-library "valgrind")

;; Company
(add-hook 'after-init-hook 'global-company-mode)
(eval-after-load "company"
  '(add-to-list 'company-backends 'company-anaconda))
(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'flycheck-mode)
(setq company-idle-delay 0)

(defun text-mode-hook-setup ()
  ;; make `company-backends' local is critcal
  ;; or else, you will have completion in every major mode, that's very annoying!
  (make-local-variable 'company-backends)

  ;; company-ispell is the plugin to complete words
  (add-to-list 'company-backends 'company-ispell)
  (setq company-ispell-available t)
  (setq company-ispell-dictionary (file-truename "~/.emacs.d/misc/english-words.txt")))

(add-hook 'text-mode-hook 'text-mode-hook-setup)
(add-hook 'org-mode-hook 'text-mode-hook-setup)

;;;Markdown mode
;;(require 'markdown-mode)
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;Color Scheme
;(load-library "color-theme")
;; (require 'color-theme)
;; (eval-after-load "color-theme"
;;   '(progn
;;      (color-theme-initialize)
;;      (color-theme-subtle-hacker)))
(load-theme 'zenburn t)

;;Options
(electric-pair-mode 1)
(show-paren-mode 1)
(require 'ido)
(ido-mode t)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;Templates
(require 'template)
(template-initialize)

(eval-after-load 'autoinsert
  '(define-auto-insert
     '("\\.\\(CC?\\|cc\\|cxx\\|cpp\\|c++\\)\\'" . "C++ skeleton")
     '("Short description: "
       "/*" \n
       (file-name-nondirectory (buffer-file-name))
       " -- " str \n
       " */" > \n \n
       "#include <iostream>" \n \n
       "using namespace std;" \n \n
       "main()" \n
       "{" \n
       > _ \n
       "}" > \n)))

(setq c-default-style "k&r"
          c-basic-offset 4)

(defun my-c++-mode-hook ()
  (c-set-style "k&r")        ; use my-style defined above
  (auto-fill-mode)         
  (c-toggle-auto-hungry-state 1)
  (electric-pair-mode 1))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;;C++ Stuff
  ; Create Header Guards with f12
(global-set-key [f12] 
  		'(lambda () 
  		   (interactive)
  		   (if (buffer-file-name)
  		       (let*
  			   ((fName (upcase (file-name-nondirectory (file-name-sans-extension buffer-file-name))))
  			    (ifDef (concat "#ifndef " fName "_H" "\n#define " fName "_H" "\n"))
  			    (begin (point-marker))
  			    )
  			 (progn
  					; If less then 5 characters are in the buffer, insert the class definition
  			   (if (< (- (point-max) (point-min)) 5 )
  			       (progn
  				 (insert "\nclass " (capitalize fName) "{\npublic:\n\nprivate:\n\n};\n")
  				 (goto-char (point-min))
  				 (next-line-nomark 3)
  				 (setq begin (point-marker))
  				 )
  			     )
  			   
  					;Insert the Header Guard
  			   (goto-char (point-min))
  			   (insert ifDef)
  			   (goto-char (point-max))
  			   (insert "\n#endif" " //" fName "_H")
  			   (goto-char begin))
  			 )
  		     ;else
  		     (message (concat "Buffer " (buffer-name) " must have a filename"))
  		     )
  		   )
  		)

(defun mp-add-cpp-keys()
  (local-set-key (kbd "C-.") 'insert-arrow)
  (local-set-key (kbd "C-c C-k" ) 'uncomment-region))

;; jsx Stuff
(require 'flycheck)
(add-hook 'web-mode-hook
          (lambda ()
            (when (equal web-mode-content-type "jsx")
              ;; enable flycheck
              (flycheck-mode))))

;; disable jshint since we prefer eslint checking
;; (setq-default flycheck-disabled-checkers
;;   (append flycheck-disabled-checkers
;;     '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
      (let ((web-mode-enable-part-face nil))
        ad-do-it)
    ad-do-it))

;;LaTeX Stuff
;; (setq TeX-auto-save t)
;; (setq TeX-parse-self t)
;; (setq TeX-save-query nil)
;; (setq TeX-PDF-mode t)
(add-hook 'doc-view-mode-hook 'auto-revert-mode)

;;Useful functions
(defun insert-arrow ()
  "Insert -> at cursor point."
  (interactive)
  (insert "->"))

(defun insert-for-loop (var end)
  "Inserts a generic for loop."
  (interactive "sEnter iterator variable name: \nsEnter end variable name: ")
  (insert (format "for (int %s = 0;%s < %s;%s++){}" var var end var))
  (backward-char 1)
  )

;;Keybindings
;;(global-set-key (kbd "C-.") 'insert-arrow)

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
    (global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
    (global-set-key (kbd "S-C-<down>") 'shrink-window)
    (global-set-key (kbd "S-C-<up>") 'enlarge-window)

(global-set-key (kbd "<f1>") 'shell)
(global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "M-[") 'ace-window)
(global-set-key (kbd "C-x o") 'ace-window)

(avy-setup-default)
(global-set-key (kbd "C-;") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "M-g g") 'avy-goto-line)
(global-set-key (kbd "C-M-g") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)
(global-set-key (kbd "M-g e") 'avy-goto-word-0)

;;Hooks
(add-hook 'c++-mode-hook 'mp-add-cpp-keys)
(add-hook 'org-mode-hook 'my-org-init)
(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'haskell-mode-hook 'haskell-indentation-mode)

;;Orgmode
(defun my-org-init ()
  (visual-line-mode 1))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-PDF-mode t)
 '(doc-view-continuous t)
 '(doc-view-dvipdf-program "dvipdfm")
 '(doc-view-ghostscript-program "gswin64c")
 '(doc-view-resolution 300)
 '(dtrt-indent-mode t nil (dtrt-indent))
 '(inferior-julia-program-name "julia")
 '(longlines-wrap-follows-window-size t)
 '(mediawiki-site-alist
   (quote
    (("Wikipedia" "http://en.wikipedia.org/w/" "FenixFeather" nil nil "Main Page"))))
 '(org-indent-mode-turns-off-org-adapt-indentation nil)
 '(org-journal-dir
   (if
       (eq system-type
	   (quote windows-nt))
       "C:/Users/Thomas/Documents/journal/" "~/Documents/journal"))
 '(org-startup-indented t)
 '(org-startup-truncated nil)
 '(preview-gs-command "GSWIN64C.EXE")
 '(reftex-cite-prompt-optional-args (quote maybe))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))
(put 'downcase-region 'disabled nil)
