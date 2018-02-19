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
        
    
(define get-fvar-lsts
    (lambda (list-exprs)
         (let ((fvars `( ,@(map ^get-fvar list-exprs))))
            (fold-left append '() fvars))))


;generator of unique labels creation (counter)
(define ^make_label
  (lambda (perfix)
    (let ((n 0))
      (lambda ()
        (set! n (+ n  1))
        (format "~A_~A" perfix n))))
    )

                
(define error-label
  (^make_label "ERROR"))

(define cmp_false
  (^make_label "cmp_false"))

(define cmp_true
  (^make_label "cmp_true"))

(define finish_label
  (^make_label "finish_label"))

(define type_ok_label
  (^make_label "type_ok"))

(define check_fraction_l
  (^make_label "check_fraction"))

(define finish_add_l
  (^make_label "finish_add"))

(define positive-label
  (^make_label "positive"))

(define equal-l
  (^make_label "equal"))

(define regular_case_label
  (^make_label "regular_case"))

(define build_string_label
  (^make_label "build_string"))

(define build_vector_label
  (^make_label "build_vector"))


(define scheme-functions 
 (map (lambda(e) 
          (annotate-tc
          (pe->lex-pe
          (box-set
          (remove-applic-lambda-nil (parse e))))))
  (list
    
    '(define eq?
       (let ((old-eq? eq?))
         (lambda (x y)
           (if (and (number? x) (number? y))
               (= x y)
               (old-eq? x y))))) 
     
    '(define list (lambda x x))
    
    '(define append 
        (lambda x
          (letrec ((b_append 
                      (lambda (lst1 lst2)
                          (if (null? lst1)
                              lst2
                              (cons (car lst1) (b_append (cdr lst1) lst2))))))
              (if (null? x) x
                  (if (null? (cdr x)) (car x)
                    (b_append (car x) (apply append (cdr x))))) 
      )))

    '(define >
       (let ((bigger? bigger?)
            (positive? positive?))
      (lambda (x . y)
        (if (null? y)
          #t
          (letrec ((bigger?
                     (lambda (x y rest)
                        (if (null? rest) 
                          (positive? (- x y))
                          (and (positive? (- x y))
                            (bigger? y (car rest) (cdr rest)))))))
          (bigger? x (car y) (cdr y)))))))

    '(define <
      (let ((bigger? bigger?)
            (positive? positive?))
      (lambda (x . y)
        (if (null? y)
          #t
          (letrec ((bigger?
                  (lambda (x y rest)
                    (if (null? rest) 
                      (and (not (positive? (- x y))) 
                            (not (zero? (- x y))))
                      (and (not (positive? (- x y))) 
                            (not (zero? (- x y)))
                           (bigger? y (car rest) (cdr rest)))))))
          (bigger? x (car y) (cdr y)))))))


    '(define *
        (lambda x 
          (let ((b_mul b_mul))
          (cond ((null? x) 1)
            (else (b_mul (car x) (apply * (cdr x))))))))

    '(define / 
      (let ((b_div b_div))
        (lambda (x . y)
          (letrec ((iter 
                     (lambda (acc x . z)
                        (if (null? z) (b_div acc x)
                            (apply iter (cons (b_div acc x) z))))))
          (if (null? y) (b_div 1 x)
                       (apply iter (cons x y)))))))

    '(define + 
       (let ((b_plus b_plus))
        (lambda x
          (if (null? x) 0
            (b_plus (car x) (apply + (cdr x)))))))    
    
    '(define - 
       (let ((b_minus b_minus))
        (lambda (x . y)
          (letrec ((iter 
                     (lambda (acc x . z)
                        (if (null? z) (b_minus acc x)
                            (apply iter (cons (b_minus acc x) z))))))
          (if (null? y) (b_minus 0 x)
                       (apply iter (cons x y)))))))
    '(define =
       (let ((b_equal b_equal))
       (lambda (x . y)
         (if (null? y) #t
             (and (b_equal x (car y)) (apply = y))))))
    
    
    '(define list-length
    	(lambda (x)
    		(if (null? x) 
    			0
    			(+ 1 (list-length (cdr x)))
    		)))

    '(define vector
       (let ((list-length list-length)) 
        (lambda x 
          (if (null? x) #()
            (list->vector x (list-length x))))))

    
    '(define b_map
      (lambda (f s)
        (if (null? s)
            s
            (cons (f (car s))
                  (b_map f (cdr s))))))
    
    '(define maplist
       (let ((b_map b_map))
      (lambda (f s)
        (if (null? (car s))
            '()
            (cons (apply f (b_map car s))
                  (maplist f (b_map cdr s)))))))
    
    '(define map
      (let ((maplist maplist))
        (lambda (f . s)
          (maplist f s))))

  ))
)


(define both_fraction_l
  (^make_label "both_fraction"))

(define int_with_fract_l
  (^make_label "int_with_fract"))

(define negative_l
  (^make_label "negative"))

(define test_l
  (^make_label "test"))


(define lib-funcs '(boolean? car cdr char? eq? integer? denominator remainder
                     cons char->integer integer->char null? pair? zero? number? numerator
                     apply b_plus b_minus vector? rational? string? procedure? 
                     set-car! set-cdr! not b_equal > < b_mul
                     b_div string-length vector-length
                     vector-ref string-ref symbol?
                     string-set! vector-set! make-string make-vector
                     symbol->string string->symbol list->vector list-length))

(define add-lib-fun-make-string
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'make-string ftable))
      (B (lambda_body_start))
      (loop_enter (loop_label_enter))
      (loop_exit (loop_label_exit))
      (regular_case (regular_case_label))
      (build_string (build_string_label))
      (L (lambda_body_end)))

      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      mov r8, qword[rbp + 3*8] ;n
                      cmp r8, 2
                      jg ERROR
                      cmp r8, 1
                      jl ERROR ;error
                      mov rbx, qword[rbp + 4*8] ;get first param
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR
                      cmp r8, 2
                      je "regular_case"
                      ;case of 1 param
                      mov rdx, 0
                      jmp "build_string"

                      "regular_case":
                      ;REGULAR CASE with value to init
                      mov rcx, qword[rbp + 5*8] ;get second param
                      mov r8, [rcx]
                      TYPE r8
                      cmp r8, T_CHAR
                      jne ERROR
                      mov rdx, [rcx]
                      DATA rdx ;the char to init

                      ;Now we build the string - char in rdx
                      "build_string":
                      mov r9, [rbx]
                      DATA r9; iterations in loop
                      test_malloc r9
                      mov r8, rax ; save pointer to begining of malloc in rax
                      mov rsi, 0

                      "loop_enter":
                      cmp rsi, r9
                      je "loop_exit" 
                      mov [r8+rsi], dl
                      ;add r8, 1
                      add rsi, 1
                      jmp "loop_enter"

                      "loop_exit":
                      add r8, r9
                      MAKE_STRING rax, r8
                      test_malloc 8
                      mov [rax], r8
                      CLEAN_STACK
                      ret
                      " L ":
                      "
      ))))


(define add-lib-fun-vector-set
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'vector-set! ftable))
      (B (lambda_body_start))
      (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                          
                      mov r8, qword[rbp+3*8] ;n
                      cmp r8, 3
                      jne ERROR    
                          
                      mov rbx, qword[rbp + 4*8] ;get first param
                      mov rcx, qword[rbp + 5*8] ;get second param
                      mov rdx, qword[rbp + 6*8] ;get third param
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_VECTOR
                      jne ERROR
                      mov rax, [rcx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR
                      mov rax, [rbx]
                      VECTOR_ELEMENTS rax
                      mov r8, [rcx]
                      DATA r8
                      shl r8, 3
                      lea rax, [rax + r8]
                      mov [rax], rdx
                      mov rax, const_1
                      CLEAN_STACK
                      ret
                      " L ":"
      ))))

(define add-lib-fun-apply
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'apply ftable))
          (loop_enter1 (loop_label_enter))
          (loop_exit1 (loop_label_exit))
          (loop_enter2 (loop_label_enter))
          (loop_exit2 (loop_label_exit))
          (loop_enter3 (loop_label_enter))
          (loop_exit3 (loop_label_exit))
          (finish_l (finish_label))
          (check_nil ((^make_label "check_nil")))
          (type_ok (type_ok_label))
          (B (lambda_body_start))
          (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 3*8] ;n
                      cmp rax, 2
                      jne ERROR
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get 2nd param
                      mov rdx,[rdx]
                      mov rbx,[rbx]                          
                      mov rax, rdx
                      TYPE rax
                      cmp rax, T_CLOSURE
                      jne ERROR
                      mov rax, rbx
                      TYPE rax
                      cmp rax, T_PAIR
                      JNE " check_nil "
                      jmp " type_ok "
                      " check_nil ":
                      cmp rax, T_NIL
                      JNE ERROR
                      " type_ok ":
                      mov rdi, 0
                      mov rcx, rbx
                      mov rax, const_2
                      "loop_enter1 ":
                      cmp rcx,T_NIL
                      je " loop_exit1 "
                      mov r8, rcx
                      packed_car r8
                      MAKE_PAIR r8, rax
                      test_malloc 8
                      mov [rax], r8
                      CDR rcx
                      inc rdi
                      jmp " loop_enter1 "
                      " loop_exit1 ":
                      ;push params
                      push const_2
                      mov rax, [rax]
                      "loop_enter2 ":
                      cmp rax,T_NIL
                      je " loop_exit2 "
                      mov rcx, rax
                      packed_car rcx
                      push rcx
                      CDR rax
                      jmp " loop_enter2 "             
                      " loop_exit2 ":
                      push rdi ; push n
                      mov r11, rdx
                      CLOSURE_ENV r11            
                      push r11                              
                      mov r8,rbp
                      mov rbp,[rbp] ; rbp <= old rbp                                                                 
                      mov rbx, [r8+8] ; old ret
                      push rbx
                      mov rsi,0
                      mov r10, 7*8                                
                      add r10,r8 ; r8 + 8 * (5+2)  
                      add rdi, 4                                                                
                      " loop_enter3 ":
                      cmp rsi, rdi
                      je " loop_exit3 "
                      sub r8, 8
                      sub r10,8 
                      .b:          
                      mov r9, [r8]
                      mov [r10], r9
                      inc rsi
                      jmp " loop_enter3 "
                      " loop_exit3 ":                                    
                      add rsp, 7*8
                      .b:
                      mov rax, rdx                      
                      CLOSURE_CODE rax
                      jmp rax           
                      " L ":
                      ")
      )))



(define add-lib-fun-string-set
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'string-set! ftable))
      (B (lambda_body_start))
      (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp+ 3*8]
                      cmp r8, 3
                      jne ERROR    
                          
                      mov rbx, qword[rbp + 4*8] ;get first param
                      mov rcx, qword[rbp + 5*8] ;get second param
                      mov rdx, qword[rbp + 6*8] ;get third param
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_STRING
                      jne ERROR
                      mov rax, [rcx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_CHAR
                      jne ERROR
                      mov rax, [rbx]
                      STRING_ELEMENTS rax
                      mov r8, [rcx]
                      DATA r8
                      add rax, r8
                      xor rcx, rcx
                      mov rcx, [rdx]
                      DATA rcx
                      mov byte [rax], cl
                      mov rax, const_1
                      CLEAN_STACK
                      ret
                      " L ":"
      ))))



(define add-lib-fun-symbol->string
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'symbol->string ftable))
      (B (lambda_body_start))
      (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                          
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rbx, qword[rbp + 4*8] ;get first param
                      mov rbx,[rbx]
                      mov rax, rbx
                      TYPE rax
                      cmp rax, T_SYMBOL
                      JNE ERROR
                      packed_car rbx
                      mov rax, rbx
                      CLEAN_STACK
                      RET
                      " L ":"
      ))))


(define add-lib-fun-string->symbol
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'string->symbol ftable))
      (B (lambda_body_start))
      (loop_enter (loop_label_enter))
      (loop_exit (loop_label_exit))
      (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                          
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rbx, qword[rbp + 4*8] ;get first param
                      mov r9,[rbx]
                      mov rax, r9
                      TYPE rax
                      cmp rax, T_STRING
                      JNE ERROR
                      mov rdx, qword[bucket_head]
                      "loop_enter":
                      cmp rdx, bucket_0
                      je .create_new_bucket
                      mov r8, rdx
                      mov rdx, [rdx]
                      mov rax, rdx
                      CAR rax
                      STR_CMPR rax, r9
                  	  je .found_bucket ;bucket is in r8
                      packed_cdr rdx
                      jmp " loop_enter "
                      .create_new_bucket:
                      mov rdx, qword[bucket_head]
             		      MAKE_BUCKET rbx, rdx
                      test_malloc 8
                      mov [rax], rbx
                      mov [bucket_head],rax
                      mov r8,rax
                      .found_bucket:
                      mov rax,r8
                      .finish:
                      CLEAN_STACK
                      RET
                      " L ":"
      ))))



(define add-lib-fun-string-ref
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'string-ref ftable))
      (B (lambda_body_start))
      (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 2
                      jne ERROR    
                          
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get second param
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_STRING
                      jne ERROR
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR
                      mov rbx, [rbx]
                      mov rdx, [rdx]
                      DATA rbx
                      test_malloc 8
                      xor rcx, rcx
                      mov cl, byte[rax]
                      STRING_REF cl,rdx,rbx
                      MAKE_CHAR rcx
                      test_malloc 8
                      mov [rax], rcx
                      CLEAN_STACK
                      ret
                      " L ":"
      ))))

(define add-lib-fun-make-vector
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'make-vector ftable))
      (B (lambda_body_start))
      (loop_enter (loop_label_enter))
      (loop_exit (loop_label_exit))
      (regular_case (regular_case_label))
      (build_vector (build_vector_label))
      (L (lambda_body_end)))

      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      mov r8, qword[rbp + 3*8] ;n
                      cmp r8, 2
                      jg ERROR ;error
                      cmp r8, 1
                      jl ERROR ;error
                      mov rbx, qword[rbp + 4*8] ;get first param
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR
                      cmp r8, 2
                      je "regular_case"
                      ;case of 1 param
                      mov rdx, 0
                      MAKE_INT rdx
                      jmp "build_vector"

                      "regular_case":
                      ;REGULAR CASE with value to init
                      mov rcx, qword[rbp + 5*8] ;get second param
                      mov rdx, [rcx]

                      ;Now we build the string - value in rdx
                      "build_vector":
                      mov r9, [rbx]
                      DATA r9; iterations in loop
                      mov r10,r9 ; save condition for end of loop
                      shl r9, 3 ; (multiple by 8 for place to pointer for each value)
                      test_malloc r9
                      mov r8, rax
                      mov r11, r8 ; save pointer to beginning of malloc in r11
                      mov rsi, 0
                      "loop_enter":
                      cmp rsi, r10
                      je "loop_exit"
                      test_malloc 8
                      mov [rax], rdx
                      mov [r8+rsi*8], rax
                      add rsi, 1
                      jmp "loop_enter"

                      "loop_exit":
                      add r8, r9
                      MAKE_VECTOR r11, r8
                      test_malloc 8
                      mov [rax], r8
                      CLEAN_STACK
                      ret
                      " L ":
                      "
      ))))


(define add-lib-fun-vector-ref
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'vector-ref ftable))
      (B (lambda_body_start))
      (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 2
                      jne ERROR
                                  
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get second param
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_VECTOR
                      jne ERROR
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR
                      mov rbx, [rbx]
                      mov rdx, [rdx]
                      DATA rbx
                      test_malloc 8
                      mov r8, rax
                      VECTOR_REF r8,rdx,rbx
                      mov rax, r8
                      CLEAN_STACK
                      ret
                      " L ":"
      ))))

(define add-lib-fun-vector-length
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'vector-length ftable))
      (B (lambda_body_start))
      (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                          
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                              
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_VECTOR
                      jne ERROR
                      mov rcx, [rdx]
                      VECTOR_LENGTH rcx
                      MAKE_INT rcx
                      test_malloc 8
                      mov [rax], rcx
                      CLEAN_STACK
                      ret
                      " L ":"
      ))))

(define add-lib-fun-string-length
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'string-length ftable))
      (B (lambda_body_start))
      (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_STRING
                      jne ERROR
                      mov rcx, [rdx]
                      STRING_LENGTH rcx
                      MAKE_INT rcx
                      test_malloc 8
                      mov [rax], rcx
                      CLEAN_STACK
                      ret
                      " L ":"
      ))))

(define add-lib-fun-positive?
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'positive? ftable))
      (negative (negative_l))
      (positive (positive-label))
      (test_integer (test_l))
      (test_fraction (test_l))
      (finish_l (finish_label))
      (B (lambda_body_start))
      (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_INTEGER
                      je "test_integer"
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      je "test_fraction"
                      jmp ERROR
                      "test_integer ":
                      mov rax, [rdx]
                      DATA rax
                      cmp rax,0
                      jg "positive"
                      mov rax, const_3
                      jmp "finish_l"
                      "test_fraction":
                      mov rax, [rdx]
                      CAR rax
                      DATA rax
                      cmp rax,0
                      jg "positive"
                      mov rax,const_3
                      jmp "finish_l"
                      "positive":
                      mov rax, const_4
                      jmp "finish_l"
                      "finish_l":
                      CLEAN_STACK
                      ret
                      " L ":"
      ))))

(define multiple_l
  (^make_label "multiple"))

(define compare_second_l
  (^make_label "compare_second"))

(define divide_l
  (^make_label "divide"))

(define add-lib-fun-b_div
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'b_div ftable))
          (compare_second (compare_second_l))
          (divide (divide_l))
          (multiple (multiple_l))
          (switch (divide_l))
          (B (lambda_body_start))
          (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                          
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 2
                      jne ERROR
                          
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get 2nd param
                      ;*** check_first ***
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_FRACTION
                      je " compare_second "
                      cmp rax, T_INTEGER
                      jne ERROR
                      ;*** change one to fraction ***

                      mov rax, const_5                 
                      MAKE_FRACTION rdx, rax
                      test_malloc 8
                      mov [rax], rdx
                      mov rdx, rax

                      ;*** check second ***
                      "compare_second ":
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      je "switch"
                      cmp rax, T_INTEGER
                      jne ERROR
                      ;this is integer - divide in zero handling
                      mov rax, [rbx]
                      DATA rax
                      cmp rax, 0
                      je ERROR

                      ;***change second to fraction ***
                      mov rax, const_5                 
                      MAKE_FRACTION rbx, rax
                      test_malloc 8
                      mov [rax], rbx
                      mov rbx, rax

                      ;***both are fractions time to divide
                      "switch":
                      ;***first switch second mone with mechane
                      mov r8, [rbx]
                      CAR r8 ;mone
                      mov rcx, r8 ; check if negative
                      DATA rcx
                      cmp rcx, 0
                      jg "divide"
                      ;***Change negative
                      mov r10, rdx
                      mov rax, rcx ;old mone
                      mov rcx, -1
                      mul rcx
                      mov rcx, rax
                      MAKE_INT rcx
                      test_malloc 8
                      mov [rax], rcx
                      mov r9, rax ;new mechane
                      mov rax, [rbx]
                     
                      CDR rax ; old mechane
                      DATA rax
                      mov rcx, -1
                      mul rcx
                      mov r8, rax
                      MAKE_INT r8
                      test_malloc 8
                      mov [rax], r8
                      mov rbx, rax ; new mone
                      MAKE_FRACTION rbx, r9                     
                      test_malloc 8
                      mov [rax], rbx
                      mov rbx, rax ; put new second in rbx
                      mov rdx, r10
                      jmp "multiple"
                      
                      "divide":
                      mov r8, [rbx]
                      mov rbx, [rbx]
                      CDR rbx ; mone
                      CAR r8 ; mechane
                      test_malloc 8
                      mov [rax], r8
                      mov r8, rax
                      test_malloc rbx
                      mov [rax], rbx
                      mov rbx, rax
                      MAKE_FRACTION rbx, r8 ; switch mone and mechane
                      test_malloc 8
                      mov [rax], rbx
                      mov rbx, rax ; put new second in rbx
                      
                      ;***all ready time to multiple
                      "multiple":
                      MUL_FRACTION rdx, rbx
                      MAKE_FRACTION rdx, rbx
                      REDUCE rdx
                      REMOVE_FRACTION rdx
                      test_malloc 8
                      mov [rax],rdx      
                      CLEAN_STACK
                      ret
                      
                      " L ":
                      ")
      ))) 


(define add-lib-fun-b_mul
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'b_mul ftable))
          (compare_second (compare_second_l))
          (multiple (multiple_l))
          (B (lambda_body_start))
          (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                          
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 2
                      jne ERROR
                          
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get 2nd param
                      ;*** check_first ***
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_FRACTION
                      je " compare_second "
                      cmp rax, T_INTEGER
                      jne ERROR
                      ;*** change one to fraction ***

                      mov rax, const_5                 
                      MAKE_FRACTION rdx, rax
                      test_malloc 8
                      mov [rax], rdx
                      mov rdx, rax

                      ;*** check second ***
                      "compare_second ":
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      je "multiple"
                      cmp rax, T_INTEGER
                      jne ERROR

                      ;***change second to fraction ***
                      mov rax, const_5                 
                      MAKE_FRACTION rbx, rax
                      test_malloc 8
                      mov [rax], rbx
                      mov rbx, rax

                      ;***both are fractions time to multiple
                      "multiple":
                      MUL_FRACTION rdx, rbx
                      MAKE_FRACTION rdx, rbx
                      REDUCE rdx
                      REMOVE_FRACTION rdx
                      test_malloc 8
                      mov [rax],rdx      
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))          




(define add-lib-fun-b_plus
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'b_plus ftable))
          (check_fraction_2-1 (check_fraction_l))
          (check_fraction_2-2 (check_fraction_l))
          (check_fraction_1-1 (check_fraction_l))
          (int_with_fract (int_with_fract_l))
          (both_fraction (both_fraction_l))
          (finish_add (finish_add_l))
          (B (lambda_body_start))
          (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                          
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 2
                      jne ERROR
                          
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get 2nd param
                      ;*** check_first ***
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne " check_fraction_1-1 "
                      
                      ;*** first: integer check second *****
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne " check_fraction_2-1 "
                      
                      ; **** both are integer *****
                      mov rdx, [rdx]
                      mov rbx, [rbx]                     
                      DATA rdx
                      DATA rbx
                      add rdx, rbx
                      MAKE_INT rdx
                      jmp " finish_add "
                      
                      " check_fraction_1-1 ":
                      
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      jne ERROR
                      
                      ;**first: fraction check second **

                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      je " both_fraction "
                      cmp rax, T_INTEGER
                      jne ERROR
                      
                      ; first: fraction second: integer

                      jmp " int_with_fract "

                      " check_fraction_2-1 ":
                      
                      ;first: integer check second

                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      jne ERROR

                      ;first: integer second: fraction
                      ;change between rbx and rdx
                      mov r8, rdx
                      mov rdx, rbx
                      mov rbx, r8

                      jmp "int_with_fract "
                  
                      " check_fraction_2-2 ":

                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      jne ERROR                    
                      " both_fraction ":
                      
                      ADD_FRACTION rdx, rbx               
                      MAKE_FRACTION rdx, rbx
                      REDUCE rdx
                      REMOVE_FRACTION rdx              
                      jmp " finish_add "

                      " int_with_fract ":
                      ;fraction in rdx, integer in rbx
                      mov r11,[rdx] ;- fraction
                      mov r9, [rbx] ;- integer 3
                      mov rax,r11 ; fraction
                      CAR r11 ; addr mone fraction
                      DATA r11 ; value mone fraction 1
                      CDR rax ; addr mechane fraction
                      mov rbx,rax; save mechane addr
                      DATA rax ; value mechane fraction 2
                      xor rdx,rdx
                      DATA r9; value integer
                      mul r9 
                      add rax, r11 ; new mone
                      mov r9, rax
                      MAKE_INT r9
                      test_malloc 8
                      mov [rax], r9
                      mov rdx, rax 
                      test_malloc 8
                      mov [rax], rbx
                      mov rbx, rax
                      MAKE_FRACTION rdx, rbx
                      REDUCE rdx
                      REMOVE_FRACTION rdx 

                      " finish_add ":
                      test_malloc 8
                      mov [rax],rdx
                                            
                      CLEAN_STACK
                      ret
                     
                      " L ":
                      ")
      )))

(define continue-l
  (^make_label "continue_label"))

(define add-lib-fun-b_equal
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'b_equal ftable))
          (check_fraction_2-1 (check_fraction_l))
          (check_fraction_2-2 (check_fraction_l))
          (check_fraction_1-1 (check_fraction_l))
          (both_fraction (both_fraction_l))
          (continue (continue-l))
          (equal_label (equal-l))
          (finish_add (finish_add_l))
          (error_l (error-label))
          (B (lambda_body_start))
          (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                          
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 2
                      jne ERROR
                          
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get 2nd param
                      ;*** check_first ***
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne " check_fraction_1-1 "
                      
                      ;*** first: integer check second *****
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne " check_fraction_2-1 "
                      
                      ; **** both are integer *****
                      mov rdx, [rdx]
                      mov rbx, [rbx]                     
                      DATA rdx
                      DATA rbx
                      cmp rdx, rbx
                      je "equal_label "
                      mov rax, const_3                   
                      jmp " finish_add "
                      " check_fraction_1-1 ":
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      jne ERROR
                      
                      ;**first: fraction check second **
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      je " both_fraction "
                      cmp rax, T_INTEGER
                      jne ERROR
                      
                      ; first: fraction second: integer                   
                      mov rax, const_3
                      jmp "finish_add"
                      
                      " check_fraction_2-1 ":
                      
                      ;first: integer check second
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER;
                      jne " check_fraction_2-2 "
                      ;first: integer second: fraction                      
                      mov rax, const_3
                      jmp " finish_add "
                      
                      " check_fraction_2-2 ":
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      jne ERROR                    
                      " both_fraction ":
                      mov rdx, [rdx] ;first number
                      mov rbx, [rbx] ;second number
                      mov rax, rdx
                      CAR rax ; mone1
                      mov rcx, rbx
                      CAR rcx ; mone2
                      cmp rax, rcx
                      je " continue "
                      mov rax, const_3
                      jmp "finish_add "
                      "continue ":              
                      mov rax, rdx
                      CDR rax ; mone1
                      mov rcx, rbx
                      CDR rcx ; mone2
                      cmp rax, rcx             
                      mov rax, const_3
                      jne " finish_add " 
                      "equal_label ":        
                      mov rax, const_4
                      " finish_add ":                  
                      CLEAN_STACK
                      ret
                      
                      " L ":
                      ")
      )))


(define add-lib-fun-b_minus
  (lambda (ftable)
    (let* ((addr (lookup-fvar 'b_minus ftable))
          (check_fraction_2-1 (check_fraction_l))
          (check_fraction_2-2 (check_fraction_l))
          (check_fraction_1-1 (check_fraction_l))
          (both_fraction (both_fraction_l))
          (finish_add (finish_add_l))
          (B (lambda_body_start))
          (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                          
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 2
                      jne ERROR
                          
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get 2nd para
                      ;*** check_first ***
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne " check_fraction_1-1 "
                      
                      ;*** first: integer check second *****
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne " check_fraction_2-1 "
                      
                      ; **** both are integer *****
                      mov rdx, [rdx]
                      mov rbx, [rbx]                     
                      DATA rdx
                      DATA rbx
                      sub rdx, rbx
                      MAKE_INT rdx
                      jmp " finish_add "
                      
                      " check_fraction_1-1 ":
                      
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      jne ERROR
                      
                      ;**first: fraction check second **
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      je " both_fraction "
                      cmp rax, T_INTEGER
                      jne ERROR
                      
                      ; first: fraction second: integer                   
                      
                      mov rax, const_5                 
                      MAKE_FRACTION rbx, rax
                      test_malloc 8
                      mov [rax], rbx
                      mov rbx, rax
                                         
                      jmp " both_fraction "
                      
                      " check_fraction_2-1 ":
                      
                      ;first: integer check second
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne " check_fraction_2-2 "
                      ;first: integer second: fraction
                                               
                      mov rax, const_5                 
                      MAKE_FRACTION rdx, rax
                      
                      test_malloc 8
                      mov [rax], rdx
                      mov rdx, rax
                                              
                      jmp " both_fraction "
                      
                      " check_fraction_2-2 ":
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      jne ERROR                    
                      " both_fraction ":
                      
                      NEG_FRACTION rbx
                      
                      ADD_FRACTION rdx, rbx 
                                 
                      MAKE_FRACTION rdx, rbx
                      REDUCE rdx
                      REMOVE_FRACTION rdx              
                      
                      " finish_add ":
                      test_malloc 8
                      mov [rax],rdx                      
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))


(define add-lib-fun-zero?
  (lambda (ftable)
    (let ((addr (lookup-fvar 'zero? ftable))
          (cmp_f_label (cmp_false))
          (finish_l (finish_label))
          (B (lambda_body_start))
          (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rdx, [rdx]
                      cmp rdx, T_INTEGER
                      jne " cmp_f_label "
                      mov rax, const_4 ; #t
                      jmp " finish_l "
                      " cmp_f_label ":
                      mov rax, const_3 ; #f
                      " finish_l ":    
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))


(define add-lib-fun-not
  (lambda (ftable)
    (let ((addr (lookup-fvar 'not ftable))
          (cmp_f_label (cmp_false))
          (finish_l (finish_label))
          (B (lambda_body_start))
          (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                          
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rdx, qword[rbp + 4*8] ;get first param
                      cmp rdx, const_3
                      jne " cmp_f_label "
                      mov rax, const_4 ; #t
                      jmp " finish_l "
                      " cmp_f_label ":
                      mov rax, const_3 ; #f
                      " finish_l ":    
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

(define add-lib-fun-vector? 
  (lambda (ftable)
    (let ((addr (lookup-fvar 'vector? ftable))
         (B (lambda_body_start))
         (L (lambda_body_end))
         (cmp_f_label (cmp_false))
         (finish_l (finish_label)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      TYPE rax
                      cmp rax, T_VECTOR
                      jne " cmp_f_label "
                      mov rax,const_4
                      jmp " finish_l "
                      " cmp_f_label ":
                      mov rax,const_3
                      " finish_l ":
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

(define add-lib-fun-pair? 
  (lambda (ftable)
    (let ((addr (lookup-fvar 'pair? ftable))
         (B (lambda_body_start))
         (L (lambda_body_end))
         (cmp_f_label (cmp_false))
         (finish_l (finish_label)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      TYPE rax
                      cmp rax, T_PAIR
                      jne " cmp_f_label "
                      mov rax,const_4
                      jmp " finish_l "
                      " cmp_f_label ":
                      mov rax,const_3
                      " finish_l ":
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

(define add-lib-fun-procedure? 
  (lambda (ftable)
    (let ((addr (lookup-fvar 'procedure? ftable))
         (B (lambda_body_start))
         (L (lambda_body_end))
         (cmp_f_label (cmp_false))
         (finish_l (finish_label)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      TYPE rax
                      cmp rax, T_CLOSURE
                      jne " cmp_f_label "
                      mov rax,const_4
                      jmp " finish_l "
                      " cmp_f_label ":
                      mov rax,const_3
                      " finish_l ":
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

(define add-lib-fun-string? 
  (lambda (ftable)
    (let ((addr (lookup-fvar 'string? ftable))
         (B (lambda_body_start))
         (L (lambda_body_end))
         (cmp_f_label (cmp_false))
         (finish_l (finish_label)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      TYPE rax
                      cmp rax, T_STRING
                      jne " cmp_f_label "
                      mov rax,const_4
                      jmp " finish_l "
                      " cmp_f_label ":
                      mov rax,const_3
                      " finish_l ":
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

(define add-lib-fun-rational? 
  (lambda (ftable)
     (let ((addr-src (lookup-fvar 'number? ftable))
          (addr-dest (lookup-fvar 'rational? ftable)))
       (string-append "
                      mov rax, qword["addr-src"]
                      mov qword["addr-dest"],rax
                      "))))
                      
                      
    
(define add-lib-fun-number? 
  (lambda (ftable)
    (let ((addr (lookup-fvar 'number? ftable))
         (B (lambda_body_start))
         (L (lambda_body_end))
         (cmp_f_label (cmp_false))
         (cmp_t_label (cmp_true))
         (finish_l (finish_label)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne " cmp_f_label "
                      mov rax, const_4
                      jmp " finish_l "
                      " cmp_f_label ":
                      cmp rax, T_FRACTION
                      je " cmp_t_label "
                      mov rax,const_3
                      jmp " finish_l "
                      " cmp_t_label ":
                      mov rax, const_4                            
                      " finish_l ":
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))


(define add-lib-fun-null?
  (lambda (ftable)
    (let ((addr (lookup-fvar 'null? ftable))
          (cmp_f_label (cmp_false))
          (finish_l (finish_label))
          (B (lambda_body_start))
          (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rdx,[rdx]
                      mov rax, qword[const_2] ;nil
                      cmp rdx, rax
                      jne " cmp_f_label "
                      mov rax, const_4 ; #t
                      jmp " finish_l "
                      " cmp_f_label ":
                      mov rax, const_3 ; #f
                      " finish_l ":    
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

(define add-lib-fun-char->integer 
  (lambda (ftable)
    (let ((addr (lookup-fvar 'char->integer ftable))
         (B (lambda_body_start))
         (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rdx,[rdx]
                      mov rax, rdx
                      TYPE rax
                      cmp rax, T_CHAR
                      jne ERROR
                          
                      test_malloc 8
                   
                      shr rdx, TYPE_BITS
                      shl rdx, TYPE_BITS
                      or rdx, T_INTEGER
                     
                      mov [rax],rdx
                          
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))


(define add-lib-fun-integer->char
  (lambda (ftable)
    (let ((addr (lookup-fvar 'integer->char ftable))
         (B (lambda_body_start))
         (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rdx,[rdx]
                      mov rax, rdx
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR   
                      test_malloc 8
                      DATA rdx
                      shl rdx, TYPE_BITS
                      or rdx, T_CHAR
                      mov [rax],rdx
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

(define add-lib-fun-list->vector
  (lambda (ftable)
    (let ((addr (lookup-fvar 'list->vector ftable))
         (loop_enter (loop_label_enter))
         (loop_exit (loop_label_exit))
         (B (lambda_body_start))
         (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      ;mov rax,[rax]
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      mov rcx, qword[rbp + 3*8] ; n
                      mov rdx, qword[rbp + 4*8] ;get first param - list
                      mov rbx, qword[rbp + 5*8] ;get second param - length
                      cmp rcx, 2
                      jne ERROR
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_PAIR
                      jne ERROR
                      mov r8, [rdx]
                      mov rsi, 0
                      mov r11, [rbx]
                      DATA r11
                      mov rbx, r11
                      shl rbx, 3
                      test_malloc rbx
                      mov r10, rax ; r10 holds the begining of the malloc

                      "loop_enter":
                      cmp rsi, r11
                      je "loop_exit"
                      mov rdx, r8
                      CAR r8
                      check:

                      test_malloc 8


                      mov [rax], r8
                      mov [r10+rsi*8], rax
                      add rsi, 1
                      CDR rdx
                      mov r8, rdx
                      jmp "loop_enter"

                      "loop_exit":
                      mov rax, r10
                      shl rsi, 3
                      add r10, rsi
                      MAKE_VECTOR rax, r10
                      test_malloc 8
                      mov [rax], r10
                      CLEAN_STACK
                      ret

                      " L ":
                      ")
      )))

(define add-lib-fun-cons 
  (lambda (ftable)
    (let ((addr (lookup-fvar 'cons ftable))
         (B (lambda_body_start))
         (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      ;mov rax,[rax]
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                          
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 2
                      jne ERROR
                          
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get sec param
                      MAKE_PAIR rdx, rbx
                      test_malloc 8
                      mov [rax], rdx   
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

;; lib fun for boolean? 
(define add-lib-fun-boolean? 
  (lambda (ftable)
    (let ((addr (lookup-fvar 'boolean? ftable))
         (B (lambda_body_start))
         (L (lambda_body_end))
         (cmp_f_label (cmp_false))
         (finish_l (finish_label)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      TYPE rax
                      cmp rax, T_BOOL
                      jne " cmp_f_label "
                      mov rax, const_4
                      jmp " finish_l "
                      " cmp_f_label ":
                      mov rax,const_3
                      " finish_l ":
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

(define add-lib-fun-remainder 
  (lambda (ftable)
    (let ((addr (lookup-fvar 'remainder ftable))
         (B (lambda_body_start))
         (L (lambda_body_end))
         (positive (positive-label))
         (finish_l (finish_label)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 2
                      jne ERROR
                          
                      mov rdx, qword[rbp + 4*8]
                      mov rbx, qword[rbp + 5*8]    
                      mov rax,[rdx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR
                      mov rax,[rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR
                      mov rax, [rdx]
                      DATA rax
                      mov r9, rax
                      mov r8,rax
                      cmp r8, 0
                      jg .positive
                      neg r8
                      .positive:
                      mov rax, r8
                      xor rdx, rdx
                      mov rbx, [rbx]
                      DATA rbx
                      idiv rbx
                      cmp r9, 0
                      jg " positive "
                      neg rdx         
                      "positive":               
                      MAKE_INT rdx
                      test_malloc 8
                      mov [rax], rdx                          
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

(define add-lib-fun-symbol? 
  (lambda (ftable)
    (let ((addr (lookup-fvar 'symbol? ftable))
         (B (lambda_body_start))
         (L (lambda_body_end))
         (cmp_f_label (cmp_false))
         (finish_l (finish_label)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rax,[rax]
                      TYPE rax
                      cmp rax, T_SYMBOL
                      jne " cmp_f_label "
                      mov rax, const_4
                      jmp " finish_l "
                      " cmp_f_label ":
                      mov rax,const_3
                      " finish_l ":
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))


(define add-lib-fun-integer? 
  (lambda (ftable)
    (let ((addr (lookup-fvar 'integer? ftable))
         (B (lambda_body_start))
         (L (lambda_body_end))
         (cmp_f_label (cmp_false))
         (finish_l (finish_label)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rax,[rax]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne " cmp_f_label "
                      mov rax, const_4
                      jmp " finish_l "
                      " cmp_f_label ":
                      mov rax,const_3
                      " finish_l ":
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

;; lib fun for char?
(define add-lib-fun-char? 
  (lambda (ftable)
    (let ((addr (lookup-fvar 'char? ftable))
         (B (lambda_body_start))
         (L (lambda_body_end))
         (cmp_f_label (cmp_false))
         (finish_l (finish_label)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rax,[rax]
                      TYPE rax
                      cmp rax, T_CHAR
                      jne " cmp_f_label "
                      mov rax, const_4
                      jmp " finish_l "
                      " cmp_f_label ":
                      mov rax,const_3
                      " finish_l ":
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

(define add-lib-fun-eq? 
  (lambda (ftable)
    (let ((addr (lookup-fvar 'eq? ftable))
         (B (lambda_body_start))
         (L (lambda_body_end))
         (cmp_f_label (cmp_false))
         (finish_l (finish_label)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 2
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get secound param
                      cmp rax, rbx
                      jne " cmp_f_label "
                      mov rax, const_4 
                      jmp " finish_l "
                      " cmp_f_label ":
                      mov rax,const_3
                      " finish_l ":
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

(define check-integer-label
  (^make_label "check_integer"))

(define add-lib-fun-numerator
  (lambda (ftable)
    (let ((addr (lookup-fvar 'numerator ftable))
          (check-integer (check-integer-label))
          (finish_l (finish_label))
         (B (lambda_body_start))
         (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      mov rbx,rax
                      TYPE rax
                      cmp rax,T_FRACTION
                      jne " check-integer "
                      mov rax,rbx
                      packed_car rax
                      jmp "finish_l "
                      " check-integer ":
                      cmp rax, T_INTEGER
                      jne ERROR
                      mov rax, qword[rbp + 4*8] 
                      "finish_l ":     
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

(define add-lib-fun-denominator
  (lambda (ftable)
    (let ((addr (lookup-fvar 'denominator ftable))
          (check-integer (check-integer-label))
          (finish_l (finish_label))
         (B (lambda_body_start))
         (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      mov rbx,rax
                      TYPE rax
                      cmp rax,T_FRACTION
                      jne " check-integer "
                      mov rax,rbx
                      packed_cdr rax
                      jmp "finish_l "
                      " check-integer ":
                      cmp rax, T_INTEGER
                      jne ERROR
                      mov rax, const_5 
                      "finish_l ":     
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))


(define add-lib-fun-set-cdr!
  (lambda (ftable)
    (let ((addr (lookup-fvar 'set-cdr! ftable))
         (B (lambda_body_start))
         (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                          
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 2
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rbx, [rax]
                      TYPE rbx
                      cmp rbx,T_PAIR
                      JNE ERROR
                      mov rbx, [rax]
                      packed_car rbx
                      mov rdx, qword[rbp + 5*8]
                      MAKE_PAIR rbx, rdx
                      mov [rax], rbx
                      mov rax, const_1
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

(define add-lib-fun-set-car!
  (lambda (ftable)
    (let ((addr (lookup-fvar 'set-car! ftable))
         (B (lambda_body_start))
         (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                          
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 2
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rbx, [rax]
                      TYPE rbx
                      cmp rbx,T_PAIR
                      JNE ERROR
                      mov rbx, [rax]
                      packed_cdr rbx
                      mov rdx, qword[rbp + 5*8]
                      MAKE_PAIR rdx, rbx
                      mov [rax], rdx
                      mov rax, const_1
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))


(define add-lib-fun-car
  (lambda (ftable)
    (let ((addr (lookup-fvar 'car ftable))
         (B (lambda_body_start))
         (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      mov rbx,rax
                      TYPE rax
                      cmp rax,T_PAIR
                      JNE ERROR
                      mov rax,rbx
                      packed_car rax
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))

(define add-lib-fun-cdr
  (lambda (ftable)
    (let ((addr (lookup-fvar 'cdr ftable))
         (B (lambda_body_start))
         (L (lambda_body_end)))
      (string-append "
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ," B "
                      mov qword[" addr "], rax
                      jmp " L "
                      " B ":
                      push rbp
                      mov rbp, rsp
                      
                      mov r8, qword[rbp + 3 * 8]
                      cmp r8, 1
                      jne ERROR
                          
                      mov rax, qword[rbp + 4*8]
                      mov rax,[rax]
                      mov rbx,rax
                      TYPE rax
                      cmp rax,T_PAIR
                      JNE ERROR
                      mov rax,rbx
                      packed_cdr rax
                      CLEAN_STACK
                      ret
                      " L ":
                      ")
      )))
                      
              

(define build-ftable
    (lambda (list-fvars)
        (map (lambda (var) `(,var ,(fvar-label))) (list->set (append lib-funcs list-fvars)))))
        

    
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
      ((symbol? (car consts-lst))
       			(split-consts (cdr consts-lst) (append acc `(,(symbol->string (car consts-lst)) ,(car consts-lst)))))
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
       			(reverse (list->set  (reverse (append (list (void) '() #f #t 1 "ERROR") (split-consts init-consts '())))))))
      no_duplicates_list)))


(define fvar-label
    (^make_label "Lglob"))


;const label
(define make_const_label
  (^make_label "const"))

;const label
(define make_bucket_label
  (^make_label "bucket"))

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

(define last-bucket "bucket_0")

(define get-bucket
  (lambda ()
    (set! last-bucket (make_bucket_label))
    last-bucket))
    

      
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
       ((pair? val) `("T_PAIR" ,(lookup-const (car val) table) ,(lookup-const (cdr val) table)))
       ((symbol? val)
        (let ((next-bucket last-bucket))
        `("T_SYMBOL" ,(lookup-const (symbol->string val) table) ,(get-bucket) ,next-bucket))))
    ))

;build the const table by iterating the const list, getting the type for the next const and building the table
; with the next const with unique label, table start empty, list start full, till list is empty and table is built
(define make-const-table
  (lambda (const-lst)
    (letrec ((iter
      (lambda (table lst addr)
       (if (null? lst) `(,table ,addr)
        (let ((type (get-const-type (car lst) table)))
            (iter `(,@table (,(car lst) ,(if (symbol? (car lst)) (caddr type) addr) ,type)) (cdr lst) (make_const_label)))))))
      (iter '() const-lst (make_const_label)))))

(define string-join
  (lambda (lst delimeter)
    (if (null? lst) ""
    (fold-left string-append (format "~A" (car lst)) (map (lambda (e) (format "~A~A" delimeter e) ) (cdr lst)))  
  )))

(define string-join-end
  (lambda (lst delimeter)
    (if (null? lst) ""
    (fold-left string-append "" (map (lambda (e) (format "~A~A" e delimeter) )  lst))  
  )))

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
         (if (null? (vector->list (car table-line))) 
              (format "\t\t~A:\n\t\t\tdq MAKE_LITERAL(~A,0)\n" addr type)
          (format "\t\t~A:\n\t\t\tMAKE_LITERAL_VECTOR ~A\n" 
                 addr (string-join (map (lambda (e) (format "~A" e)) (cdr value)) ", "))))
        ((equal? type "T_FRACTION") 
         (format "\t\t~A:\n\t\t\tdq MAKE_LITERAL_FRACTION(~A,~A)\n" addr (cadr value) (caddr value)))
        ((equal? type "T_SYMBOL")
         (let ((bucket_label (caddr value))
               (next_bucket (cadddr value))
               (sym_string (cadr value)))
           (string-append "
                          "bucket_label ":
                          	dq MAKE_SYMBOL_BUCKET("sym_string","next_bucket")
                          ")))
          
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

(define lookup-fvar
  (lambda (var ftable)
    (cond 
      ((null? ftable) 'Error)
      ((eq? var (caar ftable)) (cadr (car ftable)))
      (else (lookup-fvar var (cdr ftable)))))
  )

;generating one expr code in assembly, depend on type
(define code-gen
  (lambda (expr major ctable ftable)
    (cond 
       ((eq? 'const (car expr))
        	(let* ((value (cadr expr))
                  (addr (lookup-const value ctable)))
           		       (format "MOV RAX,~A
                             " addr)))

       ((eq? 'if3 (car expr))
          (let* ((if_test (cadr expr))
                 (if_then (caddr expr))
                 (if_else (cadddr expr))
                 (label_else (make_if_else_label))
                 (label_exit (make_if_exit_label)))
                    (format "~A
                            mov rax, [rax]
                            CMP RAX,QWORD[~A]
                            JE ~A
                            ~A
                            jmp ~A
                            ~A:
                            ~A
                            ~A:" 
                    (code-gen if_test major ctable ftable) (lookup-const #f ctable) label_else (code-gen if_then major ctable ftable) label_exit label_else (code-gen if_else major ctable ftable) label_exit)))
       
       ((eq? 'or (car expr))
          (let ((label_exit (make_or_exit_label)))
        (letrec ((iter
          (lambda (exp rest ans)
            (if (not (null? rest))
              (let ((ans (string-append ans 
                    (format "
                           ~A
                           mov rbx,[rax] 
                           CMP RBX, QWORD[~A] ; #f
                           JNE ~A
                           "
                  (code-gen exp major ctable ftable) (lookup-const #f ctable) label_exit))))
                (iter (car rest) (cdr rest) ans))
              (string-append ans
                      (format 
                            "~A
                             "
                  (code-gen exp major ctable ftable)))
              ))))
        (string-append (iter (car (cadr expr)) (cdr (cadr expr)) "") 
                    (format "~A:" label_exit))
        )))

       ((eq? 'seq (car expr))
        (fold-left string-append "" (map (lambda (exp) (code-gen exp major ctable ftable)) (cadr expr))))
        
       ((eq? 'lambda-simple (car expr))
            (code-gen-lambda-simple expr major ctable ftable))
       ((eq? 'lambda-opt (car expr))
            (code-gen-lambda-opt expr major ctable ftable))
       ((eq? 'applic (car expr))
            (code-gen-applic expr major ctable ftable))
       ((eq? 'tc-applic (car expr))
            (code-gen-tc-applic expr major ctable ftable))
       ((eq? 'pvar (car expr))
            (code-gen-pvar expr major ctable ftable))
       ((eq? 'bvar (car expr))
            (code-gen-bvar expr major ctable ftable))
       ((eq? 'fvar (car expr))
            (code-gen-fvar expr major ctable ftable))
       ((or (eq? 'set (car expr)) (eq? 'define (car expr)))
            (code-gen-setNdefine expr major ctable ftable))
       ((eq? 'box (car expr))
            (code-gen-box expr major ctable ftable))
       ((eq? 'box-get (car expr))
            (code-gen-box-get expr major ctable ftable))
       ((eq? 'box-set (car expr))
            (code-gen-box-set expr major ctable ftable))
       (else 
         (string-append "
                        jmp ERROR
                        "))
  )))


  (define code-gen-box-set 
    (lambda (expr major ctable ftable)
      (let ((var (cadr expr))
            (value (caddr expr)))
        (format "
                ~A
                mov rbx,rax
                ~A
                mov qword[rax],rbx
                mov rax,const_1
                " (code-gen value major ctable ftable) (code-gen var major ctable ftable)))))
  
  (define code-gen-box-get 
    (lambda (expr major ctable ftable)
      (let ((var (cadr expr)))
        (format "
                ~A
                mov rax,qword[rax]
                " (code-gen var major ctable ftable)))))
              
  
  (define code-gen-box 
    (lambda (expr major ctable ftable)
      (let ((var (cadr expr)))
        (format "
                ~A
                mov rbx,rax
               	test_malloc 8
                mov qword[rax],rbx
                " (code-gen var major ctable ftable)))))
      
  (define code-gen-setNdefine
    (lambda (expr major ctable ftable)
      (let ((var (cadr expr))
            (value (caddr expr)))
        (cond
            ((eq? 'pvar (car var)) 
              (let ((mi (caddr var)))
                (format "~A
                         mov qword[rbp + (4+~A)*8],rax
                         mov rax, const_1
                        " (code-gen value major ctable ftable) mi)))
            ((eq? 'bvar (car var))
               (let ((mi (cadddr var))
                     (ma (caddr var)))
                 (format "~A
                          mov rbx, qword[rbp + 2*8]
                          mov rbx, qword[rbx + ~A*8]
                          mov qword[rbx + ~A*8], rax
                          mov rax, const_1 
                         " (code-gen value major ctable ftable) ma mi)))
            (else 
              (let ((fvar_location (lookup-fvar (cadr var) ftable)))
                (format "~A
                         mov qword[~A], rax
                         mov rax, const_1
                        " (code-gen value major ctable ftable) fvar_location)))
              
              ))))
  
  (define code-gen-fvar
      (lambda (expr major ctable ftable)
        (format "
                mov rax,qword[~A]
                " (lookup-fvar (cadr expr) ftable))))

  (define code-gen-pvar
        (lambda (expr major ctable ftable)
            (let ((minor (caddr expr)))
                    (format "mov rax, [rbp + (4+~A) * 8]\n" minor))))
                    
  (define code-gen-bvar
        (lambda (expr major ctable ftable)
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
    (lambda (expr major ctable ftable)
        (let* (
            (B (lambda_body_start))
            (L (lambda_body_end))
            (epilog (string-append
                    "
                   	test_malloc " (number->string (* 8 (+ 1 major))) "
                    mov rbx, rax
                    "))
              (extend-env
                (let* ((loop_enter1 (loop_label_enter))
                      (loop_exit1 (loop_label_exit))
                      (loop_enter2 (loop_label_enter))
                      (loop_exit2 (loop_label_exit)))
                    (string-append
                        "
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        " loop_enter1 ":
                        cmp rdi, " (number->string major) "
                        je " loop_exit1 " 
                        mov r10, [rax + rdi*8]              ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10        ;;  newenv[i+1] = env[i]    
                        inc rdi
                        jmp " loop_enter1 "
                        " loop_exit1 ":
                        mov r8, [rbp+8*3] ;n
                        add r8,1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        " loop_enter2 ":
                        cmp rdi , r8
                        je " loop_exit2 "
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
                        ;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp " loop_enter2 "
                        " loop_exit2 ":
                        mov [rbx], rcx
                        "
                    )))
            (make-closure
                (let ((closure_label (make_closure_label)))
                (string-append
                    "
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, " B "
                    jmp " L "
                    " B ":
                    push rbp
                    mov rbp, rsp
                    mov r8, qword[rbp+8*3]
                    cmp r8," (number->string (length (cadr expr))) "
                    jne ERROR    
                    " (code-gen (caddr expr) (+ 1 major) ctable ftable) "
                    CLEAN_STACK
                    ret
                    " L ":
                    "
                    ))))
                    
                (string-append epilog extend-env make-closure))
            ))
  
  
  (define code-gen-lambda-opt 
    (lambda (expr major ctable ftable)
        (let* (
            (B (lambda_body_start))
            (L (lambda_body_end))
            (body (cadddr expr))
            (fix-params (length (cadr expr)))
            (loop_enter (loop_label_enter))
            (loop_exit (loop_label_exit))
            (cons-label (lookup-fvar 'cons ftable))
            (epilog (string-append
                    "
                   	test_malloc " (number->string (* 8 (+ 1 major))) "
                    mov rbx, rax
                    "))
              (extend-env
                (let* ((loop_enter1 (loop_label_enter))
                      (loop_exit1 (loop_label_exit))
                      (loop_enter2 (loop_label_enter))
                      (loop_exit2 (loop_label_exit)))
                    (string-append
                        "
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        " loop_enter1 ":
                        cmp rdi, " (number->string major) "
                        je " loop_exit1 " 
                        mov r10, [rax + rdi*8]            ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10       ;;  env[i+1] = env[i]    
                        inc rdi
                        jmp " loop_enter1 "
                        " loop_exit1 ":
                        mov r8, [rbp+8*3] ;n
                        add r8, 1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        " loop_enter2 ":
                        cmp rdi , r8
                        je " loop_exit2 "
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
              			;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp " loop_enter2 "
                        " loop_exit2 ":
                        mov [rbx], rcx
                        "
                    )))
            (make-closure
                (let ((closure_label (make_closure_label)))
                (string-append
                    "
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, " B "
                    jmp " L "
                    " B ":
                    push rbp
                    mov rbp, rsp
                    mov r8, [rbp+3*8] ;n
                    sub r8, " (number->string fix-params) "
                    mov rdi, 8* " (number->string fix-params) "
                    add rdi, 3*8
                    mov rsi, r8
                    mov rax, const_2
                    " loop_enter ":
                    cmp rsi, 0
                    je " loop_exit "
                    push const_2
                    push rax
                    mov rax, rsi
                    shl rax,3
                    mov r10, rdi
                    add r10,rax
                    mov rax, qword[rbp + r10]
                    push rax
                    mov rax, [" cons-label "]
                    CALL_LIB_FUN rax, 2                    
                    dec rsi
                    jmp " loop_enter "
                    " loop_exit ":
                    mov [rbp + "(number->string (* 8 (+ 4 fix-params)))"], rax
                    " (code-gen (cadddr expr) (+ 1 major) ctable ftable) "
                    CLEAN_STACK
                    ret
                    " L ":
                    "
                ))))
                    
                (string-append epilog extend-env make-closure))
            ))
            
(define code-gen-applic
    (lambda (expr major ctable ftable)
        (let* ((params (caddr expr))
               (proc (cadr expr))
               (push-params
                (string-append "
                    mov rax, const_2
                    push rax
                    " 
                    (string-join-end (map (lambda (p) (code-gen p major ctable ftable)) (reverse params)) "\npush rax\n")
                    "
                    mov rax, " (number->string (length params)) "
                    push rax
                    "))
                (handle-proc
                    (string-append (code-gen proc major ctable ftable) "
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    ")))
                (string-append push-params handle-proc))))
                                    
                
(define code-gen-tc-applic
    (lambda (expr major ctable ftable)
        (let* ((params (caddr expr))
               (proc (cadr expr))
               (loop_enter (loop_label_enter))
               (loop_exit (loop_label_exit))
               (push-params 
                (string-append "
                    mov rax, const_2
                    push rax           
                    "
                    (string-join-end (map (lambda (p) (code-gen p major ctable ftable)) (reverse params)) "\npush rax\n")
                    "
                    mov rax, " (number->string (length params)) "
                    push rax                                           
                    "))
                (handle-proc
                    (string-append (code-gen proc major ctable ftable) "                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx             
                                    mov r11, qword[rbp + 8*3] ;n
                                    mov r12, r11                                  
                                    mov r8,rbp
                                    mov rbp,[rbp] ; rbp <= old rbp                                                                 
                                    mov rbx, [r8+8] ; old ret
                                    push rbx
                                    mov rdi,0
                                    mov r10, r11
                                    add r10, 5
                                    shl r10, 3                                  
                                    add r10,r8 ; r8 + 8 * (5+n)                                                                  
                                    " loop_enter ":
                                    cmp rdi, " (number->string (+ 4 (length params))) "
                                    je " loop_exit "
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp " loop_enter "
                                    " loop_exit ":                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    ")))
                (string-append push-params handle-proc))))  

;iterate over the list of exprs and call code-gen for each exprs, appending to it end the expected finish - result in rax, printing if not void, clean.
(define code-gen-fromlst
  (lambda (lst-expr ctable ftable code)
    (if (null? lst-expr) code 
        (code-gen-fromlst (cdr lst-expr) ctable  ftable
                  (string-append code 
                    (format "
                            ~A
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8" 
                    (code-gen (car lst-expr) 0 ctable ftable)))))
    ))

(define get-asm-ftable
    (lambda (scm-ftable)
        (if (null? scm-ftable) ""
              (string-append (cadr (car scm-ftable)) ":\n" "dq SOB_UNDEFINED\n" (get-asm-ftable (cdr scm-ftable))))))




;the main function called, reading from file in;
;building lst-exprs from assignment 1-3 and find all consts create ctable
;build the assembly backround code and call code-gen to compile the code given
(define compile-scheme-file 
  (lambda (in out)
    (let* ((lst-exprs (append scheme-functions  (pipeline (file->list in))))
    	   (ctable (make-const-table (get-consts lst-exprs)))
    	   (ftable (build-ftable (get-fvar-lsts lst-exprs)))
      	   (asm-ctable (string-append 
            "const_table:\n" 
             (get-asm-const-table (car ctable))))
           (asm-ftable (string-append
                "global_table:\n" (get-asm-ftable ftable)))
           
           (asm-lib-func 
             (string-append "
                            " (add-lib-fun-boolean? ftable) "
                            " (add-lib-fun-car ftable)  "
                            " (add-lib-fun-cdr ftable) "
                            " (add-lib-fun-char? ftable) "
                            " (add-lib-fun-eq? ftable) "
                            " (add-lib-fun-integer? ftable)"
                            " (add-lib-fun-cons ftable) "
                            " (add-lib-fun-char->integer ftable) "
                            " (add-lib-fun-null? ftable) "
                            " (add-lib-fun-zero? ftable) "
                            " (add-lib-fun-pair? ftable) "
                            " (add-lib-fun-number? ftable) "
                            " (add-lib-fun-apply ftable) "
                            " (add-lib-fun-b_plus ftable) "
                            " (add-lib-fun-b_minus ftable) "
                            " (add-lib-fun-vector? ftable) "
                            " (add-lib-fun-rational? ftable) "
                            " (add-lib-fun-string? ftable) "
                            " (add-lib-fun-procedure? ftable) "
                            " (add-lib-fun-numerator ftable) "
                            " (add-lib-fun-denominator ftable) "
                            " (add-lib-fun-set-car! ftable) "
                            " (add-lib-fun-set-cdr! ftable) "
                            " (add-lib-fun-remainder ftable) "
                            " (add-lib-fun-integer->char ftable) "
                            " (add-lib-fun-not ftable) "
                            " (add-lib-fun-b_equal ftable) "
                            " (add-lib-fun-positive? ftable) "
                            " (add-lib-fun-b_mul ftable)"
                            " (add-lib-fun-b_div ftable)"
                            " (add-lib-fun-string-length ftable)"
                            " (add-lib-fun-vector-length ftable)"
                            " (add-lib-fun-vector-ref ftable)"
                            " (add-lib-fun-string-ref ftable)"
                            " (add-lib-fun-symbol? ftable) "
                            " (add-lib-fun-string-set ftable) "
                            " (add-lib-fun-vector-set ftable) "
                            " (add-lib-fun-make-string ftable) "
                            " (add-lib-fun-make-vector ftable) "
                            " (add-lib-fun-symbol->string ftable) "
                            " (add-lib-fun-string->symbol ftable) "
                            " (add-lib-fun-list->vector ftable) "
                            "
                ))
           
           (asm-code (code-gen-fromlst lst-exprs (car ctable) ftable "\n"))
           
          	(asm-output 
          	(format "%include \"scheme.s\"\nsection .bss\nglobal main\nsection .data\n\t~A
            bucket_0:
                dq MAKE_SYMBOL_BUCKET(const_2, const_2)
            bucket_head:
                 dq 0
            ~A
          	section .text
          	\tmain:
                mov qword[bucket_head],~A
                mov rax, malloc_pointer
				        mov qword [rax], start_of_data2
                ~A
                push const_2
                mov rax, 0
                push rax
                mov rax, [const_2]
                push rax
                mov rax, 0x1234
                push rax
                push rbp
          	    mov rbp, rsp
                ~A
                jmp END
                ERROR:
                   push const_6
                   call write_sob_if_not_void
                   add rsp, 8
                   mov rdi, -1
                   call exit
                   jmp END
                END:
                add rsp, 5*8
          	    ret\n" asm-ctable asm-ftable last-bucket asm-lib-func asm-code))
          	)
      
      		
  			
     		 (string->file asm-output out)
        	;	(display asm-output)
         )))                