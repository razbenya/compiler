(load "qq.scm")

(define _take-right
	(lambda (_list)
  (if (not (pair? _list)) _list (_take-right (cdr _list)))))

(define _remove-last
	(lambda (_list)
  (if (not (pair? _list)) '() (cons (car _list) (_remove-last (cdr _list))))))

(define reserved-words
  '(and begin cond define do else if lambda
    let let* letrec or quasiquote unquote
  unquote-splicing quote set!))

(define var? 
  (lambda (expr)
   (and
    (symbol? expr)
    (not (member expr reserved-words))
  )
 ))

(define quasiquote? (^quote? 'quasiquote))

(define macro-expandr?
	(lambda (expr)
		(or 
			(and? expr)
			(cond? expr)
			(let? expr)
			(letrec? expr)
			(let*? expr)
		)))

(define all_diff?
	(lambda (bindings)
		(let ((vars (map car bindings)))
			(if (null? bindings)
				#t
				(if (member (car vars) (cdr vars))
					#f
       (all_diff? (cdr bindings)))))))

(define let?
	(lambda (expr)
		(and (list? expr)
			(eq? (car expr) 'let)
			(> (length expr) 2)
      (andmap (lambda (x) (and (= (length x) 2) (not (or (quasiquote? x) (quote? x))))) (cadr expr))
      (all_diff? (cadr expr))
    )))

(define letrec?
  (lambda (expr)
    (and (list? expr)
      (eq? (car expr) 'letrec)
      (> (length expr) 2)
      (andmap (lambda (x) (and (= (length x) 2) (not (or (quasiquote? x) (quote? x))))) (cadr expr))
      (all_diff? (cadr expr))
    )))

(define let*?
  (lambda (expr)
    (and (list? expr)
      (eq? (car expr) 'let*)
      (> (length expr) 2)
      ;(eq? '() (filter (lambda (y) (or (quote? y) (not (= (length y) 2)))) (cadr expr)))
      (andmap (lambda (x) (and (= (length x) 2) (not (or (quasiquote? x) (quote? x))))) (cadr expr))
    )))

(define and?
	(lambda (expr)
		(and (list? expr)
			(eq? (car expr) 'and)
   )))

(define cond?
	(lambda (expr)
		(and (list? expr)
			(eq? (car expr) 'cond)
      (not (null? (cdr expr)))
      (andmap (lambda (x) (and (list? x) (not (null? x)))) (cdr expr))
    )))

(define const?
  (lambda (expr)
    (or
      (null? expr)
      (vector? expr)
      (boolean? expr)
      (number? expr)
      (char? expr)
      (string? expr)
      (eq? (void) expr)
    )))

(define if2?
	(lambda (expr)
		(and (list? expr)
			(eq? (car expr) 'if)
			(= (length expr) 3)
   )))

(define if3?
	(lambda (expr)
		(and (list? expr)
			(eq? (car expr) 'if)
			(= (length expr) 4)
   )))

(define or0?
	(lambda (expr)
		(and (list? expr)
			(eq? (car expr) 'or)
			(= (length expr) 1)
   )))

(define or1?
	(lambda (expr)
		(and (list? expr)
			(eq? (car expr) 'or)
			(= (length expr) 2)
   )))

(define or?
	(lambda (expr)
		(and (list? expr)
			(eq? (car expr) 'or)
			(> (length expr) 2)
   )))

(define regular-lambda?
	(lambda (expr)
		(and (list? expr)
			(> (length expr) 2)
			(list? (cadr expr))
			(eq? (car expr) 'lambda)
   )))

(define opt-lambda?
	(lambda (expr)
		(and (list? expr)
			(> (length expr) 2)
			(and (not (list? (cadr expr))) (pair? (cadr expr)))
			(eq? (car expr) 'lambda)
   )))

(define variadic-lambda?
	(lambda (expr)
		(and (list? expr)
			(> (length expr) 2)
			(and (not (list? (cadr expr))) (not (pair? (cadr expr))))
			(eq? (car expr) 'lambda)
   )))

(define define?
	(lambda (expr)
		(and (list? expr)
			(eq? (car expr) 'define)
			(= (length expr) 3)
			(var? (cadr expr))
   )))

(define define-mit?
	(lambda (expr)
		(and (list? expr)
			(eq? (car expr) 'define)
			(> (length expr) 2)
			(not (var? (cadr expr)))
   )))

(define set?
	(lambda (expr)
		(and (list? expr)
			(eq? (car expr) 'set!)
			(= (length expr) 3)
   )))

(define app?
	(lambda (expr)
		(and (list? expr)
			(not (eq? 'seq (car expr)))
			(not (member (car expr) reserved-words))
   )))

(define seq?
	(lambda (expr)
		(and (list? expr)
			(eq? (car expr) 'begin)
   )))

(define macro-expand
	(lambda (expr)
		(cond
    ;******************* and *************************
      ((and? expr)
        (if (null? (cdr expr)) #t
          (if (null? (cddr expr))(cadr expr)
            `(if ,(cadr expr) ,(macro-expand `(and ,@(cddr expr))) ,#f)
        )))

    ;******************* cond *****************************
      ((cond? expr)
        (let ((pe (map (lambda(x) (if (= (length x) 1)  (cons #t x) x)) (cdr expr))))
          (if (eq? 'else (caadr expr))  `(begin ,@(cdadr expr))
            (if (null? (cdr expr))
              `(if ,(caar pe) (begin ,@(cdar pe)))
              `(if ,(caar pe) (begin ,@(cdar pe)) ,(macro-expand `(cond ,@(cdr pe))))
            ))))

    ;******************* let *****************************
      ((let? expr)
        (let ((vars (map car (cadr expr)))
        (values (map cadr (cadr expr))))
        `((lambda (,@vars) ,@(cddr expr)),@values)))

    ;****************** letrec ****************************
      ((letrec? expr)
        (let ((vars (map car (cadr expr)))
        (values (map cadr (cadr expr))))
        `(let (,@(map (lambda (x) `(,x ,#f)) vars)) ,@(map (lambda(v e) `(set! ,v ,e)) vars values) ((lambda() ,@(cddr expr))))
      ))

      ;****************** let* ****************************
      ((let*? expr)
        (let ((bindings (cadr expr))
        (body (cddr expr)))
        (if (or (null? bindings) (null? (cdr bindings)))
          `(let ,bindings ,@body)
          `(let (,(car bindings)) ,(macro-expand` (let* ,(cdr bindings) ,@body)))
        )))

      ;(else expr)         
    )))

(define parse
  (lambda (sexp)
    (cond 
      ;********************* const ************************
      ((const? sexp) `(const ,sexp))
      
      ;********************* quote's **********************
      ((quasiquote? sexp) (parse (expand-qq (cadr sexp))))
      ((quote? sexp) `(const ,@(cdr sexp)))

      ;********************* var ************************
      ((var? sexp) `(var ,sexp))

      ;********************* if ************************
      ((if2? sexp)
      (parse (append sexp (list (void)))))

      ((if3? sexp)
        (let ((_test (cadr sexp))
          (_then (caddr sexp))
        (_else (cadddr sexp)))
      `(if3 ,(parse _test) ,(parse _then) ,(parse _else))))

      ;********************* or ************************
      ((or0? sexp) (parse #f))
      ((or1? sexp)  (parse (cadr sexp)))
      ((or? sexp) `(or (,@(map parse (cdr sexp)))))

      ;********************* lambda ************************
      ((regular-lambda? sexp)
        (let ((_args (cadr sexp))
        (_body (cddr sexp)))
      `(lambda-simple ,_args ,(parse `(begin ,@_body)))))

      ((opt-lambda? sexp)
        (let ((_args (_remove-last (cadr sexp)))
          (_rest (_take-right (cadr sexp)))
        (_body (cddr sexp)))
      `(lambda-opt ,_args ,_rest ,(parse `(begin ,@_body)))))

      ((variadic-lambda? sexp)
        (let ((_args (cadr sexp))
        (_body (cddr sexp)))
      `(lambda-opt () ,_args ,(parse `(begin ,@_body)))))

        ;********************* define ************************
        ((define? sexp)
          (let ((_var (cadr sexp))
          (_expr (caddr sexp)))
        `(define ,(parse _var) ,(parse _expr))))

        ((define-mit? sexp)
        `(define ,(parse (caadr sexp)) ,(parse `(lambda ,(cdr (cadr sexp)) ,@(cddr sexp)))))

        ;********************* set ************************
        ((set? sexp)
          (let ((_var (cadr sexp))
          (_expr (caddr sexp)))
        `(set ,(parse _var) ,(parse _expr))))

        ;********************* applic ************************
        ((app? sexp)
          (let ((_app (car sexp))
          (_exprs (cdr sexp)))
        `(applic ,(parse _app) (,@(map parse _exprs)))))

        ;********************* sequence ************************
        ((seq? sexp)
          (letrec ((flatBegin 
            (lambda (exp acc) 
              (cond 
                ((null? exp)  acc)
                ((seq? (car exp)) (flatBegin (cdr exp) (append acc (flatBegin (cdar exp) '()))))
                (else (flatBegin (cdr exp) (append acc (list (car exp)))))))))
          (let ((rest (cdr (flatBegin sexp '()))))
            (cond 
             ((null? rest)  (parse (void)))
             ((= (length rest) 1) (parse (car rest)))
           (else `(seq (,@(map parse rest))))))))

        ;********************* marcro-expand ************************
        ((macro-expandr? sexp)
          (parse (macro-expand sexp)))

        (else (error 'parser (format "invalid syntax: ~s" sexp)))
    )))