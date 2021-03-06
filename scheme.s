;;; scheme.s
;;; Support for the Scheme compiler
;;; 
;;; Programmer: Mayer Goldberg, 2018

%define T_UNDEFINED 0
%define T_VOID 1
%define T_NIL 2
%define T_INTEGER 3
%define T_FRACTION 4
%define T_BOOL 5
%define T_CHAR 6
%define T_STRING 7
%define T_SYMBOL 8
%define T_CLOSURE 9
%define T_PAIR 10
%define T_VECTOR 11
%define T_BUCKET 12

%define CHAR_NUL 0
%define CHAR_TAB 9
%define CHAR_NEWLINE 10
%define CHAR_PAGE 12
%define CHAR_RETURN 13
%define CHAR_SPACE 32

%define TYPE_BITS 4
%define WORD_SIZE 64

%define MAKE_LITERAL(type, lit) ((lit << TYPE_BITS) | type)

%macro TYPE 1
	and %1, ((1 << TYPE_BITS) - 1) 
%endmacro

%macro DATA 1
	sar %1, TYPE_BITS
%endmacro


%macro DATA_UPPER 1
	shr %1, (((WORD_SIZE - TYPE_BITS) >> 1) + TYPE_BITS)
%endmacro

%macro DATA_LOWER 1
	shl %1, ((WORD_SIZE - TYPE_BITS) >> 1)
	DATA_UPPER %1
%endmacro

%define MAKE_LITERAL_PAIR(car, cdr) (((((car - start_of_data) << ((WORD_SIZE - TYPE_BITS) >> 1)) | (cdr - start_of_data)) << TYPE_BITS) | T_PAIR)

%define MAKE_LITERAL_SYMBOL(bucket) (((bucket - start_of_data) << TYPE_BITS) | T_SYMBOL)



%define MAKE_LITERAL_FRACTION(numerator, denominator) (((((numerator - start_of_data) << ((WORD_SIZE - TYPE_BITS) >> 1)) | (denominator - start_of_data)) << TYPE_BITS) | T_FRACTION)

%macro CALL_LIB_FUN 2
	push %2
	mov rbx, %1
	mov rbx, [rbx]
	CLOSURE_ENV rbx
	push rbx
	mov %1 , [%1]
	CLOSURE_CODE %1
	call %1
%endmacro


%macro GCD 2
	push %2
	push %1
	call gcd
	pop %1
	pop %2
%endmacro

%macro CLEAN_STACK 0
	mov rbx, [rbp + 3*8]  ; n                                              
    leave
    pop rdx   ;save return 
    shl rbx,3 
    add rbx, 8*3                                              
    add rsp, rbx ; clen stack
    push rdx ; push return
%endmacro

%macro NEG_FRACTION 1
	mov rax, [%1]
	CAR rax
	DATA rax
	neg rax
	MAKE_INT rax
	mov r8, rax
	test_malloc 8
	mov [rax], r8
	mov r8, [%1]
	packed_cdr r8
	MAKE_FRACTION rax, r8
	mov r8, rax
	test_malloc 8
	mov [rax],r8
	mov %1, rax
%endmacro

%macro test_malloc 1
	push rcx
	push rbx
	mov rbx, malloc_pointer
	mov rax, qword [rbx]
	mov rcx, qword [rbx]
	add rcx, %1
	mov qword [rbx], rcx
	pop rbx
	pop rcx
%endmacro

;; rdx = addr first rbx = addr sec
%macro MUL_FRACTION 2
	mov qword[a], %1
	mov qword[b], %2
	mov r8, [%1] ;first fraction
	mov r9, [%2] ;sec fraction

	CAR r8	; mone 1
	DATA r8

	CAR r9  ; mone 2
	DATA r9

	mov rax, r8
	mul r9 ; rax <- mone1 * mone2
	mov r9, rax 
	MAKE_INT r9
	test_malloc 8
	mov [rax], r9
	mov r9, rax ; r9 new mone
	mov %1, qword[a]
	mov %2, qword[b]
	mov rax, [%1] ;first fraction
	mov r8, [%2] ;sec fraction
	CDR rax	; mechane 2
	DATA rax
	CDR r8  ; mechane 2
	DATA r8
	mul r8
	mov r8, rax ; r8 <- new mechane
	MAKE_INT r8
	
	test_malloc 8
	mov [rax], r8
	mov %1, r9
	mov %2, rax

