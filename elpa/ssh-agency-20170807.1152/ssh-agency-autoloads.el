;;; ssh-agency-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "ssh-agency" "ssh-agency.el" (22959 4632 0
;;;;;;  0))
;;; Generated autoloads from ssh-agency.el

(autoload 'ssh-agency-ensure "ssh-agency" "\
Start ssh-agent and add keys, as needed.

Intended to be added to `magit-credential-hook'.

\(fn)" nil nil)

(add-hook 'magit-credential-hook 'ssh-agency-ensure)

;;;***

;;;### (autoloads nil nil ("ssh-agency-pkg.el") (22959 4632 756000
;;;;;;  0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; ssh-agency-autoloads.el ends here