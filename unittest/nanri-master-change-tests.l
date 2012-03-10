;;; -*- mode: lisp -*-

;; 2011-12-21  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* lisp : fix saving session file.
;; 	�q�X�g���t�@�C���Ɠ��l�ɃZ�b�V�����t�@�C�����������ݎ��� *print-length*
;; 	�Ȃǂ̉e�����󂯂Ȃ��悤�C���B
;; 
;; 	(progn
;; 	  (ed::write-session-file "0ssn.l")
;; 	  (let ((*print-circle* t)
;; 	        (*print-pretty* nil)
;; 	        (*print-length* 1)
;; 	        (*print-level* 1))
;; 	    (ed::write-session-file "1ssn.l")))
;; 
;; 	* lisp : fix saving history-file.
;; 	�q�X�g���t�@�C���������ݎ��� *print-length* �Ȃǂ̉e�����󂯂�̂��C���B
;; 
;; 	(progn
;; 	  (let ((*history-file-name* "0hist.l"))
;; 	    (ed::save-history-file))
;; 	  (let ((*history-file-name* "1hist.l")
;; 	        (*print-circle* t)
;; 	        (*print-pretty* nil)
;; 	        (*print-length* 1)
;; 	        (*print-level* 1))
;; 	    (ed::save-history-file)))
;; 

;; 2011-12-20  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix equalp for hash-table.
;; 	equalp �� hash-table ��n���Ƒ��l���Ԃ��Ă�������C���B
;; 	https://gist.github.com/1480046
;; 
(deftest equalp-for-hash-table ()
  (let ((a (make-hash-table))
        (b (make-hash-table)))
    (setf (gethash 1 a) "foo"
          (gethash 1 b) "foo")
    (equalp a b))
  => t)