%endmacro





;; rdx = addr first rbx = addr sec
%macro ADD_FRACTION 2
	mov qword[a], %1
	mov qword[b], %2
	mov r8, [%1] ;first fraction
	mov r9, [%2] ;sec fraction

	CAR r8	; mone 1
	DATA r8

	CDR r9  ; mechane 2
	DATA r9

	mov rax, r8
	mul r9 ; rax <- mone1 * mechane1
	mov r9, rax
	mov %1, qword[a]
	mov %2, qword[b]
	mov rax, [%1] ;first fraction
	mov r8, [%2] ;sec fraction
	CDR rax	; mone 2
	DATA rax
	CAR r8  ; mechane 1
	DATA r8
	mul r8
	add rax, r9 
	mov r9, rax ;r9 <- new mechane
	MAKE_INT r9

	mov %1, qword[a]
	mov %2, qword[b]
	mov rax, [%1] ;first fraction
	mov r8, [%2] ;sec fraction
	CDR rax	; mone 2
	DATA rax
	CDR r8  ; mechane 1
	DATA r8
	mul r8 ; rax <-new mechane
	mov r8, rax
	MAKE_INT r8

	test_malloc 8
	mov [rax], r8
	mov %2, rax

	test_malloc 8
	mov [rax], r9
	mov %1, rax

%endmacro

%macro REMOVE_FRACTION 1
	mov rax, %1
	CDR rax
	DATA rax
	cmp rax, 1
	je %%remove
	mov rax, %1
	jmp %%finish
	%%remove:
	mov rax, %1
	CAR rax
	%%finish:
	mov %1, rax
%endmacro

%macro REDUCE 1
	push rcx
	push rdx
	push r8
	push r10

	mov rcx, %1
	mov rdx, %1

	
	packed_car rcx
	packed_cdr rdx


	mov qword[a],rcx
	mov qword[b],rdx


	mov rcx,[rcx]
	DATA rcx

	mov rdx,[rdx]
	DATA rdx

	mov r10, rdx  ; b

	cmp rcx, 0
	jg %%positive
	neg rcx
	%%positive:

	GCD rcx, rdx

	mov r8, rax   ; gcd
	mov rax, rcx
	xor rdx,rdx
	div r8
	
	mov rcx,qword[a]
	mov rcx,[rcx]
	DATA rcx
	cmp rcx, 0
	jg %%positive_2
	neg rax
	%%positive_2:

	mov rcx, rax ; rcx <= rcx/gcd


	mov rax, r10 ; rax <= b
	xor rdx, rdx
	div r8	; rax <= b/gcd
	
	mov rdx, qword[b]
	MAKE_INT rax
	mov [rdx], rax


	mov rax, rcx
	mov rcx, qword[a]
	MAKE_INT rax
	mov [rcx],rax

	pop r10
	pop r8
	pop rdx
	pop rcx
%endmacro

%macro MAKE_INT 1
	shl %1, TYPE_BITS
	or %1, T_INTEGER
%endmacro 

%macro MAKE_CHAR 1
	shl %1, TYPE_BITS
	or %1, T_CHAR
%endmacro 

%macro MAKE_FRACTION 2
	sub %1, start_of_data
	shl %1, (((WORD_SIZE - TYPE_BITS) >> 1) + TYPE_BITS)
	sub %2, start_of_data
	shl %2, TYPE_BITS
	or %1, %2
	or %1, T_FRACTION
%endmacro

%macro MAKE_PAIR 2
	sub %1, start_of_data
	shl %1, (((WORD_SIZE - TYPE_BITS) >> 1) + TYPE_BITS)
	sub %2, start_of_data
	shl %2, TYPE_BITS
	or %1, %2
	or %1, T_PAIR
%endmacro

%define MAKE_SYMBOL_BUCKET(str, last) (((((str - start_of_data) << ((WORD_SIZE - TYPE_BITS) >> 1)) | (last - start_of_data)) << TYPE_BITS) | T_SYMBOL)

