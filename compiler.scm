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
    
    
(define fvar-label
    (^make_label "Lglob"))
    
    
(define get-fvar-lsts
    (lambda (list-exprs)
         (let ((fvars `( ,@(map ^get-fvar list-exprs))))
            (fold-left append '() fvars))))

(define lib-funcs '()) ;todo add lib funcs
            
(define build-ftable
    (lambda (list-fvars)
        (list->set (append lib-funcs (map (lambda (var) `(,var ,(fvar-label))) list-fvars)))))
        

    
(define ^get-fvar
  (lambda (exp)
    (cond
      ((null? exp) '())
      ((not (list? exp)) '())
      ((eq? 'fvar (car exp))
         (cdr exp))
      (else (append (^get-fvar (car exp)) (^get-fvar (cdr exp)))))
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
      ((list? (car consts-lst)) 
       		(split-consts (cdr consts-lst) (append acc (split-consts (car consts-lst) '()) (reverse (get-all-cdr (car consts-lst))) `(,(car consts-lst)))))
      ((pair? (car consts-lst))
                (split-consts (cdr consts-lst) (append acc (split-consts (make_list_from_not_proper_list (car consts-lst)) '()) `(, (car consts-lst)))))
      (else 
        	(split-consts (cdr consts-lst) (append acc `(,(car consts-lst))))))))

(define make_list_from_not_proper_list
    (lambda (almost_lst)
        (cons (car almost_lst) (cons (cdr almost_lst) '()))
    ))

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

;if_else label
(define make_if_else_label
  (^make_label "if_else"))

;if_exit label
(define make_if_exit_label
  (^make_label "if_exit"))

;or_exit_label
(define make_or_exit_label
  (^make_label "or_exit"))


;generating one expr code in assembly, depend on type
(define code-gen
  (lambda (expr major ctable)
    (cond 
       ((eq? 'const (car expr))
        	(let* ((value (cadr expr))
                  (addr (lookup-const value ctable)))
           		       (format "MOV RAX,QWORD[~A]
                             " addr)))

       ((eq? 'if3 (car expr))
          (let* ((if_test (cadr expr))
                 (if_then (caddr expr))
                 (if_else (cadddr expr))
                 (label_else (make_if_else_label))
                 (label_exit (make_if_exit_label)))
                    (format "~A
                            CMP RAX,QWORD[~A]
                            JE ~A
                            ~A
                            jmp ~A
                            ~A:
                            ~A
                            ~A:" 
                    (code-gen if_test major ctable) (lookup-const #f ctable) label_else (code-gen if_then major ctable) label_exit label_else (code-gen if_else major ctable) label_exit)))
       
       ((eq? 'or (car expr))
          (let ((label_exit (make_or_exit_label)))
        (letrec ((iter
          (lambda (exp rest ans)
            (if (not (null? rest))
              (let ((ans (string-append ans 
                    (format "
                           ~A
                           CMP RAX, QWORD[~A]
                           JNE ~A
                           "
                  (code-gen exp major ctable) (lookup-const #f ctable) label_exit))))
                (iter (car rest) (cdr rest) ans))
              (string-append ans
                      (format 
                            "~A
                             "
                  (code-gen exp major ctable)))
              ))))
        (string-append (iter (car (cadr expr)) (cdr (cadr expr)) "") 
                    (format "~A:" label_exit))
        )))

       ((eq? 'seq (car expr))
        (fold-left string-append "" (map (lambda (exp) (code-gen exp major ctable)) (cadr expr))))
        
       ((eq? 'lambda-simple (car expr))
            (code-gen-lambda-simple expr major ctable))
            
       ((eq? 'applic (car expr))
            (code-gen-applic expr major ctable))
       ((eq? 'pvar (car expr))
            (code-gen-pvar expr major ctable))
       ((eq? 'bvar (car expr))
            (code-gen-bvar expr major ctable))
  )))
  
  
  (define code-gen-pvar
        (lambda (expr major ctable)
            (let ((minor (caddr expr)))
                    (format "mov rax, [rbp + (4+~A) * 8]" minor))))
                    
  (define code-gen-bvar
        (lambda (expr major ctable)
            (let ((mi (cadddr expr))
                  (ma (caddr expr)))
                    (format "mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + ~A*8]
                             mov rax,qword[rax+ ~A*8]
                            " ma mi))))
  
  (define loop_label_enter
    (^make_label "loop_enter"))
    
  (define loop_label_exit
    (^make_label "loop_exit"))
    
  (define lambda_body_start
    (^make_label "lambda_body_start"))
    
  (define lambda_body_end
    (^make_label "lambda_body_end"))
    
 (define make_closure_label
    (^make_label "closure"))
  
  (define code-gen-lambda-simple 
    (lambda (expr major ctable)
        (let* (
            (B (lambda_body_start))
            (L (lambda_body_end))
            (epilog (string-append
                    "
                    mov rax, 8
                    "
                    "push rax
                    "
                    "call my_malloc
                    "
                    "add rsp, 8
                    "
                    "mov rdx, rax
                    "
                    "mov rax, " (number->string (* 8 (+ 1 major)))
                    "
                    push rax
                    "
                    "call my_malloc
                    "
                    "add rsp, 8
                    "
                    "mov rbx, rax
                    "))
            (extend-env
                (let* ((loop_enter1 (loop_label_enter))
                      (loop_exit1 (loop_label_exit))
                      (loop_enter2 (loop_label_enter))
                      (loop_exit2 (loop_label_exit)))
                    (string-append
                        "mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        "
                        loop_enter1 ":
                        cmp rdi, " (number->string major)
                        "
                        je " loop_exit1
                        "
                        mov r10, [rax + rdi*8]"              ;; for(i=0;i<m;i++)
                        "
                        mov [rbx + rdi*8 + 1*8], r10"       ;;  env'[i+1] = env[i]    
                        "
                        inc rdi
                        jmp " loop_enter1
                        "
                        "
                        loop_exit1 ":
                        mov r8, [rbp+8*3] ;n
                        mov r9, r8
                        shl r9, 3
                        push r9
                        call my_malloc
                        add rsp, 8
                        mov rcx , rax
                        mov rdi, 0
                        "
                        loop_enter2 ":
                        cmp rdi , r8
                        je " loop_exit2
                        "
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
                        "               ;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        "
                        inc rdi
                        jmp " loop_enter2
                        "
                        "
                        loop_exit2 ":
                        mov [rbx], rcx
                        "
                    )))
            (make-closure
                (let ((closure_label (make_closure_label)))
                (string-append
                    "mov rax, 16
                    push rax
                    call my_malloc
                    add rsp, 8
                    MAKE_LITERAL_CLOSURE rax, rbx, " B "
                    mov rax,[rax]
                    jmp " L
                    "
                    "
                    B ":
                    push rbp
                    mov rbp, rsp
                    "
                    (code-gen (caddr expr) (+ 1 major) ctable) "
                    leave
                    ret
                    "
                    L ":
                    "
                    ))))
                    
                (string-append epilog extend-env make-closure))
            ))
            
(define code-gen-applic
    (lambda (expr major ctable)
        (let* ((params (caddr expr))
               (proc (cadr expr))
               (push-params
                (string-append 
                    (string-join (map (lambda (p) (code-gen p major ctable)) (reverse params)) "\npush rax\n")
                    "push rax
                    mov rax, " (number->string (length params))
                    "
                    push rax
                    "))
                (handle-proc
                    (string-append (code-gen proc major ctable) "
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    mov r8, " (number->string (+ 16 (* 8 (length params))) )
                                    "
                                    add rsp, r8
                                    ")))
                (string-append push-params handle-proc))))
                                    
                
                
        

;iterate over the list of exprs and call code-gen for each exprs, appending to it end the expected finish - result in rax, printing if not void, clean.
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
                    (code-gen (car lst-expr) 0 ctable)))))
    ))

(define get-asm-ftable
    (lambda (scm-ftable)
        (if (null? scm-ftable) ""
            (string-append 



;the main function called, reading from file in;
;building lst-exprs from assignment 1-3 and find all consts create ctable
;build the assembly backround code and call code-gen to compile the code given
(define compile-scheme-file 
  (lambda (in out)
    (let* ((lst-exprs (pipeline (file->list in)))
    	   (ctable (make-const-table (get-consts lst-exprs)))
    	   (ftable (build-ftable (get-fvar-lsts lst-exprs)))
      	   (asm-ctable (string-append 
            "const_table:\n" 
             (get-asm-const-table (car ctable))))
           (asm-ftable (string-append
            "global_table:\n"
            (get-asm-ftable ftable)))
           (asm-code (code-gen-fromlst lst-exprs (car ctable) "\n"))
           
          	(asm-output 
          	(format "%include \"scheme.s\"\nsection .bss\nglobal main\nsection .data\n\t~A
          	section .text
          	\tmain:
                mov rax, 0
                push rax
                mov rax, [const_2]
                push rax
                mov rax, 0x1234
                push rax
                push rbp
          	mov rbp, rsp
                ~A
                ERROR_NOT_CLOSURE:
                add rsp, 4*8
          	ret\n" asm-ctable asm-code))
          	)
  			
     		 (string->file asm-output out)
        		(display asm-output)
         )))
                