;; 2011-06-17  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix sxhash.
;; 	sxhash �̒l�� equalp �p�̒l�ɂȂ��Ă��邪 equal �p�̒l�ɂȂ�悤�ɏC���B
;; 	(= (sxhash (list "ABC")) (sxhash (list "ABC"))) => t
;; 	(= (sxhash (list "abc")) (sxhash (list "ABC"))) => nil
;;
;; NOTE: ����͌�����I�b�P�[
; (deftest sxhash-fix-00 ()
;   (= (sxhash (list "ABC")) (sxhash (list "ABC")))
;   => t)
 
(deftest sxhash-fix-01 ()
  (= (sxhash (list "abc")) (sxhash (list "ABC")))
  => nil)

;; 2011-06-15  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* lisp : fix compiling lambda form.
;; 	lambda form ���R���p�C������ƃ��L�V�J���ϐ����Q�Ƃł��Ȃ��Ȃ��Ă�����
;; 	����C���B
;; 	https://gist.github.com/998414
;; 	https://gist.github.com/1000096
;; 
(deftest fix-compiling-lambda-form ()
  (compile-and-eval
    (let ((a 1))
      ((lambda () a))))
  => 1)

;; 2011-06-14  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* lisp : fix typo in lisp/compile.l.
;; 	�֐����̃~�X���C���B
;; 	https://twitter.com/#!/bowbow99/status/80332901014704128
;;
(deftest fix-typo-in-lisp/compile.l ()
  (progn
    (require "compile")
    (functionp (get 'ninth (find-symbol "optimize-form" :compiler)))))

;; 2011-01-30  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix abbreviate-display-string.
;; 	abbreviate-display-string �ŕK�v�ȏ�ɕ����񂪏ȗ�����邱�Ƃ�����̂�
;; 	�C���B�ȉ��̂悤�ɂȂ�ꍇ���������B
;; 	(abbreviate-display-string "D:/src/cmigemo-1.3c-MIT/src/wordlist.h" 40 t)
;; 	=> "D:/..."
;; 
;; 	string.cc �� 1109 �s�ځA�ȉ��̂悤�ɂȂ��Ă����B
;; 	  strcpy (le, "...");
;; 	  strcpy (le + 3, rb);
;; 	�͂��߂� strcpy �� '\0' ���������܂�A���̈ʒu�����傤�� rb �ƈ�v����
;; 	�Ƃ��ɔ��������B
;;
(deftest fix-abbreviate-display-string ()
  (abbreviate-display-string "D:/src/cmigemo-1.3c-MIT/src/wordlist.h" 40 t)
  => "D:/.../cmigemo-1.3c-MIT/src/wordlist.h")


;; 2011-01-21  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* lisp : fix pipe-command.
;; 	�uplink name@example.jp ls�v�� plink �𗘗p���悤�Ƃ����
;; 	�uUnable to read from standard input: �n���h���������ł��B�v
;; 	�Ƃ����G���[�ɂȂ�̂��C���B
;; 
;; 	execute-shell-command �̑������ɕ�����Enil�ȊO�̈�����n���ƃt�@�C��
;; 	������̃t�@�C�����J�����Ƃ���̂ŁA�G���[�ɂȂ��Ă����͗l�B
;; 
;; TODO: (?_?)

;; 	* src : fix wheel icon.
;; 	�Ȃ�ƂȂ��z�C�[���{�^�����N���b�N�����Ƃ��̃A�C�R�����������Ă݂��B
;; 
;; NOTE: �e�X�g�s�v���ƁB���������B

;; 	* src : fix multiple binding of special variables in let, let*.
;; 	http://d.hatena.ne.jp/bowbow99/20101127/1290818576
;; 	let �� let* �œ���̃X�y�V�����ϐ��ɑ΂��ĕ�����̑�����������Ƃ��̒l
;; 	�����������̂��C���B
;; 	�R���p�C�������Ƃ��̓���͏C���ł��Ă��Ȃ��B
;; 	(progn
;; 	  (defparameter *special* :global)
;; 	  (let ((*special* :local-1)
;; 	        (*special* :local-2))
;; 	    *special*))
;; 	=> :local-2
;; 
;; 	���L�V�J���Ȋ��ɂ͋t���ɓo�^�����̂ŁA�X�y�V�����ϐ��ɒl��ݒ肷��
;; 	�O�ɏ��������ɖ߂��Ă���B
;; 
(deftest fix-multiple-binding-of-special-variable-in-let/let*-00 ()
  (progn
    (defparameter *special* :global)
    (let ((*special* :local-1)
          (*special* :local-2))
      *special*))
  => :local-2)

(deftest fix-multiple-binding-of-special-variable-in-let/let*-01 ()
  (progn
    (defparameter *special* :global)
    (let* ((*special* :local-1)
           (*special* :local-2))
      *special*))
  => :local-2)

;; 2011-01-05  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix let, let*.
;; 	http://d.hatena.ne.jp/bowbow99/20101127/1290818576
;; 	�R���p�C�������Ƃ��͒l���ς�邱�Ƃ͂Ȃ����A�C���^�v���^�Ɠ��l�ɋt����
;; 	�l�����X�g�A����悤�ɏC���B
;;
;; NOTE: ����͌�������ĂȂ��i�����͕ς���ĂȂ��j�͂�
; (deftest fix-let/let*-multiple-bind-for-special-variable-in-compiled-code ()
;   (progn
;     (defparameter *special* :global)
;     (funcall
;      (compile nil
;               ;; NOTE: need empty lexenv to compile
;               (eval '(lambda ()
;                       (let ((*special* :local-1)
;                             (*special* :local-2))
;                         *special*)))))
;     *special*)
;   => :global)

;; 2011-01-04  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix special variables restore at the end of let, let*.
;; 	http://d.hatena.ne.jp/bowbow99/20101127/1290818576
;; 	let �� let* �œ���̃X�y�V�����ϐ��ɑ΂��ĕ�����̑��������ƁA�X�R�[
;; 	�v���O�ꂽ�Ƃ��ɒl������������Ă��܂��̂��C���B
;; 	(progn
;; 	  (defparameter *special* :global)
;; 	  (let ((*special* :local-1)
;; 	        (*special* :local-2))
;; 	    *special*)
;; 	  *special*)
;; 	=> :global
;; 
;; 	�l��ۑ�����Ƃ�(src/eval.cc 347�s�ڕӂ�)�Ƌt���ɒl�����X�g�A����悤��
;; 	�����B
;; 
(deftest fix-special-variables-restore-at-the-end-of-let/let*-00 ()
  (progn
    (defparameter *special* :global)
    (let ((*special* :local-1)
          (*special* :local-2))
      *special*)
    *special*)
  => :global)

(deftest fix-special-variables-restore-at-the-end-of-let/let*-01 ()
  (progn
    (defparameter *special* :global)
    (let* ((*special* :local-1)
           (*special* :local-2))
      *special*)
    *special*)
  => :global)

;; 2010-12-14  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix eol-code of zero size file.
;; 	�t�@�C���T�C�Y�� 0 �̂Ƃ��� (���m�ɂ͉��s���Ȃ��t�@�C���̂Ƃ���) ���s�R�[
;; 	�h����� CRLF �ɂȂ�̂��C���� *default-eol-code* �Ɋ�Â������s�R�[�h
;; 	�ɂȂ�悤�ɂ���B
;; 	xyzzy Part16 577
;;
(deftest fix-eol-code-of-zero-size-file ()
  (let ((name (make-temp-file-name))
        buffer)
    (with-open-file (out name :direction :output :if-does-not-exist :create))
    (unwind-protect
        (let ((*default-eol-code* *eol-lf*))
          (declare (special *default-eol-code*))
          (setq buffer (ed::find-file-internal name))
          (buffer-eol-code buffer))
      (delete-buffer buffer)))
  => 0)

;; 2010-12-13  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix DLL loading (hhctrl.ocx).
;; 	JVNVU#707943: Windows �v���O������ DLL �ǂݍ��݂ɐƎ㐫
;; 	http://jvn.jp/cert/JVNVU707943/index.html
;; 	�̏C���̑����B
;; 	hhctrl.ocx �̃��[�h�͐ÓI�ϐ��̏��������ɍs���邽�߁A��̏C���̌��ʂ�
;; 	�y�΂Ȃ��B����āA���[�h�̃^�C�~���O���֐� html-help �Ăяo�����ɕύX�B
;; 
;; 	* src : fix DLL loading.
;; 	JVNVU#707943: Windows �v���O������ DLL �ǂݍ��݂ɐƎ㐫
;; 	http://jvn.jp/cert/JVNVU707943/index.html
;; 	�̏C���B
;; 	�����A�[�J�C�o�� DLL �� WSOCK32.DLL �� ctl3d32.dll ���ΏہB
;; 	foreign:define-dll-entry (si:load-dll-module) �Ŏw�肷�� DLL ���Ώۂ����A
;; 	������̓t���p�X�Ŏw�肷��̂��]�܂������낤�B
;; 
;; TODO: �e�L�g�[�� dll ��ǂݍ���Ńe�X�g����H�H

;; 2010-12-12  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : update zlib(version 1.2.5).
;; 	zlib���o�[�W����1.2.5�ɃA�b�v�f�[�g�B
;; 
;; 	* lisp : support lzma and xz in filer.
;; 	lzma ����� xz �̈��k�ƓW�J���t�@�C�����痘�p�ł���悤�ɏC���B
;; 
;; 	* src : support lzma and xz.
;; 	tar32.dll Ver2.35 ���痘�p�ł���悤�ɂȂ��� lzma ����� xz �̈��k�ƓW
;; 	�J�ɑΉ��B
;;
;; TODO: �悭�킩���̂Ō�ŁB

;; 2010-12-11  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix hash-table.
;; 	rehash ���ɕs�v�ȃn�b�V���I�u�W�F�N�g�̃G���g���[�� NULL �ɐݒ肵�Ă���
;; 	�̂ŁA�T�C�Y�� 0 �ɐݒ肷��Bhash-table �̃}�[�N�t�F�[�Y(data.cc��613�s
;; 	�ڂ�����)�� NULL ���Q�Ƃ���̂�h�~����B
;; 	�ȉ��̂悤�� hash-table �� rehash ������� GC �̃^�C�~���O�ŗ����錻��
;; 	�������炭��������Ǝv����B
;; 	http://twitter.com/miyamuko/status/14229437114
;; 	http://d.hatena.ne.jp/knenet/20091223/1261578863
;; 
;; TODO: xyzzy ���N������}�N������

;; 2010-12-10  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix (cdr '#1='#1#) printing.
;; 	http://blog.bugyo.tk/lyrical/archives/610
;; 	http://blog.practical-scheme.net/gauche/20100609-curious-circular-list
;; 	�u(cdr '#1='#1#)�v�̕]�����ʂ̈󎚂ŃX�^�b�N�I�[�o�[�t���[����̂��C���B
;; 	'#1='#1#              => #1='#1#
;; 	(cdr '#1='#1#)        => #1=((quote . #1#))
;; 	(cdr '#1=(quote #1#)) => #1=((quote . #1#))
;; 	(cdr '#1=(q #1#))     => #1=((q . #1#))
;;
;; FIXME: handler-case �ł̓X�^�b�N�I�[�o�[�t���[���~�߂�ꂸ�e�X�g���s���N���b�V�����Ă܂�
;; FIXME: �茳�� nanri-master ��������Ƃ����������̂��Ɓu�v���I�ȗ�O�v������ xyzzy ���̂�
;; �����Ă��܂�
; (deftest |fix (cdr '#1='#1#) printing| ()
;   (write (cdr '#1='#1#) :circle t)
;   >> #1=((quote . #1#))
;   => #2=((quote . #2#)))

;; 2010-12-01  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix macroexpand.
;; 	http://twitter.com/bowbow99/status/9887141152694272
;; 	��Ԗڂ̖߂�l���Ԃ��Ă��Ȃ������̂��C���B
;; 	(macroexpand '(push 1 x))
;; 	=> (setq x (cons 1 x))
;; 	=> t
;; 	(macroexpand '(setq x (cons 1 x)))
;; 	=> (setq x (cons 1 x))
;; 	=> nil
;; 
(deftest fix-macroexpand-00 ()
  (macroexpand '(push 1 x))
  => (setq x (cons 1 x))
  => t)

(deftest fix-macroexpand-01 ()
  (macroexpand '(setq x (cons 1 x)))
  => (setq x (cons 1 x))
  => nil)

;; 	* src : fix flet, labels, macrolet.
;; 	http://twitter.com/bowbow99/status/8011887295856640
;; 	�����̃`�F�b�N���������������̂��C���B
;; 	(flet () 3)     => 3
;; 	(flet ())       => nil
;; 	(labels () 3)   => 3
;; 	(labels ())     => nil
;; 	(macrolet () 3) => 3
;; 	(macrolet ())   => nil
;; 
(deftest fix-flet/labels/macrolet-00 ()
  (flet ()) => nil)

(deftest fix-flet/labels/macrolet-01 ()
  (labels ()) => nil)

(deftest fix-flet/labels/macrolet-02 ()
  (macrolet ()) => nil)

;; 	* src : add "listp" Macro.
;; 	�I�u�W�F�N�g�� cons �ł���A���� nil �ł��邩�ǂ������ׂ� listp �}�N��
;; 	��ǉ��B
;; 

;; 2010-11-09  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix type-check in list-length.
;; 	http://twitter.com/bowbow99/status/1742537278623744
;; 	(list-length :foo)
;; 	-> �s���ȃf�[�^�^�ł�: :foo: list
;; 	(list-length '(a . b))
;; 	-> �s���ȃf�[�^�^�ł�: b: list
;; 
;; 	������dotted list��n�����Ƃ��̃G���[���b�Z�[�W�����܂��������A
;; 	�Ƃ肠�������̂܂܁B
;; 
(deftest fix-type-check-in-list-length-00 ()
  (list-length :foo)
  !! type-error)

(deftest fix-type-check-in-list-length-01 ()
  (list-length '(a . b))
  !! type-error)

;; 	* src : fix nthcdr given dotted list.
;; 	http://twitter.com/bowbow99/status/1746294087352320
;; 	(nthcdr 0 '()) => nil
;; 	(nthcdr 3 '()) => nil
;; 	(nthcdr 0 '(a b c)) => (a b c)
;; 	(nthcdr 2 '(a b c)) => (c)
;; 	(nthcdr 4 '(a b c)) => nil
;; 	(nthcdr 1 '(0 . 1)) => 1
;; 	(nthcdr 3 '(0 . 1)) => nil
;; 
;; 	�Ō�̃P�[�X�̓G���[�ɂ��ׂ������ǁA�Ƃ肠�������̂܂܁B
;;

;; NOTE: 05 �ȊO�͌����炿���Ɠ���
; (deftest fix-nthcdr-given-dotted-list-00 ()
;   (nthcdr 0 '()) => nil)

; (deftest fix-nthcdr-given-dotted-list-01 ()
;   (nthcdr 3 '()) => nil)

; (deftest fix-nthcdr-given-dotted-list-02 ()
;   (nthcdr 0 '(a b c)) => (a b c))

; (deftest fix-nthcdr-given-dotted-list-03 ()
;   (nthcdr 2 '(a b c)) => (c))

; (deftest fix-nthcdr-given-dotted-list-04 ()
;   (nthcdr 4 '(a b c)) => nil)

(deftest fix-nthcdr-given-dotted-list-05 ()
  (nthcdr 1 '(0 . 1)) => 1)

; (deftest fix-nthcdr-given-dotted-list-06 ()
;   (nthcdr 3 '(0 . 1)) => nil)


;; 	* src : fix single-float-epsilon, single-float-negative-epsilon.
;; 	http://twitter.com/TwilightClover/status/26251344464
;; 	http://gist.github.com/608561
;; 	http://gist.github.com/608467
;; 	(dolist (sym '((double-float-epsilon t)
;; 	               (double-float-negative-epsilon nil)
;; 	               (long-float-epsilon t)
;; 	               (long-float-negative-epsilon nil)
;; 	               (short-float-epsilon t)
;; 	               (short-float-negative-epsilon nil)
;; 	               (single-float-epsilon t)
;; 	               (single-float-negative-epsilon nil)))
;; 	  (let ((epsilon (symbol-value (car sym)))
;; 	        (positive (cadr sym)))
;; 	    (format t "~30S = ~@30S, test = ~S~%"
;; 	            (car sym)
;; 	            epsilon
;; 	            (if positive
;; 	                (not (= (float 1 epsilon) (+ (float 1 epsilon) epsilon)))
;; 	              (not (= (float 1 epsilon) (- (float 1 epsilon) epsilon)))))
;; 	    ))
;; 	double-float-epsilon           =          2.220446049250313d-16, test = t
;; 	double-float-negative-epsilon  =          1.110223024625157d-16, test = t
;; 	long-float-epsilon             =          2.220446049250313d-16, test = t
;; 	long-float-negative-epsilon    =          1.110223024625157d-16, test = t
;; 	short-float-epsilon            =                    1.192093e-7, test = t
;; 	short-float-negative-epsilon   =                    5.960464e-8, test = t
;; 	single-float-epsilon           =                    1.192093e-7, test = t
;; 	single-float-negative-epsilon  =                    5.960464e-8, test = t
;; 	nil
;; 
(deftest fix-single-float-eplilon ()
  (dolist (sym '((double-float-epsilon t)
                 (double-float-negative-epsilon nil)
                 (long-float-epsilon t)
                 (long-float-negative-epsilon nil)
                 (short-float-epsilon t)
                 (short-float-negative-epsilon nil)
                 (single-float-epsilon t)
                 (single-float-negative-epsilon nil)))
    (let ((epsilon (symbol-value (car sym)))
          (positive (cadr sym)))
      (format t "~30S = ~@30S, test = ~S~%"
              (car sym)
              epsilon
              (if positive
                  (not (= (float 1 epsilon) (+ (float 1 epsilon) epsilon)))
                (not (= (float 1 epsilon) (- (float 1 epsilon) epsilon)))))
      ))
  >> double-float-epsilon           =          2.220446049250313d-16, test = t
  >> double-float-negative-epsilon  =          1.110223024625157d-16, test = t
  >> long-float-epsilon             =          2.220446049250313d-16, test = t
  >> long-float-negative-epsilon    =          1.110223024625157d-16, test = t
  >> short-float-epsilon            =                    1.192093e-7, test = t
  >> short-float-negative-epsilon   =                    5.960464e-8, test = t
  >> single-float-epsilon           =                    1.192093e-7, test = t
  >> single-float-negative-epsilon  =                    5.960464e-8, test = t
  >> 
  => nil
  )

;; 2010-09-30  MIYAMUKO Katsuyuki  <miyamuko@gmail.com>
;; 
;; 	* src : add deleted-window-p
;; 	�폜���ꂽ Window �Ȃ� t ��Ԃ��B
;; 	deleted-buffer-p �� Window �o�[�W�����B
;; 	http://twitter.com/bowbow99/status/25935896653
;;

;; NOTE: ���O�ŗp�ӂ��Ă��ꍇ pass ���Ă��܂��B
(deftest add-deleted-window-p-00 ()
  (fboundp 'deleted-window-p))

;; NOTE: ���O�ŗp�ӂ��Ă��ꍇ pass ���Ă��܂��B
(deftest add-deleted-window-p-01 ()
  (let ((current (selected-window))
        (new     (save-window-excursion
                   (split-window -1)
                   (selected-window))))
    (deleted-window-p new)))

(deftest add-deleted-window-p-02 ()
  (si:*builtin-function-p (symbol-function 'deleted-window-p)))

;; 2010-09-12  MIYAMUKO Katsuyuki  <miyamuko@gmail.com>
;; 
;; 	* src : add optional value parameter to si:putenv.
;; 	���������ϐ����ƃI�v�V���i���Ȓl���Ƃ�悤�ɕύX�B
;; 	�l���ȗ������ꍇ�� nil ���w�肵���ꍇ�͊��ϐ����폜����B
;; 	�߂�l�͊��ϐ��̐ݒ�ɐ��������ꍇ�͐ݒ肵���l��Ԃ��A
;; 	���ϐ����폜�����ꍇ�܂��͐ݒ�Ɏ��s�����ꍇ�� nil ��Ԃ��悤�ɕύX�B
;; 	(si:putenv "FOO" "bar")
;; 	=> "bar"
;; 	(si:putenv "FOO")
;; 	=> nil
;; 	(si:putenv "=FOO" "bar")
;; 	=> nil
;; 
(deftest add-putenv-00 ()
  (multiple-value-bind (sym class)
      (find-symbol "putenv" :system)
    class)
  => :external)

(deftest add-putend-01 ()
  (fboundp (find-symbol "putenv" :system)))

(deftest add-putenv-02 ()
  (funcall (find-symbol "putenv" :system) "FOO" "bar")
  => "bar")

(deftest add-putenv-03 ()
  (progn
    (funcall (find-symbol "putenv" :system) "FOO" "baz")
    (si:getenv "FOO"))
  => "baz")

(deftest add-putenv-04 ()
  (values
   (funcall (find-symbol "putenv" :system) "FOO" nil)
   (si:getenv "FOO"))
  => nil
  => nil)

;; 2010-09-11  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : remove redefinition.
;; 	Microsoft Visual C++ 2010 �ł� wingdi.h ���C���N���[�h����āA
;; 	tagWCRANGE �� tagGLYPHSET ����`�����悤�Ȃ̂� gen-fontrange.cc �ł�
;; 	��`���폜�B
;; 	�Ƃ肠����VC2010�ł̂ݍ폜�B
;; 

;; 	* src : remove pragma optimize.
;; 	�uinternal compiler error�v�΍�Ƃ̃R�����g�����邪�AMicrosoft Visual
;; 	C++ 2010 �ł̓G���[���������Ȃ��̂ō폜�B
;; 	�Ƃ肠����VC2010�ł̂ݍ폜�B
;; 

;; 	* src : add si:putenv.
;; 	si:putenv ��ǉ��B
;; 	via http://d.hatena.ne.jp/miyamuko/20100910/xyzzy_putenv
;; 
;; NOTE: ���̌�ύX����Ă��ł������Ńe�X�g

;; 2010-08-31  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix call-process.
;; 	call-process�̕W�����́E�W���o�͓��̎w�肪���܂��ݒ肳��Ȃ����ۂ�����
;; 	�Ă����̂��C���B
;;
;; FIXME: command prompt ����u�\�������̂�����
;; FIXME: 0.2.2.235 �� pass ���Ă��܂��B�ǂ������ꍇ�ɏ�肭�ݒ肳��Ȃ��̂��킩���B
; (deftest fix-call-process-input/output ()
;   (labels ((make-file (name &optional contents)
;              (with-open-file (out name
;                                   :direction :output
;                                   :if-does-not-exist :create)
;                (when (princ contents out)))
;              name))
;     (let ((infile (make-file (make-temp-file-name) "hello"))
;           (outfile (make-file (make-temp-file-name) "")))
;       (call-process "sort" :input infile :output outfile :wait t)
;       (unwind-protect
;           (with-open-file (in outfile :direction :input)
;             (read in))
;         (delete-file infile)
;         (delete-file outfile))))
;   => hello
;   )

;; 2010-07-14  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix format "~T".
;; 	�u~colnum,colincT�v�̂Ƃ��A�ucolnum+k*colinc�v�𖞂����ŏ��̐��̐���k��
;; 	�������߂�悤�ɏC���B
;; 	(format nil "~0,1T")
;; 	=> " "
;; 
(deftest fix-format-T ()
  (format t "~0,1Tx")
  >>  x
  => nil)

;; 	* src : fox format "~VT" in the case of being provided '() as a prefix parameter.
;; 	V�Ɉ����Ƃ���nil��n�����Ƃ��̓�����C���B
;; 	(format t "~VA" nil 'x)
;; 	== (format t "~A" 'x)
;; 
(deftest fix-format-VT ()
  (format t "~VA" nil 'x)
  >> x
  => nil)

;; 	* src : fix for VC2010.
;; 	Microsoft Visual C++ 2010 �ł̃r���h�p�ɏC���B
;; 	Makefile�̏C���̂݁B
;; 

;; 2010-04-04  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : add repl.
;; 	�R�}���h�v�����v�g��\������o�[�W����xyzzyrpl.exe���쐬�ł���悤�ɂ�
;; 	���B�unmake repl�v�ō쐬�ł���B
;; 
;; 	;;; �Ȉ�REPL
;; 	(defun repl ()
;; 	  (interactive)
;; 	  (let ((*standard-input* *terminal-io*)
;; 	        (*standard-output* *terminal-io*))
;; 	    (loop
;; 	      (format t "~%> ")
;; 	      (format t "~A" (eval (read *standard-input*))))))
;; 
;; NOTE: merge ����ĂȂ��ixyzzy Part17 >>593 http://toro.2ch.net/test/read.cgi/win/1303662374/593�j

;; 2010-03-01  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix "*load-pathname*" initialization.
;; 	�_���v�쐬���Ƀ��[�h�����t�@�C���������̂܂܃_���v�t�@�C���ɕۑ������
;; 	�悤�Ȃ̂ŁA�N�����ɂ�����������悤�ɏC���B
;; 
;; TODO: xyzzy ���N������}�N������


;; 	* src : fix format "~F".
;; 	format��"~F"�̑��p�����[�^w���w�肵�Ȃ��Ƒ�O�p�����[�^k���@�\���Ȃ�
;; 	�̂��C���B
;; 
;; 	(dotimes (i 10)
;; 	  (format t "~,,VF~%" i pi))
;; 	3.141592653589793
;; 	31.41592653589793
;; 	314.1592653589793
;; 	3141.592653589793
;; 	31415.92653589793
;; 	314159.2653589793
;; 	3141592.653589793
;; 	31415926.53589793
;; 	314159265.3589793
;; 	3141592653.589793
;; 	nil
;; 
;; 	(do ((i -9 (1+ i)))
;; 	    ((> i 9))
;; 	  (format t "~,,VF~%" i pi))
;; 	-0.000000009
;; 	-0.00000008
;; 	-0.0000007
;; 	-0.000006
;; 	-0.00005
;; 	-0.0004
;; 	-0.003
;; 	-0.02
;; 	-0.1
;; 	0.0
;; 	10.0
;; 	200.0
;; 	3000.0
;; 	40000.0
;; 	500000.0
;; 	6000000.0
;; 	70000000.0
;; 	800000000.0
;; 	9000000000.0
;; 	nil
;;
(deftest fix-format-F-01 ()
  (dotimes (i 10)
    (format t "~,,VF~%" i pi))
  >> 3.141592653589793
  >> 31.41592653589793
  >> 314.1592653589793
  >> 3141.592653589793
  >> 31415.92653589793
  >> 314159.2653589793
  >> 3141592.653589793
  >> 31415926.53589793
  >> 314159265.3589793
  >> 3141592653.589793
  >> 
  => nil
  )


(deftest fix-format-F-02 ()
  (do ((i -9 (1+ i)))
      ((> i 9))
    (format t "~,,VF~%" i i))
  >> -0.000000009
  >> -0.00000008
  >> -0.0000007
  >> -0.000006
  >> -0.00005
  >> -0.0004
  >> -0.003
  >> -0.02
  >> -0.1
  >> 0.0
  >> 10.0
  >> 200.0
  >> 3000.0
  >> 40000.0
  >> 500000.0
  >> 6000000.0
  >> 70000000.0
  >> 800000000.0
  >> 9000000000.0
  >> 
  => nil
  )

;; 2010-02-21  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix applyhook.
;; 	applyhook, *applyhook* �����[�J���֐��ɑΉ��������B
;; 	call_applyhook�̑������ɃN���[�W����n���悤�ɕύX�����B
;; 
(deftest fix-applyhook-00 ()
  (let ((*applyhook* (lambda (fn args)
                       (functionp fn))))
    (car 1)))

;; 	* src : add "*read-eval*".
;; 	�X�y�V�����ϐ�*read-eval*���@�\����悤�ɂ����B
;; 	*read-eval*�̏o�͂ւ̉e���̗������������B
;; 	*read-eval*��nil�̏ꍇ��encoding��unreadable-object�Ƃ��ďo�͂���悤��
;; 	�Ă��邪�A���M�Ȃ��B
;; 
(deftest add-*read-eval*-00 ()
  (si:*specialp '*read-eval*))

(deftest add-*read-eval*-01 ()
  (let ((*read-eval* nil))
    (read-from-string "#.(+ 1 2)"))
  !! reader-error)

;; TODO: �o�͂ւ̉e���H

;; 2010-01-23  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix for VC2008.
;; 	Microsoft Visual C++ 2008 �ł̃r���h�p�ɏC���B
;; 	http://xyzzy.s53.xrea.com/wiki/index.php?Memo%2F%A5%BD%A1%BC%A5%B9%A4%AB%A4%E9%A5%D3%A5%EB%A5%C9%A4%B7%A4%C6%A4%DF%A4%EB3
;; 
;; NOTE: �e�X�g�͂����Ǝv�����ǁAcommit ��������Ȃ��B

;; 	* src : add get-buffer-colors.
;; 	�֐�get-buffer-colors��ǉ��B
;; 	set-buffer-colors�Ƒ΂ƂȂ錻�݂̃o�b�t�@�̐F�ݒ���擾����֐��B
;;
;; NOTE: ����������Ƃ����ƃe�X�g���������ǂ��Ǝv���܂��B�B�B
(deftest add-get-buffer-colors ()
  (fboundp 'get-buffer-colors))

;; 2010-01-22  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix listen.
;; 	EOF�̂Ƃ���nil��Ԃ��悤�ɏC���B
;; 	������͈͂Ƃ������Ƃ�string-stream��file-stream�����B
;; 
(deftest fix-listen-for-string-stream ()
  (let ((stream (make-string-input-stream "")))
    (listen stream))
  => nil)

(deftest fix-listen-for-file-stream ()
  (let* ((file (make-temp-file-name))
         (buffer (ed::find-file-internal file)))
    (save-excursion
      (with-set-buffer
        (set-buffer buffer)
        (save-buffer)))
    (unwind-protect
        (with-open-file (in file :direction :input)
          (listen in))
      (delete-buffer buffer)))
  => nil)

;; 2010-01-11  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix save-window-excursion.
;; 	(save-window-excursion (values 1 2 3))
;; 	�Ő��������l���Ԃ�Ȃ��ꍇ������̂��C���B
;; 	xyzzy Part11 8 http://www.bookshelf.jp/2ch/win/1085301777.html
;;
;; FIXME: ���C���ł����������l���Ԃ邱�Ƃ�����݂����Ȃ̂ŁA���̎��� pass ���Ă��܂�
(deftest fix-save-window-excursion ()
  (save-window-excursion (values 1 2 3))
  => 1
  => 2
  => 3)

;; 	WindowConfiguration�̃f�X�g���N�^����Lisp�̃R�[�h�����s�����̂ŁA
;; 	WindowConfiguration�̃f�X�g���N�^�����s�������ƂŁA���l�����̒l�ɖ�
;; 	���K�v������B
;; 
;; 	* lisp : fix long-operation.
;; 	long-operation�̖߂�l��prog1�����ɂȂ��Ă���̂�progn�����ɂȂ��
;; 	���ɏC���B
;; 	xyzzy Part10 470
;; 
(deftest fix-long-operation ()
  (long-operation
    1
    2)
  => 2)

;; 2009-12-26  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : update zlib.
;; 	zlib���o�[�W����1.2.3�ɃA�b�v�f�[�g�B
;; 
;; FIXME: �e�X�g������@���v�����Ȃ��A�Ƃ������e�X�g�K�v�Ȃ񂾂낤��

;; 2009-12-17  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* lisp : modify tags-setup-buffer.
;; 	XTAGS�t�@�C����T���ʒu�����X�ύX�B
;; 
;; NOTE: merge ����ĂȂ��ixyzzy Part17 >>593 http://toro.2ch.net/test/read.cgi/win/1303662374/593�j

;; 	* lisp : modify edict-lookup-word.
;; 	�����������P����J�[�\���̑O���ɕύX�B
;; 
;; NOTE: merge ����ĂȂ��ixyzzy Part17 >>593 http://toro.2ch.net/test/read.cgi/win/1303662374/593�j

;; 	* lisp : modify start point in buffer-menu.
;; 	buffer-menu�����s�����Ƃ��̃J�[�\���ʒu�����݂̃o�b�t�@�̈ʒu�ɕύX�B
;;
;; NOTE: merge ����ĂȂ��ixyzzy Part17 >>593 http://toro.2ch.net/test/read.cgi/win/1303662374/593�j
; (deftest modify-start-point-in-buffer-menu ()
;   (let ((buffers '()))
;     (do ((i 0 (1+ i)))
;         ((>= i 4))
;       (push (create-new-buffer "*Test Example*") buffers))
;     (prog1
;         (save-window-excursion
;           (with-set-buffer
;             (set-buffer (car buffers))
;             (buffer-menu)
;             (and (bolp)
;                  (looking-at "^\\."))))
;       (dolist (b buffers)
;         (delete-buffer b)))))

;; 	* src : add key parameter ":show" to make-process.
;; 	make-process�ɃL�[�p�����[�^ :show ��ǉ�����B
;; 	http://xyzzy.s53.xrea.com/wiki/index.php?patch%2F12
;; 
;; FIXME: �e�X�g������@���v�����Ȃ�

;; 2009-12-16  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : support IMR_DOCUMENTFEED.
;; 	via http://fixdap.com/p/xyzzy/7376/
;; 	�ȉ��œ�����m�F�B
;; 	�������@�@�@�@�@����������
;; 	�z���@�@�@�@�@�@����
;; 	�Ԃ��@�@�@�@�@�@�t
;; 	���Ԃ��@�@�@�@�@
;; 
;; FIXME: �e�X�g������@���v�����Ȃ�

;; 	* src : fix set-buffer-modified-p.
;; 	(set-buffer-modified-p nil) ���������ɈȑO�X�V�Ȃ���Ԃ������_���X
;; 	�V������Ԃ̂܂܂Ȃ̂��C���B
;;
;; TODO: �ύX�̓��e���悭�킩���̂Ō��
; (deftest fix-set-buffer-modified-p ()
;   (let ((buffer (create-new-buffer "*Example*")))
;     (set-buffer-modified-p nil buffer)
;     (buffer-modified-p buffer))
;   => nil)

;; 	* src : fix inverse-cursor-line.
;; 	(setq inverse-cursor-line t)
;; 	�̏�Ԃɂ���ƍs�J�[�\���Ɛ܂�Ԃ����̌�_�����]�����܂܎c���Ă���
;; 	���̂��C���B
;;
;; FIXME: �e�X�g������@���v�����Ȃ�

;; 2009-12-10  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : fix format "~n@A".
;; 	http://d.hatena.ne.jp/bowbow99/20090829/1251547986
;;
;; NOTE: merge ����ĂȂ����i����͊O�����̂����j
(deftest fix-format-n@A ()
  (format t "~10@A" "foo")
  >>        foo
  => nil)

;; 2009-12-09  NANRI Masaoki  <southly@gmail.com>
;; 
;; 	* src : add "*brackets-is-wildcard-character*" to history-variable.
;; 	���ʐݒ�́u[...]�̓��C���h�J�[�h�v�̐ݒ肪�ۑ�����Ȃ��̂ŁA�Ή���
;; 	��ϐ����q�X�g���ɒǉ��B
;; 
(deftest add-*brackets-is-wildcard-character*-to-history-variable ()
  (member '*brackets-is-wildcard-character* ed::*history-variable-list*))

;; 	* src : fix dump hash-table.
;; 	�V���{�����L�[�̃n�b�V���e�[�u�����_���v�t�@�C���ɓ��ꂽ�ꍇ�A
;; 	gethash�Œl���Ƃ�Ȃ���肪�������B�������Amaphash�őS�v�f���擾��
;; 	�邱�Ƃ͂ł����B
;; 	---- $XYZZY/site-lisp/siteinit.l �̓��e
;; 	(defparameter *hash* (make-hash-table))
;; 	(dolist (i '((aaa . abab) (bbb . bcbc) (ccc . cdcd)))
;; 	  (setf (gethash (car i) *hash*) (cdr i)))
;; 	---- �_���v�t�@�C�������[�h�������Ƃɕ]��
;; 	(gethash 'aaa *hash*)
;; 	=>nil ; �{���� abab
;; 	=>nil ;        t
;; 
;; 	(maphash #'(lambda (key val) (format t "~S: ~S~%" key val)) *hash*)
;; 	aaa: abab
;; 	bbb: bcbc
;; 	ccc: cdcd
;; 	=>nil
;; 	----
;; 	�V���{���̃n�b�V���l�̓I�u�W�F�N�g�̃A�h���X�����Ɍv�Z���Ă��邪�A
;; 	�_���v�t�@�C���쐬���ƃ_���v�t�@�C�����[�h��ł̓V���{���I�u�W�F�N
;; 	�g�̃A�h���X���قȂ�A����̃n�b�V���l�ɂȂ�Ȃ��̂������B
;; 
;; 	�_���v�t�@�C�������[�h�������Ƃ�rehash����悤�ɏC���B
;; 
;; 	* lisp : fix defpackage.
;; 	defpackage�}�N����:export�I�v�V�������w��ł��Ȃ��s����C���B
;; 	[xyzzy:09241]
;; 


;; 	* lisp : fix shell-alternate-send-input.
;; 	http://xyzzy.s53.xrea.com/wiki/index.php?patch%2F15
;; 

(require "shell")

(deftest fix-shell-alternate-send-input ()
  (labels ((mocked-shell-send-input ()
             *shell-ret*))
    (let ((original-shell-send-input #'shell-send-input))
      (setf (symbol-function 'shell-send-input) #'mocked-shell-send-input)
      (unwind-protect
          (let ((*shell-ret* "\n"))
            (shell-alternate-send-input))
        (setf (symbol-function 'shell-send-input) original-shell-send-input))))
  => "\r")

;; 	* lisp : fix calendar.
;; 	�J�����_�[�̏j�������s�@�ɂ��킹��B
;; 	[xyzzy:09224]
;; 
(require "calendar")

(defun calendar-japanese-holiday-spec (year month day)
  (let ((v (make-vector 33)))
    (ed::calendar-japanese-holiday year month v)
    (svref v day)))

(deftest fix-calendar-01 ()
  (calendar-japanese-holiday-spec 2007 4 29)
  => "���a�̓�")

(deftest fix-calendar-02 ()
  (calendar-japanese-holiday-spec 2007 5 4)
  => "�݂ǂ�̓�")

(deftest fix-calendar-03 ()
  (calendar-japanese-holiday-spec 2008 5 6)
  => "�U�֋x��")


;; 	* lisp : fix typo in lisp/timestmp.l.
;; 	�R�����g��typo���C���B
;; 	[xyzzy:09158]
;; 
;; 	* lisp : fix typo in lisp/encoding.l.
;; 	provide��typo���C���B
;; 	[xyzzy:09158]
;;
(deftest fix-typo-in-lisp/encoding.l ()
  (modulep "encoding"))

;; 	* lisp : fix typo in lisp/css-mode.l.
;; 	provide��typo���C���B
;; 	[xyzzy:09158]
;;
(deftest fix-typo-in-lisp/css-mode.l ()
  (progn
    (require "css-mode")
    (and (modulep "css-mode")
         (not (modulep "cssmode")))))

;; 	* lisp : fix typo in lisp/builtin.l.
;; 	��Ɉ�����typo���C���B
;; 	[xyzzy:09158]
;;
(deftest fix-typo-in-lisp/builtin--sort ()
  (get 'sort 'si::builtin-function-argument #1='#:undefined)
  => (sequence lisp::predicate &key :key))

(deftest fix-typo-in-lisp/builtin--rename-file ()
  (get 'rename-file 'si::builtin-function-argument #1='#:undefined)
  => (lisp::file lisp::new-name &key :if-exists :if-access-denied))

(deftest fix-typo-in-lisp/builtin--copy-file ()
  (get 'copy-file 'si::builtin-function-argument #1='#:undefined)
  => (lisp::file lisp::new-file &key :if-exists :copy-attributes :if-access-denied))

(deftest fix-typo-in-lisp/builtin--dump-image-path ()
  (get 'system:dump-image-path 'si::builtin-function-argument #1='#:undefined)
  => nil)

(deftest fix-typo-in-lisp/builtin--char-before ()
  (get 'char-before 'si::builtin-function-argument #1='#:undefined)
  => (point &optional editor::not-used))

(deftest fix-typo-in-lisp/builtin--file-name-dialog ()
  (get 'file-name-dialog 'si::builtin-function-argument #1='#:undefined)
  => (&key :char-encoding :eol-code :filter :filter-index :title :default :extension :save :multiple :must-exist :explorer :hide-read-only :initial-directory))

(deftest fix-typo-in-lisp/builtin--directory-name-dialog ()
  (get 'directory-name-dialog 'si::builtin-function-argument #1='#:undefined)
  => (&key :title :default))

(deftest fix-typo-in-lisp/builtin--make-iso2022-encoding ()
  (get 'make-iso2022-encoding 'si::builtin-function-argument #1='#:undefined)
  => (editor::name editor::display-name &key :g0 :g1 :g2 :g3 :ascii-eol :ascii-control :7bits :locking-shift :short-form :no-escape :cjk :use-cns11643 :vender))

(deftest fix-typo-in-lisp/builtin--make-utf16-encoding ()
  (get 'make-utf16-encoding 'si::builtin-function-argument #1='#:undefined)
  => (editor::name editor::display-name &key :signature :byte-order :windows :cjk))

(deftest fix-typo-in-lisp/builtin--make-utf8-encoding ()
  (get 'make-utf8-encoding 'si::builtin-function-argument #1='#:undefined)
  => (editor::name editor::display-name &key :signature :windows :cjk))

(deftest fix-typo-in-lisp/builtin--make-utf7-encoding ()
  (get 'make-utf7-encoding 'si::builtin-function-argument #1='#:undefined)
  => (editor::name editor::display-name &key :windows :imap4 :white :set-o :cjk))

(deftest fix-typo-in-lisp/builtin--make-utf5-encoding ()
  (get 'make-utf5-encoding 'si::builtin-function-argument #1='#:undefined)
  => (editor::name editor::display-name &key :windows :imap4 :white :set-o :cjk))

(deftest fix-typo-in-lisp/builtin--parse-char-encoding-string ()
  (get 'parse-char-encoding-string 'si::builtin-function-argument #1='#:undefined)
  => (editor::accept-char-encoding string &key :start :end))

;; 	* src : fix hash-table rehash size.
;; 	�n�b�V���e�[�u���̗v�f����80000���z����ӂ肩��A�n�b�V���e�[�u����
;; 	�T�C�Y�̑����ʂ�100�ɌŒ肳���B���̂��ߕp�ɂ�rehash����p�t�H�[�}
;; 	���X���ቺ���Ă����B
;; 	rehash����Ƃ��͍Œ�ł��O�̃T�C�Y��1.5�{�ɂȂ�悤�ɂ����B
;;
;; NOTE: �₽��Ǝ��Ԋ|�����ŕۗ�
;; Ref: https://gist.github.com/227683

;; 	* src : fix ole-method.
;; 	ole-method �ŕ������n���Ɨ]�v�� 0x00 ���t�����
;; 	via http://fixdap.com/p/xyzzy/8379/
;; 	via http://d.hatena.ne.jp/miyamuko/20080304/xyzzy_ole_method_bug
;;
(deftest fix-ole-method ()
  (flet ((ole-create-file (content)
           (let ((tmp (make-temp-file-name)))
             (unwind-protect
                 (let* ((fso (ole-create-object "Scripting.FileSystemObject"))
                        (file (ole-method fso 'OpenTextFile tmp 2)))
                   (unwind-protect
                       (ole-method file 'Write content)
                     (ole-method file 'Close))
                   (file-length tmp))
               (delete-file tmp)))))
    (values (ole-create-file "")
            (ole-create-file "f")
            (ole-create-file "foo")))
  => 0
  => 1
  => 3)


;; 	* src : fix for FFI.
;; 	�߂�l�� double, float �� C �֐����ĂԂƃN���b�V������
;; 	http://xyzzy.s53.xrea.com/wiki/index.php?patch%2F25
;; 	via http://d.hatena.ne.jp/miyamuko/20070509/p1
;;
(deftest fix-for-FFI-c-function-return-doubl/float-00 ()
  (with-another-xyzzy (:options "-q" :timeout 6)
    (labels ((c (name) (find-symbol name :c)))
      (require "foreign")
      (eval `(,(c "define-dll-entry")
              ,(c "double")
              strtod (,(c "char*") (,(c "char*") *))
              "msvcrt"))
      (strtod (si:make-string-chunk "123") 0)))
  => 123.0d0
  )


;; 	* src : fix start-timer.
;; 	http://xyzzy.s53.xrea.com/wiki/index.php?patch%2F21
;; 
; ;; FIXME: *scratch* �ł͓����񂾂��ǃe�X�g�ɂ���ƕԂ��Ă��Ȃ��Ȃ���ۂ�
; (let ((n 0)
;         (start (get-internal-real-time))
;         thunk
;         (finish nil))
;     (setf thunk (lambda ()
;                   (when (>= (incf n) 3)
;                     (stop-timer thunk)
;                     (setf finish (get-internal-real-time)))))
;     (start-timer 1 thunk)
;     (while (not finish)
;       (sleep-for 0.2))
;     (> (- finish start) 2900))

;; 	* src : fix format "~G".
;; 	[xyzzy:09204]
;;
;; 	http://hie.s64.xrea.com/xyzzy/ml/msg09203.html
(deftest fix-format-G ()
  (format t "~10g" 1.23456d+38)
  >> 123456000000000000000000000000000000000.0    
  => nil)

;; 	* src : fix format "~E".
;; 	[xyzzy:09204]
;;
;; 	http://hie.s64.xrea.com/xyzzy/ml/msg09202.html
(deftest fix-format-E-00 ()
  (format t "~E" 123.45)
  >> 1.2345e+2
  => nil)

(deftest fix-format-E-01 ()
  (format t "~0E" 123.45)
  >> 1.2345e+2
  => nil)

;; 	* src : fix format "~F".
;; 	[xyzzy:09204]
;;
;; 	http://hie.s64.xrea.com/xyzzy/ml/msg09202.html
(deftest fix-format-F-00 ()
  (format t "~@F" 123.45)
  >> +123.45
  => nil)

;; 	* src : fix format "~R".
;; 	[xyzzy:09198] http://hie.s64.xrea.com/xyzzy/ml/msg09197.html
;;
(deftest fix-format-R ()
  (format t "~16,10,'*,'-,2:R" #x123abc)
  >> **12-3a-bc
  => nil)

;; 	* src : fix for VC2005.
;; 	Microsoft Visual C++ 2005 �Ńr���h�ł���悤�ɁA���܂��܂ƏC���B
;; 	http://xyzzy.s53.xrea.com/wiki/index.php?patch%2F13
;; 

;(when (yes-or-no-p "�������e�X�g����H")
;  (test-changes))
;; ;;; nanri-master-change-tests.l ends here.