%macro MAKE_BUCKET 2
	sub %1, start_of_data
	shl %1, (((WORD_SIZE - TYPE_BITS) >> 1) + TYPE_BITS)
	sub %2, start_of_data
	shl %2, TYPE_BITS
	or %1, %2
	or %1, T_SYMBOL
%endmacro

%macro packed_car 1
	DATA_UPPER %1
	add %1, start_of_data
%endmacro

%macro CAR 1
	DATA_UPPER %1
	add %1, start_of_data
	mov %1, qword [%1]
%endmacro

%macro packed_cdr 1
	DATA_LOWER %1
	add %1, start_of_data
%endmacro

%macro CDR 1
	DATA_LOWER %1
	add %1, start_of_data
	mov %1, qword [%1]
%endmacro

;;; MAKE_LITERAL_CLOSURE target, env, code
%macro MAKE_LITERAL_CLOSURE 3
	push rax
	push rbx
	mov rax, %1
        mov qword [rax], %2
        sub qword [rax], start_of_data	
	shl qword [rax], ((WORD_SIZE - TYPE_BITS) >> 1)
        lea rbx, [rax + 8]
        sub rbx, start_of_data
	or qword [rax], rbx
	shl qword [rax], TYPE_BITS
	or qword [rax], T_CLOSURE
	mov qword [rax + 8], %3
	pop rbx
	pop rax
%endmacro

%macro CLOSURE_ENV 1
	DATA_UPPER %1
	add %1, start_of_data
%endmacro

%macro CLOSURE_CODE 1
	DATA_LOWER %1
	add %1, start_of_data
	mov %1, qword [%1]
%endmacro

%macro MAKE_LITERAL_STRING 1+
	dq (((((%%LstrEnd - %%Lstr) << ((WORD_SIZE - TYPE_BITS) >> 1)) | (%%Lstr - start_of_data)) << TYPE_BITS) | T_STRING)
	%%Lstr:
	db %1
	%%LstrEnd:
%endmacro


%macro MAKE_VECTOR 2
	sub %2, %1
    shr %2, 3
	shl %2, ((WORD_SIZE - TYPE_BITS) >> 1)
	sub %1, start_of_data
	or %2, %1
	shl %2, TYPE_BITS
	or %2, T_VECTOR
%endmacro

%macro MAKE_STRING 2
	sub %2, %1
	shl %2, ((WORD_SIZE - TYPE_BITS) >> 1)
	sub %1, start_of_data
	or %2, %1
	shl %2, TYPE_BITS
	or %2, T_STRING
%endmacro

%macro STRING_LENGTH 1
	DATA_UPPER %1
%endmacro

%macro STRING_ELEMENTS 1
	DATA_LOWER %1
	add %1, start_of_data
%endmacro

;;; STRING_REF dest, src, index
;;; dest cannot be RAX! (fix this!)
%macro STRING_REF 3
	push rax
	mov rax, %2
	STRING_ELEMENTS rax
	add rax, %3
	mov %1, byte [rax]
	pop rax
%endmacro

%macro STR_CMPR 2
	push %2
	mov r10, %1
	mov r12, %2
	STRING_LENGTH r10
	STRING_LENGTH r12
	cmp r10, r12
	jne %%not_equal
	STRING_ELEMENTS %1
	STRING_ELEMENTS %2
	mov rdi, r10
	%%loop:
		cmp rdi,0
		je %%equal
		mov cl, byte [%1]
		cmp cl, byte [%2]
		jne %%not_equal
		inc %1
		inc %2
		dec rdi
		jmp %%loop
	%%not_equal:
		mov r10, 1
	    mov r12, 2
		cmp r10, r12
		jmp %%finish
	%%equal:
		cmp rax, rax
	%%finish:
	pop %2
%endmacro

%macro MAKE_LITERAL_VECTOR 1+
	dq ((((((%%VecEnd - %%Vec) >> 3) << ((WORD_SIZE - TYPE_BITS) >> 1)) | (%%Vec - start_of_data)) << TYPE_BITS) | T_VECTOR)
	%%Vec:
	dq %1
	%%VecEnd:
%endmacro

%macro VECTOR_LENGTH 1
	DATA_UPPER %1
%endmacro

%macro VECTOR_ELEMENTS 1
	DATA_LOWER %1
	add %1, start_of_data
