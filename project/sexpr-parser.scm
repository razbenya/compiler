(load "project/pc.scm")

(define <pack-char>
    (lambda (string char)
        (new (*parser (word-ci string))
            (*pack (lambda (_) char))
        done)))

(define <Boolean>
    (new 
        (*parser (<pack-char> "#f" #f))
        (*parser (<pack-char> "#t" #t))
        (*disj 2)
    done))
        
(define <greater-than-space>
    (range #\! #\~))

(define <whitespace> 
  (range (integer->char 0) #\space))

(define <CharPrefix>
    (new
        (*parser (char #\#))
        (*parser (char #\\))
        (*caten 2)
        (*pack(lambda(x) (list->string x)))
    done))

(define <VisibleSimpleChar>
    (new
        (*parser <greater-than-space>)
    done))
        
        
(define <NamedChar>
    (new 
        (*parser (<pack-char> "lambda" (integer->char 955)))
        (*parser (<pack-char> "newline" #\newline))
        (*parser (<pack-char> "nul" #\nul))
        (*parser (<pack-char> "page" #\page))
        (*parser (<pack-char> "return" #\return))
        (*parser (<pack-char> "space" #\space))
        (*parser (<pack-char> "tab" #\tab))
        (*disj 7)
    done))

(define <HexChar>
    (new
        (*parser (range #\0 #\9))
        (*parser (range #\a #\f))
        (*disj 2)
    done))
        
(define <HexUnicodeChar>
    (new 
        (*parser (char-ci #\x))
        (*parser <HexChar>)
        *plus
        (*caten 2)
        (*pack-with (lambda (_ c) (integer->char (string->number (list->string c) 16))))
    done))

        
(define <Char> 
    (new 
        (*parser <CharPrefix>)
        (*parser <NamedChar>)
        (*parser <HexUnicodeChar>)
        (*parser <VisibleSimpleChar>)
        (*disj 3)
        (*caten 2)
        (*pack-with
          (lambda(_ c) c))        
    done))

(define <digit>
    (range #\0 #\9))

(define <letter>
    (range-ci #\a #\z))

(define <Natural>
    (new
        (*parser <digit>)
        *plus
        (*pack (lambda (x)
        (string->number (list->string x))))
    done))

(define <Integer>
    (new 
        (*parser (char #\+))
        (*parser <Natural>)
        (*caten 2)
        (*pack-with(lambda(_ n) n))
        (*parser (char #\-))
        (*parser <Natural>)
        (*caten 2)
        (*pack-with(lambda(_ n) (- 0 n)))
        (*parser <Natural>)
        (*disj 3)
    done))
        

(define <Fraction> 
    (new
        (*parser <Integer>)
        (*parser (char #\/))
        (*parser <Natural>)
        (*only-if (lambda (n) (not (zero? n))))
        (*caten 3)
        (*pack-with(lambda(n1 _ n2) (/ n1 n2))) 
    done))
        
        
(define <Number>
    (new
        (*parser <Fraction>)
        (*parser <Integer>)
        (*disj 2)
        (*delayed (lambda () <SymbolChar>))
        *not-followed-by
    done))



(define <StringLiteralChar>
    (new
        (*parser <any-char>)
        (*parser (char #\\))
        (*parser (char #\"))
        (*disj 2)
        *diff
    done))
        

        
(define <StringMetaChar>
    (new
        (*parser (<pack-char> "\\\\" #\\))
        (*parser (<pack-char> "\\\"" #\"))
        (*parser (<pack-char> "\\t" #\tab))
        (*parser (<pack-char> "\\f" #\page))
        (*parser (<pack-char> "\\r" #\return))
        (*parser (<pack-char> "\\n" #\newline))
        (*disj 6)
        done))

(define <StringHexChar> 
    (new
        (*parser (word-ci "\\x"))
        (*parser <HexChar>)
        *star
        (*parser (char #\;))
        (*caten 3)
        (*pack-with (lambda (opener ch closer) (integer->char (string->number (list->string ch) 16))))
    done))


     
(define <StringChar>
    (new
        (*parser <StringLiteralChar>)
        (*parser <StringMetaChar>)
        (*parser <StringHexChar>)
        (*disj 3)
    done))
        
        
(define <String>
    (new
        (*parser (char #\"))
        (*parser <StringChar>)
        (*parser (char #\")) *diff
        *star
        (*parser (char #\"))
        (*caten 3)
        (*pack-with (lambda (open str close) (list->string str)))
    done))   

(define <special_symbol>
    (new
        (*parser (char #\!))
        (*parser (char #\$))
        (*parser (char #\^))
        (*parser (char #\*))
        (*parser (char #\-))
        (*parser (char #\_))
        (*parser (char #\=))
        (*parser (char #\+))
        (*parser (char #\<))
        (*parser (char #\>))
        (*parser (char #\?))
        (*parser (char #\/))
        (*disj 12)
    done))

(define <SymbolChar>
    (new
        (*parser <digit>)
        (*parser <letter>)
        (*parser <special_symbol>)
        (*disj 3)
    done))

(define <Symbol>
    (new
        (*parser <SymbolChar>)
        *plus
        (*pack(lambda(lst) (string->symbol (string-downcase (list->string lst)))))
    done))

(define <ProperList>
    (new
        (*parser (char #\( ))
        (*delayed (lambda () <sexpr>))
        *star
        (*parser (char #\) ))
        (*caten 3)
        (*pack-with (lambda (x y z) `(,@y)))
        done))

(define <ImproperList>
    (new
        (*parser (char #\())
        (*delayed (lambda () <sexpr>))
        *plus
        (*parser (char #\.))
        (*delayed (lambda () <sexpr>))
        (*parser (char #\)))
        (*caten 5)
        (*pack-with (lambda (x y z w k) `(,@y ,@w)))
        done))

(define <Vector>
    (new    
        (*parser (char #\#))
        (*parser (char #\())
        (*delayed (lambda () <sexpr>))
        *star
        (*parser (char #\)))
        (*caten 4)
        (*pack-with (lambda (x y z w) `#(,@z)))
        done))

(define <Quoted>
    (new
        (*parser (char #\'))
        (*delayed (lambda () <sexpr>))
        (*caten 2)
        (*pack-with (lambda (_ exp) (list 'quote exp)))
    done))

(define <QuasiQuoted>
    (new
        (*parser (char #\`))
        (*delayed (lambda () <sexpr>))
        (*caten 2)
        (*pack-with (lambda (_ exp) (list 'quasiquote exp)))
    done))

(define <Unquoted>
    (new
        (*parser (char #\,))
        (*delayed (lambda () <sexpr>))
        (*caten 2)
        (*pack-with (lambda (_ exp) (list 'unquote exp)))
        done))

(define <UnquoteAndSpliced>
    (new
        (*parser (word-ci ",@"))
        (*delayed (lambda () <sexpr>))
        (*caten 2)
        (*pack-with (lambda (_ exp) (list 'unquote-splicing exp)))
    done))

(define <end-of-comment>
    (new
      (*parser (char #\newline))
      (*parser <end-of-input>)
      (*disj 2)
    done))

(define <lineComment>
    (new
      (*parser (char #\;))
      (*parser <any>)
      (*parser <end-of-comment>)
      *diff
      *star
      (*parser <end-of-comment>)
      (*caten 3)
    done))

(define <infixCommentsAndSpaces>
    (new
      (*parser <lineComment>)
      (*parser (word "#;"))
      (*delayed (lambda () <InfixExpression>))
      (*caten 2)
      (*parser <whitespace>)
      (*disj 3)
    done))

(define <prefixCommentsAndSpaces>
    (new
      (*parser <lineComment>)
      (*parser (word "#;"))
      (*delayed (lambda () <sexpr>))
      (*caten 2)
      (*parser <whitespace>)
      (*disj 3)
    done))


(define <skip>
 (lambda(<skipper>) 
  (lambda(<p>)
    (new 
        (*parser <skipper>)
        *star
        (*parser <p>)
        (*parser <skipper>)
        *star
        (*caten 3)
        (*pack-with (lambda (space1 p space2) p))
    done))))

(define <InfixSkip> (<skip> <infixCommentsAndSpaces>))
(define <skipspace> (<skip> <prefixCommentsAndSpaces>)) 

(define <CBNameSyntax1>
    (new
        (*parser (char #\@))
        (*delayed (lambda () <sexpr>))
        (*caten 2)
        (*pack-with(lambda (_ exp) (list 'cbname `(,@exp))))
    done))

(define <CBNameSyntax2>
    (new
        (*parser (char #\{))
        (*delayed (lambda () <sexpr>))
        (*parser (char #\}))
        (*caten 3)
        (*pack-with(lambda (opener exp closer) (list 'cbname `(,@exp))))    
    done))


(define <CBName>
    (new
        (*parser <CBNameSyntax1>)
        (*parser <CBNameSyntax2>)
        (*disj 2)
    done))

(define <InfixSexprEscape>
   ;(<InfixSkip>
      (new
        (*delayed (lambda () <InfixPrefixExtensionPrefix>))
        (*delayed (lambda () <sexpr>))
        (*caten 2)
        (*pack-with(lambda (_ exp) exp))
    done))

(define <InfixParen> 
    ;(<InfixSkip> 
      (new
      (*parser (char #\())
      (*delayed (lambda () <InfixExpression>))
      (*parser (char #\)))
      (*caten 3)
      (*pack-with (lambda (opener exp closer) exp))
    done))

(define <InfixArgList>
  ;(<InfixSkip>
    (new
      (*delayed (lambda () <InfixExpression>))
      (*parser (char #\,))
      (*delayed (lambda () <InfixExpression>))
      (*caten 2)
      (*pack-with(lambda (_ y) y))
      *star
      (*caten 2)
      (*pack-with(lambda (x y) (cons x y)))
      (*parser <epsilon>)
      (*disj 2)
    done))

(define <InfixFuncall>
    (new
      (*parser (char #\())
      (*parser <InfixArgList>)
      (*parser (char #\)))
      (*caten 3)
      (*pack-with (lambda (opener args closer) (lambda (f) (cons f `(,@args)))))
    done))

(define <InfixArrayGet>
    (new
      (*parser (char #\[))
      (*delayed (lambda () <InfixExpression>))
      (*parser (char #\]))
      (*caten 3)
      (*pack-with (lambda (opener index closer) (lambda (vector) (list (string->symbol "vector-ref") vector index))))
    done))

(define <PowerSymbol>
    (new
        (*parser (char #\^))
        (*parser (word "**"))
        (*disj 2)
    done))


(define <unwantedSymbols>
  (new
    (*parser (char #\+))
    (*parser (char #\-))
    (*parser (char #\*))
    (*parser (word "**"))
    (*parser (char #\^))
    (*parser (char #\/))
    (*disj 6)
  done))


(define <InfixSymbol>
    (new
      (*parser <SymbolChar>)
      (*parser <unwantedSymbols>)
      *diff
      *plus
      (*pack(lambda (lst) (string->symbol (string-downcase (list->string lst)))))
    done))


(define <PackToPrefix>
    (*pack-with(lambda (op exp2) (lambda (exp1) (list (string->symbol (string op)) exp1 exp2)))))

(define <ApplyProc>
  (*pack-with(lambda (exp proc) (fold-left (lambda (x y) (y x)) exp proc))))

(define <ArraysAndFuns>
    ;(<InfixSkip>
      (new
        (*delayed (lambda () <InfixBasics>))
        (*parser <InfixArrayGet>)     
        (*parser <InfixFuncall>)
        (*disj 2)
        (*parser <prefixCommentsAndSpaces>) *maybe
        (*caten 2)
        (*pack-with (lambda (exp _) exp))
        *plus
        (*caten 2)
        <ApplyProc> 
        (*delayed (lambda () <InfixBasics>))
        (*disj 2)
    done))

(define <InfixNeg>
    ;(<InfixSkip>
      (new
        (*parser (char #\-))
        (*delayed (lambda () <ArraysAndFuns>))
        (*caten 2)
        (*pack-with (lambda (_ expr) `(-,expr)))
    done))

(define <infixNumber>
    (new
        (*parser <Fraction>)
        (*parser <Integer>)
        (*disj 2)
        (*parser <InfixSymbol>)
        (*parser (range #\0 #\9))
        *diff
        *not-followed-by
    done))

(define <InfixBasics>
    (<InfixSkip>
        (new
            (*parser <infixNumber>)
            (*parser <InfixSymbol>)
            (*parser <InfixParen>)
            (*parser <InfixSexprEscape>)
            (*parser <InfixNeg>)
            (*disj 5)
        done)))

(define <packPow>
  (lambda(exp1 exp2)
    (if (null? exp2) exp1 (list (string->symbol "expt") exp1 (<packPow> (car exp2) (cdr exp2))))))


(define <Pow>
    ;(<InfixSkip>
        (new
            (*parser <ArraysAndFuns>)
            (*parser <PowerSymbol>)
            (*parser <ArraysAndFuns>)
            (*caten 2)
            (*pack-with(lambda (_ exp) exp))
            *star
            (*caten 2)
            (*pack-with(lambda (exp1 exp2) (<packPow> exp1 exp2)))
        done))

(define <DivAndMul>
    ;(<InfixSkip> 
        (new
            (*parser <Pow>)
            (*parser (char #\*))
            (*parser (char #\/))
            (*disj 2)
            (*parser <Pow>)
            (*caten 2)
            <PackToPrefix>
            *star
            (*caten 2)
            <ApplyProc>
        done))

(define <SubAndAdd>
    (new
      (*parser <DivAndMul>)
      (*parser (char #\+))
      (*parser (char #\-))
      (*disj 2)
      (*parser <DivAndMul>)
      (*caten 2)
      <PackToPrefix>
      *star
      (*caten 2)
      <ApplyProc>
    done))

(define <InfixExpression>
   ;(<InfixSkip>
      (new
        (*parser <SubAndAdd>)
    done))

(define <InfixPrefixExtensionPrefix>
    (new
        (*parser (word "##"))
        (*parser (word "#%"))
        (*disj 2) 
    done))

(define <InfixExtension>
    (<InfixSkip>
        (new
            (*parser <InfixPrefixExtensionPrefix>)
            (*parser <InfixExpression>)
            (*caten 2)
            (*pack-with (lambda (x y) y))
        done)))

(define <sexpr> 
  (<skipspace>
    (new 
        (*parser <ProperList>)
        (*parser <Boolean>)
        (*parser <String>)
        (*parser <Char>)
        (*parser <Number>)
        (*parser <Symbol>)
        (*parser <ImproperList>)
        (*parser <Vector>)
        (*parser <Quoted>)
        (*parser <QuasiQuoted>)
        (*parser <UnquoteAndSpliced>)
        (*parser <Unquoted>)
        (*parser <CBName>)
        (*parser <InfixExtension>)
        (*disj 14)
    done)))