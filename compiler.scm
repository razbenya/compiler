(load "sexpr-parser.scm")
(load "tag-parser.scm")
(load "semantic-analyzer.scm")
 
 ;Function to run assignment 1-3 on input
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

;read input from file into a scheme list
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

;write scheme string to file
(define string->file
  (lambda (str out)
     (begin 
     (delete-file out)
        (let* ((out-port (open-output-file out)))
            (begin (for-each (lambda(ch) (write-char ch out-port)) (string->list str)) 
        (close-output-port out-port))))))

;remove all duplicates from list (for const table)
(define list->set 
  (lambda (s) 
    (fold-right
      (lambda (a s)
        (if (ormap (lambda (si) (equal? a si)) s)
            s
            (cons a s))) 
      '()
      s)))


(define get-all-cdr
  	(lambda (lst)
    	(cond ((null? lst) lst)
          	(else (cons (cdr lst) (get-all-cdr (cdr lst)))))))


;run on given expression and save all consts from it - for consts table
(define ^get-consts
  (lambda (exp)
    (cond
      ((null? exp) '())
      ((not (list? exp)) '())
      ((eq? 'const (car exp))
         (cdr exp))
      (else (append (^get-consts (car exp)) (^get-consts (cdr exp)))))
    ))


; handle all type of consts and typology sort them inside a list 
; todo add symbol
(define split-consts
  (lambda (consts-lst acc)
    (cond
      ((null? consts-lst) acc)
      ((fraction? (car consts-lst)) 
       		(split-consts (cdr consts-lst) (append acc `(,(numerator (car consts-lst))) `(,(denominator (car consts-lst))) `(,(car consts-lst)))))
      ((vector? (car consts-lst))
       	 	(split-consts (cdr consts-lst) (append acc (split-consts (vector->list (car consts-lst)) '()) `( ,(car consts-lst)))))
      ((pair? (car consts-lst)) 
       		(split-consts (cdr consts-lst) (append acc (split-consts (car consts-lst) '()) (reverse (get-all-cdr (car consts-lst))) `(,(car consts-lst)))))
      (else 
        	(split-consts (cdr consts-lst) (append acc `(,(car consts-lst))))))))


 ;	run on list of exprs and call ^get consts on each exprs to receive all consts from it
;	after that add the basics conts types and remove all duplicates from the list
(define get-consts
  (lambda (list-exprs)
    (let* ((init-consts-lsts `( ,@(map ^get-consts list-exprs)))
           (init-consts (fold-left append '() init-consts-lsts))
    		(no_duplicates_list  
       			(reverse (list->set  (reverse (append (list (void) '() #f #t) (split-consts init-consts '())))))))
      no_duplicates_list)))


;generator of unique labels creation (counter)
(define ^make_label
  (lambda (perfix)
    (let ((n 0))
      (lambda ()
        (set! n (+ n  1))
        (format "~A_~A" perfix n))))
    )

;const label
(define make_const_label
  (^make_label "const"))

;find val in the const table and return its label (cadr curr)
; Input is sorted so using look-up is assuming val is in table 
(define lookup-const
  (lambda (val table)
    (if (null? table) 'error
        (let ((curr (car table)))
          (if (equal? (car curr) val)
              (cadr curr)
              (lookup-const val (cdr table)))))
    
    )
  )

;predict for fraction
(define fraction? 
  (lambda (n)
    (and (not (integer? n)) (rational? n))))
      
;create const type according to val type, called at the end after the const table is built
;so calling lookup-const is k and all elements are already there.
(define get-const-type 
  (lambda (val table)
    (cond 
       ((integer? val)  `("T_INTEGER" ,val))
       ((equal? val (void)) `("T_VOID" ,0))
       ((null? val) `("T_NIL" ,0)) 
       ((boolean? val) `("T_BOOL" ,(if val 1 0)))
       ((char? val) `("T_CHAR" ,(char->integer val)))
       ((string? val) `("T_STRING" ,val))
       ((vector? val ) `("T_VECTOR" ,@(map (lambda (ele) (lookup-const ele table)) (vector->list val))))
       ((fraction? val) `("T_FRACTION" ,(lookup-const (numerator val) table) ,(lookup-const (denominator val) table)))
       ((pair? val) `("T_PAIR" ,(lookup-const (car val) table) ,(lookup-const (cdr val) table))))
    ))

;build the const table by iterating the const list, getting the type for the next const and building the table
; with the next const with unique label, table start empty, list start full, till list is empty and table is built
(define make-const-table
  (lambda (const-lst)
    (letrec ((iter
      (lambda (table lst addr)
       (if (null? lst) `(,table ,addr)
        (let ((type (get-const-type (car lst) table)))
            (iter `(,@table (,(car lst) ,addr ,type)) (cdr lst) (make_const_label)))))))
      (iter '() const-lst (make_const_label)))))

(define string-join
  (lambda (lst delimeter)
    (fold-left string-append (format "~A" (car lst)) (map (lambda (e) (format "~A~A" delimeter e) ) (cdr lst)))  
  ))

;get an assembly build for one const depent on it's type
(define get-asm-const-line
  (lambda (table-line)
    (let* ((value (caddr table-line))
           (addr (cadr table-line))
           (type (car value)))
      (cond 
        ((or (equal? type "T_INTEGER") (equal? type "T_NIL") (equal? type "T_VOID") (equal? type "T_BOOL") (equal? type "T_CHAR"))
            (format "\t\t~A:\n\t\t\tdq MAKE_LITERAL(~A,~S)\n" addr type (cadr value)))
        ((equal? type "T_PAIR") 
         (format "\t\t~A:\n\t\t\tdq MAKE_LITERAL_PAIR(~A,~A)\n" addr (cadr value) (caddr value)))
        ((equal? type "T_STRING") 
         (format "\t\t~A:\n\t\t\tMAKE_LITERAL_STRING ~S\n" addr (cadr value)))
        ((equal? type "T_VECTOR")
         (format "\t\t~A:\n\t\t\tMAKE_LITERAL_VECTOR ~A\n" 
                 addr (string-join (map (lambda (e) (format "~A" e)) (cdr value)) ", ")))
        ((equal? type "T_FRACTION") 
         (format "\t\t~A:\n\t\t\tdq MAKE_LITERAL_FRACTION(~A,~A)\n" addr (cadr value) (caddr value))) 
      (else "WTF"))
    )))

;get the assmebly build for const table
(define get-asm-const-table
  (lambda (table)
    (if (null? table) ""
    (string-append (get-asm-const-line (car table)) (get-asm-const-table (cdr table))))))


(define code-gen
  (lambda (expr ctable)
    (cond 
       ((eq? 'const (car expr))
        	(let* ((value (cadr expr))
                  (addr (lookup-const value ctable)))
           		(format "MOV RAX,QWORD[~A]" addr)))
       )
    ))

(define code-gen-fromlst
  (lambda (lst-expr ctable code)
    (if (null? lst-expr) code 
        (code-gen-fromlst (cdr lst-expr) ctable 
                          (string-append code 
                            (format "
                                    ~A
                                    push RAX
                                    call write_sob_if_not_void
                                    add RSP,8" 
                                    (code-gen (car lst-expr) ctable)))))
    ))





;the main function called, reading from file in;
;building lst-exprs from assignment 1-3 and find all consts create ctable
;build the assembly backround code and call code-gen to compile the code given
(define compile-scheme-file 
  (lambda (in out)
    (let* ((lst-exprs (pipeline (file->list in)))
    	   (ctable (make-const-table (get-consts lst-exprs)))
      	   (asm-ctable (string-append 
            "const_table:\n" 
             (get-asm-const-table (car ctable))))
          
          	(asm-code (code-gen-fromlst lst-exprs (car ctable) "\n"))
           
          	(asm-output (format "%include \"scheme.s\"\nsection .bss\nglobal main\nsection .data\n\t~A\nsection .data\n\tmain:\n~A\n\tret\n" asm-ctable asm-code)))
  			
     		 (string->file asm-output out)
        		(display asm-output)
         )))
                