%endmacro

;;; VECTOR_REF dest, src, index
;;; dest cannot be RAX! (fix this!)
%macro VECTOR_REF 3
	mov %1, %2
	VECTOR_ELEMENTS %1
	lea %1, [%1 + %3*8]
	mov %1, qword [%1]
	;mov %1, qword [%1]
%endmacro

%define SOB_UNDEFINED MAKE_LITERAL(T_UNDEFINED, 0)
%define SOB_VOID MAKE_LITERAL(T_VOID, 0)
%define SOB_FALSE MAKE_LITERAL(T_BOOL, 0)
%define SOB_TRUE MAKE_LITERAL(T_BOOL, 1)
%define SOB_NIL MAKE_LITERAL(T_NIL, 0)

%define gigabyte(n) n << 30

section .data
start_of_data:

a:
	dq 0
b:
	dq 0

section .bss
malloc_pointer:
		resq 1
start_of_data2:
		resb gigabyte(1)

extern exit, printf, scanf, malloc
global write_sob, write_sob_if_not_void
section .text


write_sob_undefined:
	push rbp
	mov rbp, rsp

	mov rax, 0
	mov rdi, .undefined
	call printf

	leave
	ret

section .data
.undefined:
	db "#<undefined>", 0

write_sob_integer:
	push rbp
	mov rbp, rsp

	mov rsi, qword [rbp + 8 + 1*8]
	sar rsi, TYPE_BITS
	mov rdi, .int_format_string
	mov rax, 0
	call printf

	leave
	ret

section .data
.int_format_string:
	db "%ld", 0

write_sob_char:
	push rbp
	mov rbp, rsp

	mov rsi, qword [rbp + 8 + 1*8]
	DATA rsi

	cmp rsi, CHAR_NUL
	je .Lnul

	cmp rsi, CHAR_TAB
	je .Ltab

	cmp rsi, CHAR_NEWLINE
	je .Lnewline

	cmp rsi, CHAR_PAGE
	je .Lpage

	cmp rsi, CHAR_RETURN
	je .Lreturn

	cmp rsi, CHAR_SPACE
	je .Lspace
	jg .Lregular

	mov rdi, .special
	jmp .done	

.Lnul:
	mov rdi, .nul
	jmp .done

.Ltab:
	mov rdi, .tab
	jmp .done

.Lnewline:
	mov rdi, .newline
	jmp .done

.Lpage:
	mov rdi, .page
	jmp .done

.Lreturn:
	mov rdi, .return
	jmp .done

.Lspace:
	mov rdi, .space
	jmp .done

.Lregular:
	mov rdi, .regular
	jmp .done

.done:
	mov rax, 0
	call printf

	leave
	ret

section .data
.space:
	db "#\space", 0
.newline:
	db "#\newline", 0
.return:
	db "#\return", 0
.tab:
	db "#\tab", 0
.page:
	db "#\page", 0
.nul:
	db "#\nul", 0
.special:
	db "#\x%x", 0
.regular:
	db "#\%c", 0

write_sob_void:
	push rbp
	mov rbp, rsp

	mov rax, 0
	mov rdi, .void
	call printf

	leave
	ret

section .data
.void:
	db "#<void>", 0
	
write_sob_bool:
	push rbp
	mov rbp, rsp

	mov rax, qword [rbp + 8 + 1*8]
	cmp rax, SOB_FALSE
	je .sobFalse
	
	mov rdi, .true
	jmp .continue

.sobFalse:
	mov rdi, .false

.continue:
	mov rax, 0
	call printf	

	leave
	ret

section .data			
.false:
	db "#f", 0
.true:
	db "#t", 0

write_sob_nil:
	push rbp
	mov rbp, rsp

	mov rax, 0
	mov rdi, .nil
	call printf

	leave
	ret

section .data
.nil:
	db "()", 0

write_sob_string:
	push rbp
	mov rbp, rsp

	mov rax, 0
	mov rdi, .double_quote
	call printf

	mov rax, qword [rbp + 8 + 1*8]
	mov rcx, rax
	STRING_LENGTH rcx
	STRING_ELEMENTS rax

