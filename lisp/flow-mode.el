;; @file flow-mode.el
;; @author Thomas Liu
;; @date Winter 2014
;; @brief Minor mode for org-table flowing.

;; (make-variable-buffer-local
;;  (defvar foo-count 0
;;    "Number of foos inserted into the current buffer."))

(defun org-table-insert-row-and-return (number)
  (interactive)
  (setq temp-column (current-column))
  (dotimes (bla number) (org-table-insert-row))
  (dotimes (bla (- number 1)) (org-return))
  (move-to-column temp-column)
  )

(defun org-table-conditional-insert-row-and-return (number)
  (interactive)
  (dotimes (bla number)
    (org-return)
    (setq temp-column (current-column))
    (if (not (string= (string (char-after)) " "))
      (org-table-insert-row)
      )
    (move-to-column temp-column)
    )
  (move-to-column temp-column)
  )

(defun insert-x-argument ()
  (interactive)
  (insert (read-string "Tag: "))
  (org-table-conditional-insert-row-and-return 1)
  (insert "-------------------x")
  (org-table-conditional-insert-row-and-return 1)
  (setq current-string (read-string "Cite or warrant (enter to finish): "))
  (while (not (string= current-string ""))
    (insert current-string)
    (org-table-conditional-insert-row-and-return 1)
    (setq current-string (read-string "Cite or warrant: "))
    )
  (org-table-conditional-insert-row-and-return 3)
 )

(defun insert-argument ()
  (interactive)
  (insert (read-string "Tag: "))
  (org-table-conditional-insert-row-and-return 1)
  (setq current-string (read-string "Cite or warrant (enter to finish): "))
  (while (not (string= current-string ""))
    (insert current-string)
    (org-table-conditional-insert-row-and-return 1)
    (setq current-string (read-string "Cite or warrant: "))
    )
  (org-table-conditional-insert-row-and-return 3)
 )

(defun insert-neg-flow ()
  (interactive)
  (insert "| <20>                 | <20>                 | <20>                 | <20>                 | <20>                 | <20>                 |
| 1NC                  | 2AC                  | Block                | 1AR                  | 2NR                  | 2AR                  |
|----------------------+----------------------+----------------------+----------------------+----------------------+----------------------|
|                      |                      |                      |                      |                      |                      |
|----------------------+----------------------+----------------------+----------------------+----------------------+----------------------|
")
  (previous-line 2)
  (forward-char 2)
  )

(defun insert-aff-flow ()
  (interactive)
  (insert "| <20>                 | <20>                 | <20>                 | <20>                 | <20>                 | <20>                 | <20>                 |
| 1AC                  | 1NC                  | 2AC                  | Block                | 1AR                  | 2NR                  | 2AR                  |
|----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------|
|                      |                      |                      |                      |                      |                      |                      |
|----------------------+----------------------+----------------------+----------------------+----------------------+----------------------+----------------------|
")
  (previous-line 2)
  (forward-char 2)
  )

(define-minor-mode flow-mode
  "Flowing"
  :lighter " flow"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c f") 'insert-aff-flow)
	    (define-key map (kbd "C-c n") 'insert-neg-flow)
	    (define-key map (kbd "C-c c") 'insert-argument)
	    (define-key map (kbd "C-c x") 'insert-x-argument)
	    ;; (define-key map (kbd "C-c i") 'insert-analytic)
            map))

(provide 'flow-mode)
