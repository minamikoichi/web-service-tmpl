;; # :todo refactor. now eval in cl package.
;; スクリプトで動作させているので、とりあえずは妥協させているが・・・

(defun attr-value (attr lis)
  (cond ((null lis) nil)
	((atom lis) nil)
	((null (cdr lis)) nil)
	(t (if (equal (car lis) attr)
	       (cadr lis)
	       (attr-value attr (cddr lis))))))

(defun remove-attr (attr lis)
  (let ((rv (attr-value attr lis)))
    (if rv
	(remove rv (remove attr lis))
	(remove attr lis))))

(defun transition-link (&rest rest)  
  (skip:ifbind class-val (attr-value :class rest)
	  `(:a :class ,(join (list "TRANSITION" class-val) " ") ,@(remove-attr :class rest))
	  `(:a :class "TRANSITION" ,@rest)))
