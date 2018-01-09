(load "sexpr-parser.scm")
(load "tag-parser.scm")
(load "semantic-analyzer.scm")
 
 (define pipeline
	(lambda (s)
		((star <sexpr>) s
			(lambda (m r)
				(map (lambda (e)
					(annotate-tc
					(pe->lex-pe
					(box-set
					(remove-applic-lambda-nil (parse e))))))
				m))
			(lambda (f) 'fail))))

(define file->list
	(lambda (in-file)
		(let ((in-port (open-input-file in-file)))
			(letrec ((run
				(lambda ()
					(let ((ch (read-char in-port)))
						(if (eof-object? ch)
							(begin
								(close-input-port in-port)
								'())
							(cons ch (run)))))))
			(run)))))

(define list->set 
  (lambda (s) 
    (fold-right
      (lambda (a s)
        (if (ormap (lambda (si) (equal? a si)) s)
            s
            (cons a s))) 
      '()
      s)))

(define ^get-consts
  (lambda (exp)
    (cond
      ((null? exp) '())
      ((not (list? exp)) '())
      ((eq? 'const (car exp))
         (cdr exp))
      (else (append (^get-consts (car exp)) (^get-consts (cdr exp)))))
    ))


(define split-consts-lst
  (lambda (lst)
    (wrapped-split-consts-lst (car lst))))

(define wrapped-split-consts-lst
  (lambda (lst)
    (cond 
       ((null? lst) lst)
       ((not (pair? lst)) `(,lst))
       (else 
         (cons (car lst) (cons lst (wrapped-split-consts-lst (cdr lst)))))   
  )))


(define sorter 
  (lambda (s1 s2)
    (cond 
      ((not (pair? s1)) #t)
      ((not (pair? s2)) #f)
      (else (< (length s1) (length s2)))
    )))

(define get-consts
  (lambda (list-exprs) 
    (let ((init-consts (map ^get-consts list-exprs)))
     (sort sorter (list->set (append (list (void) '() #f #t) (fold-left append '() (map split-consts-lst init-consts))))
    ))))


(define make_label
  (lambda (perfix)
    (let ((n 0))
      (lambda ()
        (set! n (+ n  1))
        (format "~A_~A" perfix n))))
    )



(define lookup-const
  (lambda (val table)
    (if (null? table) 'error
        (let ((curr (car table)))
          (if (equal? (car curr) val)
              (cadr curr)
              (lookup-const val (cdr table)))))
    
    )
  )


(define get-const-type 
  (lambda (val table)
    (cond 
       ((integer? val)  `("T_INTEGER" ,val))
       ((equal? val (void)) `("T_VOID"))
       ((null? val) `("T_NIL")) 
       ((boolean? val) `("T_BOOL" ,(if val 1 0)))
       ((char? val) `("T_CHAR" ,(char->integer val)))
       ((string? val) `("T_STRING" todo))
       ((pair? val) `("T_PAIR" ,(lookup-const (car val) table) ,(lookup-const (cdr val) table))))
    ))

(define make-const-table
  (lambda (const-lst)
    (letrec ((iter
      (lambda (table lst addr)
       (if (null? lst) `(,table ,addr)
        (let ((type (get-const-type (car lst) table)))
            (iter `(,@table (,(car lst) ,addr ,type)) (cdr lst) (+ addr (length type))))))))
      (iter '() const-lst 1))))




(define compile-scheme-file 
  (lambda (in out)
    (let ((lst-exprs (pipeline (file->list in))))
    	(make-const-table (get-consts lst-exprs))
    )))
             
             

    
             