.loop:
	cmp rcx, 0
	je .done
	mov bl, byte [rax]
	and rbx, 0xff

	cmp rbx, CHAR_TAB
	je .ch_tab
	cmp rbx, CHAR_NEWLINE
	je .ch_newline
	cmp rbx, CHAR_PAGE
	je .ch_page
	cmp rbx, CHAR_RETURN
	je .ch_return
	cmp rbx, CHAR_SPACE
	jl .ch_hex
	
	mov rdi, .fs_simple_char
	mov rsi, rbx
	jmp .printf
	
.ch_hex:
	mov rdi, .fs_hex_char
	mov rsi, rbx
	jmp .printf
	
.ch_tab:
	mov rdi, .fs_tab
	mov rsi, rbx
	jmp .printf
	
.ch_page:
	mov rdi, .fs_page
	mov rsi, rbx
	jmp .printf
	
.ch_return:
	mov rdi, .fs_return
	mov rsi, rbx
	jmp .printf

.ch_newline:
	mov rdi, .fs_newline
	mov rsi, rbx

.printf:
	push rax
	push rcx
	mov rax, 0
	call printf
	pop rcx
	pop rax

	dec rcx
	inc rax
	jmp .loop

.done:
	mov rax, 0
	mov rdi, .double_quote
	call printf

	leave
	ret
section .data
.double_quote:
	db '"', 0
.fs_simple_char:
	db "%c", 0
.fs_hex_char:
	db "\x%02x;", 0	
.fs_tab:
	db "\t", 0
.fs_page:
	db "\f", 0
.fs_return:
	db "\r", 0
.fs_newline:
	db "\n", 0

write_sob_pair:
	push rbp
	mov rbp, rsp

	mov rax, 0
	mov rdi, .open_paren
	call printf
	mov rax, qword [rbp + 8 + 1*8]
	CAR rax
	push rax
	call write_sob
	add rsp, 1*8
	mov rax, qword [rbp + 8 + 1*8]
	CDR rax
	push rax
	call write_sob_pair_on_cdr
	add rsp, 1*8
	mov rdi, .close_paren
	mov rax, 0
	call printf

	leave
	ret

section .data
.open_paren:
	db "(", 0
.close_paren:
	db ")", 0

write_sob_pair_on_cdr:
	push rbp
	mov rbp, rsp

	mov rbx, qword [rbp + 8 + 1*8]
	mov rax, rbx
	TYPE rbx
	cmp rbx, T_NIL
	je .done
	cmp rbx, T_PAIR
	je .cdrIsPair
	push rax
	mov rax, 0
	mov rdi, .dot
	call printf
	call write_sob
	add rsp, 1*8
	jmp .done

.cdrIsPair:
	mov rbx, rax
	CDR rbx
	push rbx
	CAR rax
	push rax
	mov rax, 0
	mov rdi, .space
	call printf
	call write_sob
	add rsp, 1*8
	call write_sob_pair_on_cdr
	add rsp, 1*8

.done:
	leave
	ret

section .data
.space:
	db " ", 0
.dot:
	db " . ", 0

write_sob_vector:
	push rbp
	mov rbp, rsp

	mov rax, 0
	mov rdi, .fs_open_vector
	call printf

	mov rax, qword [rbp + 8 + 1*8]
	mov rcx, rax
	VECTOR_LENGTH rcx
	cmp rcx, 0
	je .done
	VECTOR_ELEMENTS rax

	push rcx
	push rax
	mov rax, qword [rax]
	push qword [rax]
	call write_sob
	add rsp, 1*8
	pop rax
	pop rcx
	dec rcx
	add rax, 8

.loop:
	cmp rcx, 0
	je .done

	push rcx
	push rax
	mov rax, 0
	mov rdi, .fs_space
	call printf
	
	pop rax
	push rax
	mov rax, qword [rax]
	push qword [rax]
	call write_sob
	add rsp, 1*8
	pop rax
	pop rcx
	dec rcx
	add rax, 8
	jmp .loop

.done:
	mov rax, 0
	mov rdi, .fs_close_vector
	call printf

	leave
	ret

section	.data
.fs_open_vector:
	db "#(", 0
.fs_close_vector:
	db ")", 0
.fs_space:
	db " ", 0

