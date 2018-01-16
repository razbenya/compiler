%include "scheme.s"
section .bss
global main
section .data
	const_table:
		const_1:
			dq MAKE_LITERAL(T_VOID,0)
		const_2:
			dq MAKE_LITERAL(T_NIL,0)
		const_3:
			dq MAKE_LITERAL(T_BOOL,0)
		const_4:
			dq MAKE_LITERAL(T_BOOL,1)
		const_5:
			dq MAKE_LITERAL(T_INTEGER,1)
		const_6:
			dq MAKE_LITERAL(T_INTEGER,2)
		const_7:
			dq MAKE_LITERAL(T_INTEGER,3)
		const_8:
			dq MAKE_LITERAL(T_INTEGER,4)
		const_9:
			dq MAKE_LITERAL(T_INTEGER,5)
		const_10:
			dq MAKE_LITERAL_PAIR(const_9,const_2)
		const_11:
			dq MAKE_LITERAL_PAIR(const_8,const_10)

section .data
	main:


                            MOV RAX,QWORD[const_5]
                             
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            MOV RAX,QWORD[const_6]
                             
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            MOV RAX,QWORD[const_7]
                             
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            MOV RAX,QWORD[const_11]
                             
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
	ret
