(define lambda?
  (lambda (expr)
    (eq? (car expr) 'lambda-simple) 	
    ))

(define lambda-opt? 
  (lambda (expr)
    (eq? (car expr) 'lambda-opt)
    ))

(define get-lambda-body
  (lambda (expr)
    (caddr expr)
      ))

(define get-opt-body
  (lambda (expr)
    (cadddr expr)
      ))

(define inbody? 
  (lambda (var body)
 	(cond 
	    ((null? body) #f)
	    ((not (list? body)) #f)
     	((or (lambda? body) (lambda-opt? body)) (free? var body))
	    ((equal? body `(var ,var)))
	    (else (or (inbody? var (car body)) (inbody? var (cdr body))))
)))

(define setInbody?
  (lambda (var body)
  (cond 
	    ((null? body) #f)
	    ((not (pair? body)) #f)
     	((or (lambda? body) (lambda-opt? body)) (if (member var (cadr body)) #f (setInbody? var (cdr body))))
	    ((and (eq? 'set (car body)) (equal? (cadr body) `(var ,var)) ))
	    (else (or (setInbody? var (car body)) (setInbody? var (cdr body))))
)))

(define getInbody?
  (lambda (var body)
  (cond  
	    ((null? body) #f)
	    ((not (pair? body)) #f)
     	((or (lambda? body) (lambda-opt? body)) (if (member var (cadr body)) #f (getInbody? var (cdr body))))
	    ((eq? 'set (car body)) (getInbody? var (caddr body) ))
     	((equal? body `(var ,var)))
	    (else (or (getInbody? var (car body)) (getInbody? var (cdr body))))
)))

(define free?
  (lambda (variable lambda-expr)
    (let ((body (if (lambda-opt? lambda-expr) (get-opt-body lambda-expr) (get-lambda-body lambda-expr))))
    (cond
      ((not (or (lambda-opt? lambda-expr) (lambda? lambda-expr))) #f) 
      ((member variable (cadr lambda-expr)) #f)
      ((and (lambda-opt? lambda-expr) (eq? variable (caddr lambda-expr)) ) #f)
      (else (inbody? variable body)))
    )))

(define has_bound_appearnce? 
  (lambda (var body)
    (cond 
      ((null? body) #f)
      ((not (pair? body)) #f) 
      ((or (lambda? body) (lambda-opt? body)) (free? var body))
      (else (or (has_bound_appearnce? var (car body)) (has_bound_appearnce? var (cdr body))))
     )))

(define should_box? 
  (lambda (var body) 
    (and 
      (has_bound_appearnce? var body)
      (setInbody? var body)
      (getInbody? var body)
    )))


(define handle-box3
  (lambda (var body)
	 (cond 
      ((null? body) body)
      ((not (pair? body)) body)
      ((lambda? body) 
       	(if (member var (cadr body)) 
            body 
            `(,(car body) ,(cadr body) ,(handle-box3 var (get-lambda-body body)))))
      ((lambda-opt? body)
       	(if (member var (append (cadr body) `(,(caddr body) ))) 
            body 
            `(,(car body) ,(cadr body) ,(caddr body) ,(handle-box3 var (get-opt-body body)))))
      ((eq? 'set (car body)) `(set ,(cadr body) ,(handle-box3 var (caddr body))))
      ((equal? body `(var ,var)) `(box-get (var ,var)))
	  (else (cons (handle-box3 var (car body)) (handle-box3 var (cdr body))))
  )))
  
(define handle-box2 
  (lambda (var body)
  	 (cond 
      ((null? body) body)
      ((not (pair? body)) body)
      ((lambda? body) 
       	(if (member var (cadr body)) 
            body 
            `(,(car body) ,(cadr body) ,(handle-box2 var (get-lambda-body body)))))
      ((lambda-opt? body)
       	(if (member var (append (cadr body) `(,(caddr body)) ))
            body
            `(,(car body) ,(cadr body) ,(caddr body) ,(handle-box2 var (get-opt-body body)))))
	  ((and (eq? 'set (car body)) (equal? (cadr body) `(var ,var))) (cons 'box-set (handle-box2 var(cdr body))))
	  (else (cons (handle-box2 var (car body)) (handle-box2 var (cdr body))))
  )))


(define handle-box1
  (lambda (vars oldbody newbody) 
    (let ((body (if (eq? (car newbody) 'seq) (cadr newbody) `(,newbody)))
          (params (filter (lambda (var) (should_box? var oldbody)) vars)))  
	   	`( ,@(map (lambda (var) 
	               `(set (var ,var) (box (var ,var))) ) params)
			,@body)
    )))

(define remove_unwanted_seq
  (lambda (lambda-expr) 
    (let* ((seqexpr (if (lambda-opt? lambda-expr) (get-opt-body lambda-expr) (get-lambda-body lambda-expr)))
           (seqbody (cadr seqexpr)))
      (if (null? (cdr seqbody))
          (if (lambda? lambda-expr)
          	`(,(car lambda-expr) ,(cadr lambda-expr) ,(car seqbody))
           `(,(car lambda-expr) ,(cadr lambda-expr) ,(caddr lambda-expr) ,(car seqbody)))
          lambda-expr)
      )
    )
  )

(define indexOf
  (lambda (var params counter)
      (cond 
        ((null? params) -1)
        ((eq? (car params) var) counter)
        (else (indexOf var (cdr params) (+ 1 counter)))
    )))

(define is-bound
  (lambda (var env counter)
    (cond 
      ((null? env) `(fvar ,var))
      (else
        (let ((position (indexOf var (car env) 0)))
          (if (< position 0)
              (is-bound var (cdr env) (+ 1 counter))
              `(bvar ,var ,counter ,position))  
      )))))

(define handle-var
  (lambda (var env) 
    (cond 
      ((null? env) `(fvar ,var))
      (else 
        (let ((position (indexOf var (car env) 0)))
          (if (< position 0) 
              (is-bound var (cdr env) 0)
              `(pvar ,var ,position))))
      )))

(define lex-pe-wrapped
  (lambda (exp env)
    (cond ((null? exp) exp)
          ((not (pair? exp)) exp)
          ((eq? (car exp) 'var) (handle-var (cadr exp) env))
          ((lambda-opt? exp)
           (let ((params (append (cadr exp) `(,(caddr exp)))))
            `(,(car exp) ,(cadr exp) ,(caddr exp) ,(lex-pe-wrapped (get-opt-body exp) `(,params ,@env)))))
          ((lambda? exp)
           `(,(car exp) ,(cadr exp) ,(lex-pe-wrapped (get-lambda-body exp) `(,(cadr exp) ,@env))))
          (else (cons (lex-pe-wrapped (car exp) env) (lex-pe-wrapped (cdr exp) env))) 
          )))

(define remove-applic-lambda-nil
  (lambda (exp)
    (cond
      ((null? exp) exp)
      ((not (list? exp)) exp)
      ((eq? 'applic (car exp))
         (if (and (lambda? (cadr exp)) (null? (caddr exp)) (null? (cadr (cadr exp))))
              (remove-applic-lambda-nil (caddr (cadr exp)))
              (cons (car exp) (remove-applic-lambda-nil (cdr exp)))))
      (else (cons (remove-applic-lambda-nil (car exp)) (remove-applic-lambda-nil (cdr exp)))))
    ))

(define box-set
  (lambda (exp)
    (cond 
      ((null? exp) exp)
      ((not (list? exp)) exp)
      ((or (lambda? exp) (lambda-opt? exp)) 
           		(letrec ((box-vars 
                       (lambda (params newbody) 
                         (let ((oldbody (if (lambda-opt? exp) (get-opt-body exp) (get-lambda-body exp))))
                         (if (null? params) newbody
                         	(let ((var (car params)))
                           		(if (should_box? var oldbody) 
                              		(box-vars (cdr params) (handle-box2 var (handle-box3 var newbody)))
                            		(box-vars (cdr params) newbody))))))))
     				(if (lambda? exp)
                 		(remove_unwanted_seq `(,(car exp) ,(cadr exp) (seq ,(handle-box1 (cadr exp) (get-lambda-body exp) (box-vars (cadr exp) (box-set (get-lambda-body exp)))))))
                   		(remove_unwanted_seq `(,(car exp) ,(cadr exp) ,(caddr exp) (seq ,(handle-box1 (append (cadr exp) `(,(caddr exp))) (get-opt-body exp) (box-vars (append (cadr exp) `(,(caddr exp))) (box-set (get-opt-body exp))))))))))     		
      (else (cons (box-set (car exp)) (box-set (cdr exp)))))
  ))

(define pe->lex-pe
  (lambda (exp)
    (lex-pe-wrapped exp '())
  ))

(define get-exprs 
  (lambda (exprs last?)
    (let ((reveseExprs (reverse exprs)))
      (if last? (car reveseExprs) (reverse (cdr reveseExprs)))) 
    ))

(define handle-or
  (lambda (or-exp tc)
    (let* ((or-lst (cadr or-exp))
      	   (last-exp (get-exprs or-lst #t))
           (rest-exp (get-exprs or-lst #f)))
      `(or (,@(map (lambda (exp) (annotate-tc-wrapper exp #f)) rest-exp) ,(annotate-tc-wrapper last-exp tc)))
    )))

 (define handle-seq
   (lambda (seq-exp tc)
      (let* ((seq-lst (cadr seq-exp))
      	   	(last-exp (get-exprs seq-lst #t))
           	(rest-exp (get-exprs seq-lst #f)))
      `(seq (,@(map (lambda (exp) (annotate-tc-wrapper exp #f)) rest-exp) ,(annotate-tc-wrapper last-exp tc)))) 
    ))
    
 (define handle-if
   (lambda (if-exp tc)
     (let ((_test (cadr if-exp))
           (_then (caddr if-exp))
           (_else (cadddr if-exp)))
       `(if3 ,(annotate-tc-wrapper _test #f) ,(annotate-tc-wrapper _then tc) ,(annotate-tc-wrapper _else tc)))
     ))
 
     
 (define handle-define
   (lambda (def-exp tc)
     (let ((var (cadr def-exp))
           (expr (caddr def-exp)))
       `(define ,var ,(annotate-tc-wrapper expr #f)))
     ))
 
 
 (define handle-lambda
   (lambda (lambda-exp tc)
      (if (lambda? lambda-exp)
          `(lambda-simple ,(cadr lambda-exp) ,(annotate-tc-wrapper (get-lambda-body lambda-exp) #t))
          `(lambda-opt ,(cadr lambda-exp) ,(caddr lambda-exp) ,(annotate-tc-wrapper (get-opt-body lambda-exp) #t )))
    ))
 
 (define handle-applic
   (lambda (applic-exp tc)
     (let ((proc (cadr applic-exp)) 
           (paramList (caddr applic-exp)))
           (if tc 
           		`(tc-applic ,(annotate-tc-wrapper proc #f) ,(map (lambda (exp) (annotate-tc-wrapper exp #f)) paramList))
    			`(applic ,(annotate-tc-wrapper proc #f) ,(map (lambda (exp) (annotate-tc-wrapper exp #f)) paramList))))
    ))
 
 (define handle-set
   (lambda (set-exp tc)
     (let ((value (caddr set-exp)))
       `(,(car set-exp) ,(cadr set-exp) ,(annotate-tc-wrapper value #f))))) 

(define annotate-tc-wrapper 
  (lambda (exp tc)
   (if (or (eq? (car exp) 'const) (eq? (car exp) 'pvar) (eq? (car exp) 'fvar) (eq? (car exp) 'bvar)) exp 
       (if (eq? (car exp) 'applic)
           (handle-applic exp tc)
		    (cond 
		      ((eq? (car exp) 'or) (handle-or exp tc))
		      ((eq? (car exp) 'if3) (handle-if exp tc))
		      ((eq? (car exp) 'define) (handle-define exp tc))
		      ((eq? (car exp) 'seq) (handle-seq exp tc))
        	  ((eq? (car exp) 'box-get) `(box-get ,(annotate-tc-wrapper (cadr exp) tc)))
           	  ((eq? (car exp) 'box) `(box ,(annotate-tc-wrapper (cadr exp) tc)))
        	  ((or (eq? (car exp) 'box-set) (eq? (car exp) 'set)) (handle-set exp tc))
		      ((or (lambda? exp) (lambda-opt? exp)) (handle-lambda exp tc))
		      (else `( bla ,exp)))
		))))

(define annotate-tc
  (lambda (exp)
  exp
    ;(annotate-tc-wrapper exp #f)
  ))