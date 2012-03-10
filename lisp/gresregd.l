;;; -*- Mode: Lisp; Package: EDITOR -*-
;;;
;;; This file is part of xyzzy.
;;;

(provide "gresregd")

(require "gresreg")
(require "glob")

(in-package "editor")

(export '(gresreg-dialog *gresreg-directory-name-hook*))

(defvar *last-gresregd-regexp* "")
(defvar *last-gresregd-replacement* "")
(defvar *regexp-search* nil)
(defvar *understand-escape-sequences* nil)

(define-history-variable *gresreg-directory-history* nil)
(define-history-variable *gresreg-file-history* nil)
(define-history-variable *gresreg-case-fold-search* *case-fold-search*)
(define-history-variable *gresreg-word-search* *word-search*)
(define-history-variable *gresreg-regexp-search* *regexp-search*)
(define-history-variable *gresreg-subdir* nil)
(define-history-variable *gresreg-understand-escape-sequences* *understand-escape-sequences*)
(define-history-variable *gresreg-save-buffer* nil)

(defvar *gresreg-directory-name-hook* nil)

(defun gresreg-process (pattern replacement file dir query save)
  (let ((dirlist (if (consp dir) (glob-expand-list dir) (glob-expand dir))))
    (unless dirlist
      (error "~A~%�f�B���N�g����������܂���" dir))
    (when *gresreg-regexp-search*
      (setq pattern (compile-regexp pattern *gresreg-case-fold-search*)))
    (let ((count 0)
	  (*query-replace-map* *query-gresreg-map*)
	  (*case-fold-search* *gresreg-case-fold-search*)
	  (*word-search* *gresreg-word-search*))
      (declare (special *query-replace-map*))
      (when (catch 'quit
	      (save-excursion
		(glob-exec dirlist
			   :recursive *gresreg-subdir*
			   :file-only t :wild file
			   :absolute t
			   :callback
			   #'(lambda (f)
			       (message "Processing ~a..." f)
			       (let ((file-buffer (get-file-buffer f)))
				 (set-buffer (if file-buffer
						 file-buffer
					       (find-file-internal f nil nil nil t)))
				 (unless buffer-read-only
				   (save-excursion
				     (goto-char (point-min))
				     (let ((n (perform-replace pattern replacement
							       query
							       *gresreg-regexp-search*
							       nil t)))
				       (setq count (+ count n))
				       (when (and save (not (zerop n)))
					 (save-buffer)))))
				 (unless (or file-buffer
					     (buffer-modified-p (selected-buffer)))
				   (delete-buffer (selected-buffer))))))
		nil))
	(quit))
      (message "~D�̕������u�����܂���" count))))

(defun gresreg-dialog-1 (template dirlist)
  (let ((pattern (selection-start-end (start end)
		   (buffer-substring start end)))
	(no-dirs (if dirlist
		     (dolist (d dirlist ':disable)
		       (if (file-directory-p d)
			   (return))))))
    (multiple-value-bind (result data)
	(dialog-box template
		    (list (cons 'pat pattern)
			  (cons 'pat *minibuffer-search-string-history*)
			  (cons 'rep *minibuffer-search-string-history*)
			  (cons 'file (or (car *gresreg-file-history*) "*"))
			  (cons 'file *gresreg-file-history*)
			  (cons 'dir
				(if dirlist
				    nil
				  (let ((dir (and *gresreg-directory-name-hook*
						  (funcall *gresreg-directory-name-hook*))))
				    (if (stringp dir)
					dir
				      (default-directory)))))
			  (cons 'dir *gresreg-directory-history*)
			  (cons 'case-fold (cfs2dialog *gresreg-case-fold-search*))
			  (cons 'escseq *gresreg-understand-escape-sequences*)
			  (cons 'word *gresreg-word-search*)
			  (cons 'regexp *gresreg-regexp-search*)
			  (cons 'subdir *gresreg-subdir*)
			  (cons 'save *gresreg-save-buffer*))
		    `((word :disable (regexp))
		      (file :disable ,no-dirs)
		      (file-static :disable ,no-dirs)
		      (pat :non-null "�������������͂���" :enable (query all))
		      (ref :related dir :directory-name-dialog (:title "�Q��"))))
      (when result
	(let ((pattern (cdr (assoc 'pat data)))
	      (replacement (cdr (assoc 'rep data)))
	      (file (or (cdr (assoc 'file data)) "*"))
	      (dir (or dirlist (namestring (or (cdr (assoc 'dir data))
					       (default-directory))))))
	  (when pattern
	    (si:*activate-toplevel)
	    (add-history pattern '*minibuffer-search-string-history*)
	    (add-history replacement '*minibuffer-search-string-history*)
	    (or no-dirs (add-history file '*gresreg-file-history*))
	    (or dirlist (add-history dir '*gresreg-directory-history*))
	    (setq *gresreg-case-fold-search* (dialog2cfs (cdr (assoc 'case-fold data))))
	    (setq *gresreg-word-search* (cdr (assoc 'word data)))
	    (setq *gresreg-regexp-search* (cdr (assoc 'regexp data)))
	    (setq *gresreg-understand-escape-sequences* (cdr (assoc 'escseq data)))
	    (when *gresreg-understand-escape-sequences*
	      (setq pattern (decode-escape-sequence pattern *gresreg-regexp-search*))
	      (setq replacement (decode-escape-sequence replacement *gresreg-regexp-search*)))
	    (setq *gresreg-save-buffer* (cdr (assoc 'save data)))
	    (or no-dirs (setq *gresreg-subdir* (cdr (assoc 'subdir data))))
	    (gresreg-process pattern replacement
			     (split-string file #\; t " ")
			     (or dirlist dir)
			     (eq result 'query)
			     *gresreg-save-buffer*)))))))

(defun gresreg-dialog ()
  (interactive)
  (gresreg-dialog-1 '(dialog 0 0 271 159
		      (:caption "Gresreg")
		      (:font 9 "MS UI Gothic")
		      (:control
		       (:static nil "����(&S):" #x50020000 7 10 42 8)
		       (:combobox pat nil #x50210042 50 8 157 96)
		       (:static nil "�u��(&R):" #x50020000 7 27 42 8)
		       (:combobox rep nil #x50210042 50 25 157 96)
		       (:static nil "�t�@�C����(&F):" #x50020000 7 44 42 8)
		       (:combobox file nil #x50210042 50 42 157 96)
		       (:static nil "�f�B���N�g��(&D):" #x50020000 7 62 42 8)
		       (:combobox dir nil #x50210042 50 59 157 96)
		       (:button case-fold "�啶������������ʂ���(&C)" #x50010006 50 77 113 10)
		       (:button word "�P��P�ʂŌ�������(&W)" #x50010003 50 90 100 10)
		       (:button regexp "���K�\��(&E)" #x50010003 50 103 62 10)
		       (:button escseq "�G�X�P�[�v�V�[�P���X�𗝉�����(&Y)" #x50010003 50 116 105 10)
		       (:button subdir "���łɃT�u�f�B���N�g����(&U)" #x50010003 50 129 103 10)
		       (:button save "����ɃZ�[�u����(&V)" #x50010003 50 142 79 10)
		       (:button query "�m�F����(&Q)" #x50010001 214 7 50 14)
		       (:button all "�S�Ēu��(&A)" #x50010000 214 24 50 14)
		       (:button IDCANCEL "�L�����Z��" #x50010000 214 42 50 14)
		       (:button ref "�Q��(&N)..." #x50010000 214 59 50 14)))
		    nil))