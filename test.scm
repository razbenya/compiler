;'(1 2 3 4 5 6)
;'(4 5 6 7 8)
;"hello world"
;'(1 2 #t 3)
;4/8
;'( (1 2 3) (4 5 6) )
;'((1 2) (4 #(100 200 300)) 7 8 #(80 (40 70) 60 50))
;(if #f 2 '(4 5 6 1 2 3 8))
;(if #t 1 '(1 2 3))
; (if #t '(9 4 3) 1)
; (if #f 1 '(1 2 #t 3))
;(or)
;(or #t)
;(or #f)
;(or #t #f)
;(or #f #t)
;(or #f #f)
;(or #t #t)
; (or "a" #t #f 1)
; (or #t "a" #f 1)
;  (or #f "a" 1 #t)
;(or #f #f #f #f #f #t #f)
;(or #f #f #f #f #f)
;(begin 1 2 3) ;(seq ((const 1) (const 2) (const 3)))
;(begin #t #f #f 1)
;(begin #t #f #f)
;(begin #t)
;(begin)
;'( (1 2) . (4 . #(1 2 3)))
;(((lambda (x y w) (lambda (z) x w y)) 1 2 3) 4)
;((lambda(x) x) 1)
;(lambda(x) x)
;(lambda() b)
;(define c 8)
;(if 1 c 2)
;(lambda() b)
;(define c 8)
;(if 1 c 2)
;((lambda(x) (set! x 34) x) 4)
;(((lambda (x) (lambda (z) (set! x 28))) 4) 2)
;(define proc (lambda (x) x))
;(proc c)
;(((lambda (x) (lambda (z) (set! x 28) x)) 4) 2)
;(define foo-wrapper
;  (lambda (x) 
;    (lambda (y) (set! x 40) x)))
;(define foo (foo-wrapper 8))
;(foo 6)
;(boolean? #f)
;(boolean? 4)
;(boolean? #t)
;(define x 20)
;(set! x #t)
;(boolean? x)
;(define x '(1 2 3))
;(car x)
;(cdr x)
;(char? #\a)
;(char? '(1 2))
;(char? "raz")
;(define x 4)
;(if (char? x) x "x is not a char")
;(eq? 1 1)
;(eq? 1 2)
;(eq? '(1 2) '(1 2))
;(define a1 '(1 2 3))
;(define a2 1)
;(eq? a2 (car a1))
;(define y (cons 1 (cons 2 (cons '()))))
;(eq? x '(1 2) y)
;(integer? 2)
;(integer? #f)
;(integer? '(1 2))
;(cons 4 5)
;(cons 1 (cons 2 (cons 3 '())))
;(cons 4 6)
;(define lst (cons 1 (cons 2 (cons 3 '()))))
;(cons 9 8)
;(cons 9 (cdr lst))
;(define a '4)
;(cons a 3)
;(define b "a")
;(cons 1 b)
;(cons "t" 1)
;(define x #\p)
;(char->integer x)
;(define x '())
;(define y '(4))
;(define z 3)
;(null? x)
;(null? y)
;(null? (cdr y))
;(null? z)
;(pair? x)
;(pair? y)
;(pair? z)
;(define list? 
;  (lambda (e)
;    (cond 
;      ((null? e) #t)
;      ((pair? e) (list? (cdr e)))
;      (else #f))));
;(list? '(1 2 3 4))
;(list? (cons 1 2))
; (cons 6 4)
;(zero? 0)
;(zero? 5)
;(zero? #f)
;(zero? '())
;(zero? (if #f 1 0))
;(zero? (if #t 1 0))

;((lambda (x) ((lambda (y) x) 4)) 2)
;((lambda (x y) ((lambda (x y) x) 1 3)) 2 4)
;((lambda (x) ((lambda (x y z) x) 1 3 4)) 2)
;((lambda (x y z w) ((lambda (x y) x) 15 3)) 19 5 2 4)
;((lambda (x t z w) ((lambda (x y) z) 15 3)) 19 5 2 4)
;((lambda (x . y) y) 1 2 3 4 5 6 7)
;((lambda x x) 1 2 3 4 5)
;((lambda x x))
;(list 1 2 3 4)
;(define test (lambda x x))
;(apply test '(1 2 3))
;(number? 3)
;(number? 1/2)
;(number? '())
;(number? "raz")
;(b_plus 1 2)

;(b_plus 1/4 3/4)


;(+ 1/2 1/2 1/2 1 2 3 4)


;(- 3 4)
;(- 1 2 3)
;(((lambda (x . y) (lambda (l) y)) 4 5) 2)
;(((lambda (x . y) (lambda (l) y)) 4) 2)
;(- 4 3)
;(- 1)

;((lambda (x y) (+ x y)) 4 5)

;(eq? '(1 2) (cons 1 2))
;(eq? 1 (car (cons 1 2)))

;(define x '())
;(if (null? x) 1 2)

;(define x '(1))
;(if (null? x) 1 2)

;(- 1 2 3)
;(b_minus 1/3 2/3)

;((lambda (x) x) 1)
;(- 1 2 3 4)
;(cons 1 2)
;(- 1 ##-3 2/3)
;+
;(rational? 4)
;(rational? 3/2)
;(rational? "hello")
;(rational? '(1 2))

;(vector? #(1 2 3))
;(vector? '())
;(vector? 3)
;(vector? "blabla")
;(vector? '(1 2 3))
;(string? "sss")
;(string? "a")
;(string? 1)
;(string? '())
;(string? #("a" "b"))
;(string?  '("a" "b"))


;(procedure? (lambda (x) x))
;(procedure? '())
;(procedure? #("a" 1))
;(procedure? 1)
;(procedure? 1/2)
;(procedure? (if #f 1 2))
;(procedure? ((lambda (x) x) 1))

;(numerator 1)
;(numerator 2/5)
;(numerator 3/1)
;(numerator ##-4/3)
;;(numerator #(1 2 3))

;(denominator 1)
;(denominator 2/5)
;(denominator 3/1)
;(denominator ##-4/3)


;(define x (list 1 2 3 4))
;(set-car! x 8)
;x
;(define y (list 4 3 2 1))
;(set-cdr! y '(1 2))
;y

;(remainder 2 3)
;(remainder ##-6 4)
;(integer->char 61)
;(char->integer (integer->char 44))
;(integer->char (char->integer #\b))
;(not 1)
;(not '(1 2 3))
;(not "raz")
;(not #f)
;(not (if #t #f))
;(not '())

;(b_equal 2 2)
;(b_equal 2 3)
;(b_equal 2/3 2/3)
;(b_equal 2/3 3/4)
;(b_equal 1 2/3)
;(b_equal 3 3/1)


;(= 1/2 1/2 1/2 1/2)
;(= 1/2 1/2)
;(= 1 1)
;(= 1)
;(= 2 3)
;(= 1/2 1/2 3)
;(= 1 2 3 4)

;(define b_append
;       (lambda (lst1 lst2)
;         (if (null? lst1)
;             lst2
;             (cons (car lst1) (b_append (cdr lst1) lst2)))))

;(b_append '(1 2 3 4 5) '(3 4))
;(b_append '(1 2 3 4 5 6 7 8) '(3 4))

;(+ 2/3 2 1/2)

;(((lambda (x) (lambda(y) (cons x y))) 1)2)



(define test ((lambda (x)
                (lambda (y) (list x (set! x y) x))) 3))

(test 1)
(test 2)

(define x 1)
(define y 8)

(list x (set! x y) x)
;(list (set! test 3) 4)