write_sob_symbol:
	push rbp
	mov rbp, rsp
	mov rax, qword[rbp +8 + 1*8]	
	CAR rax
	mov rcx, rax
	STRING_LENGTH rcx
	STRING_ELEMENTS rax

	.loop:
		cmp rcx, 0
		je .done
		mov bl, byte [rax]
		and rbx, 0xff

		cmp rbx, CHAR_TAB
		je .ch_tab
		cmp rbx, CHAR_NEWLINE
		je .ch_newline
		cmp rbx, CHAR_PAGE
		je .ch_page
		cmp rbx, CHAR_RETURN
		je .ch_return
		cmp rbx, CHAR_SPACE
		jl .ch_hex
		
		mov rdi, .fs_simple_char
		mov rsi, rbx
		jmp .printf
		
	.ch_hex:
		mov rdi, .fs_hex_char
		mov rsi, rbx
		jmp .printf
		
	.ch_tab:
		mov rdi, .fs_tab
		mov rsi, rbx
		jmp .printf
		
	.ch_page:
		mov rdi, .fs_page
		mov rsi, rbx
		jmp .printf
		
	.ch_return:
		mov rdi, .fs_return
		mov rsi, rbx
		jmp .printf

	.ch_newline:
		mov rdi, .fs_newline
		mov rsi, rbx

	.printf:
		push rax
		push rcx
		mov rax, 0
		call printf
		pop rcx
		pop rax

		dec rcx
		inc rax
		jmp .loop

	.done:

	leave
	ret
section .data
.fs_simple_char:
	db "%c", 0
.fs_hex_char:
	db "\x%02x;", 0	
.fs_tab:
	db "\t", 0
.fs_page:
	db "\f", 0
.fs_return:
	db "\r", 0
.fs_newline:
	db "\n", 0

	
write_sob_fraction:
	push rbp
	mov rbp, rsp

	mov rax, qword [rbp + 8 + 1*8]
	CAR rax
	push rax
	call write_sob
	add rsp, 1*8

	mov rax, 0
	mov rdi, .slash
	call printf

	mov rax, qword [rbp + 8 + 1*8]
	CDR rax
	push rax
	call write_sob
	add rsp, 1*8

	leave
	ret

section	.data
.slash:
	db "/", 0

write_sob_closure:
	push rbp
	mov rbp, rsp

	mov rsi, qword [rbp + 8 + 1*8]
	mov rdx, rsi
	CLOSURE_ENV rsi
	CLOSURE_CODE rdx
	mov rdi, .closure
	mov rax, 0
	call printf

	leave
	ret
section .data
.closure:
	db "#<closure [env:%p, code:%p]>", 0

write_sob:
	mov rax, qword [rsp + 1*8]
	TYPE rax
	jmp qword [.jmp_table + rax * 8]

section .data
.jmp_table:
	dq write_sob_undefined, write_sob_void, write_sob_nil
	dq write_sob_integer, write_sob_fraction, write_sob_bool
	dq write_sob_char, write_sob_string, write_sob_symbol
	dq write_sob_closure, write_sob_pair, write_sob_vector

section .text
write_sob_if_not_void:
	mov rax, qword [rsp + 1*8]
	mov rax, [rax]
	cmp rax, SOB_VOID
	je .continue

	push rax
	call write_sob
	add rsp, 1*8
	mov rax, 0
	mov rdi, .newline
	call printf
	
.continue:
	ret
section .data
.newline:
	db CHAR_NEWLINE, 0


section .text
my_malloc:
	push rbp
	mov rbp, rsp
	push rdx
	push rbx
	push rcx
	push rdi
	push rsi
	push r8
	mov rax, 0
	mov rdi, qword [rbp + 8 + 1*8]
	call malloc
	pop r8
	pop rsi
	pop rdi
	pop rcx
	pop rbx
	pop rdx
	leave
	ret 

	
gcd:
	push rbp
	mov rbp, rsp
	mov rax, qword[rbp + 8 + 1*8] ; param1
	mov rbx, qword[rbp+ 8 + 2*8] ; param2

.loop:
	cmp rbx, 0
	je .done
	cqo
	idiv rbx
	mov rax, rbx
	mov rbx, rdx
	jmp .loop

.done:
	pop rbp
	ret