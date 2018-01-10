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

(define string->file
  (lambda (str out)
     (begin 
     (delete-file out)
        (let* ((out-port (open-output-file out)))
            (begin (for-each (lambda(ch) (write-char ch out-port)) (string->list str)) 
        (close-output-port out-port))))))

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
       ((equal? val (void)) `("T_VOID" ,0))
       ((null? val) `("T_NIL" ,0)) 
       ((boolean? val) `("T_BOOL" ,(if val 1 0)))
       ((char? val) `("T_CHAR" ,(char->integer val)))
       ;((string? val) `("T_STRING" todo))
       ;((vector? val ))
       ;((fraction? val ))
       ((pair? val) `("T_PAIR" ,(lookup-const (car val) table) ,(lookup-const (cdr val) table))))
    ))

(define make-const-table
  (lambda (const-lst)
    (letrec ((iter
      (lambda (table lst addr)
       (if (null? lst) `(,table ,addr)
        (let ((type (get-const-type (car lst) table)))
            (iter `(,@table (,(car lst) ,addr ,type)) (cdr lst) (+ addr (length type))))))))
      (iter '() const-lst 0))))


(define get-asm-const-line
  (lambda (table-line)
    (let* ((value (caddr table-line))
           (type (car value)))
      (cond 
        ((or (equal? type "T_INTEGER") (equal? type "T_NIL") (equal? type "T_VOID") (equal? type "T_BOOL"))
            (format "dq MAKE_LITERAL(~A,~S)\n" type (cadr value)))
      (else "WTF"))
    )))

(define get-asm-const-table
  (lambda (table)
    (if (null? table) ""
    (string-append (get-asm-const-line (car table)) (get-asm-const-table (cdr table))))))

(define compile-scheme-file 
  (lambda (in out)
    (let* ((lst-exprs (pipeline (file->list in)))
    	   (ctable (make-const-table (get-consts lst-exprs)))
      	   (asm-ctable (string-append 
            "const_table:\n" 
             (get-asm-const-table (car ctable))))
          	
          
          	(asm-output (format "%include \"scheme.s\"\nsection .bss \nglobal _start\nsection .rodata\n\t~A\nsection .data\n\t_start:\n" asm-ctable)))
  			
     		 (string->file asm-output out)
        		asm-output
         )))
    
 
             