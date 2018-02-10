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
			MAKE_LITERAL_STRING "ERROR"
		const_7:
			dq MAKE_LITERAL(T_INTEGER,0)
		const_8:
			MAKE_LITERAL_STRING "test"

                          bucket_1:
                          	dq MAKE_SYMBOL_BUCKET(const_8,bucket_0)
                          const_9:
                          	dq MAKE_LITERAL_SYMBOL(bucket_1)
                          		const_10:
			MAKE_LITERAL_STRING "blablabla"
		const_11:
			MAKE_LITERAL_STRING "this"

                          bucket_2:
                          	dq MAKE_SYMBOL_BUCKET(const_11,bucket_1)
                          const_12:
                          	dq MAKE_LITERAL_SYMBOL(bucket_2)
                          		const_13:
			MAKE_LITERAL_STRING "is"

                          bucket_3:
                          	dq MAKE_SYMBOL_BUCKET(const_13,bucket_2)
                          const_14:
                          	dq MAKE_LITERAL_SYMBOL(bucket_3)
                          		const_15:
			MAKE_LITERAL_STRING "a"

                          bucket_4:
                          	dq MAKE_SYMBOL_BUCKET(const_15,bucket_3)
                          const_16:
                          	dq MAKE_LITERAL_SYMBOL(bucket_4)
                          		const_17:
			MAKE_LITERAL_STRING "symbol"

                          bucket_5:
                          	dq MAKE_SYMBOL_BUCKET(const_17,bucket_4)
                          const_18:
                          	dq MAKE_LITERAL_SYMBOL(bucket_5)
                          		const_19:
			MAKE_LITERAL_STRING "list"

                          bucket_6:
                          	dq MAKE_SYMBOL_BUCKET(const_19,bucket_5)
                          const_20:
                          	dq MAKE_LITERAL_SYMBOL(bucket_6)
                          		const_21:
			dq MAKE_LITERAL_PAIR(const_20,const_2)
		const_22:
			dq MAKE_LITERAL_PAIR(const_18,const_21)
		const_23:
			dq MAKE_LITERAL_PAIR(const_16,const_22)
		const_24:
			dq MAKE_LITERAL_PAIR(const_14,const_23)
		const_25:
			dq MAKE_LITERAL_PAIR(const_12,const_24)
		const_26:
			MAKE_LITERAL_STRING "raz"

                          bucket_7:
                          	dq MAKE_SYMBOL_BUCKET(const_26,bucket_6)
                          const_27:
                          	dq MAKE_LITERAL_SYMBOL(bucket_7)
                          		const_28:
			MAKE_LITERAL_STRING "hello"

                          bucket_8:
                          	dq MAKE_SYMBOL_BUCKET(const_28,bucket_7)
                          const_29:
                          	dq MAKE_LITERAL_SYMBOL(bucket_8)
                          		const_30:
			dq MAKE_LITERAL(T_INTEGER,4)
		const_31:
			dq MAKE_LITERAL(T_CHAR,99)

            bucket_0:
                dq MAKE_SYMBOL_BUCKET(const_2, const_2)
            bucket_head:
                 dq 0
            global_table:
Lglob_54:
dq SOB_UNDEFINED
Lglob_55:
dq SOB_UNDEFINED
Lglob_52:
dq SOB_UNDEFINED
Lglob_53:
dq SOB_UNDEFINED
Lglob_50:
dq SOB_UNDEFINED
Lglob_51:
dq SOB_UNDEFINED
Lglob_48:
dq SOB_UNDEFINED
Lglob_49:
dq SOB_UNDEFINED
Lglob_46:
dq SOB_UNDEFINED
Lglob_47:
dq SOB_UNDEFINED
Lglob_44:
dq SOB_UNDEFINED
Lglob_45:
dq SOB_UNDEFINED
Lglob_42:
dq SOB_UNDEFINED
Lglob_43:
dq SOB_UNDEFINED
Lglob_40:
dq SOB_UNDEFINED
Lglob_41:
dq SOB_UNDEFINED
Lglob_38:
dq SOB_UNDEFINED
Lglob_39:
dq SOB_UNDEFINED
Lglob_36:
dq SOB_UNDEFINED
Lglob_37:
dq SOB_UNDEFINED
Lglob_34:
dq SOB_UNDEFINED
Lglob_35:
dq SOB_UNDEFINED
Lglob_32:
dq SOB_UNDEFINED
Lglob_33:
dq SOB_UNDEFINED
Lglob_30:
dq SOB_UNDEFINED
Lglob_31:
dq SOB_UNDEFINED
Lglob_28:
dq SOB_UNDEFINED
Lglob_29:
dq SOB_UNDEFINED
Lglob_26:
dq SOB_UNDEFINED
Lglob_27:
dq SOB_UNDEFINED
Lglob_24:
dq SOB_UNDEFINED
Lglob_25:
dq SOB_UNDEFINED
Lglob_22:
dq SOB_UNDEFINED
Lglob_23:
dq SOB_UNDEFINED
Lglob_20:
dq SOB_UNDEFINED
Lglob_21:
dq SOB_UNDEFINED
Lglob_18:
dq SOB_UNDEFINED
Lglob_19:
dq SOB_UNDEFINED
Lglob_16:
dq SOB_UNDEFINED
Lglob_17:
dq SOB_UNDEFINED
Lglob_14:
dq SOB_UNDEFINED
Lglob_15:
dq SOB_UNDEFINED
Lglob_12:
dq SOB_UNDEFINED
Lglob_13:
dq SOB_UNDEFINED
Lglob_10:
dq SOB_UNDEFINED
Lglob_11:
dq SOB_UNDEFINED
Lglob_8:
dq SOB_UNDEFINED
Lglob_9:
dq SOB_UNDEFINED
Lglob_6:
dq SOB_UNDEFINED
Lglob_7:
dq SOB_UNDEFINED
Lglob_4:
dq SOB_UNDEFINED
Lglob_5:
dq SOB_UNDEFINED
Lglob_2:
dq SOB_UNDEFINED
Lglob_3:
dq SOB_UNDEFINED
Lglob_1:
dq SOB_UNDEFINED

          	section .text
          		main:
                mov qword[bucket_head],bucket_8
                mov rax, malloc_pointer
				mov qword [rax], start_of_data2
                
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_40
                      mov qword[Lglob_54], rax
                      jmp lambda_body_end_40
                      lambda_body_start_40:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      TYPE rax
                      cmp rax, T_BOOL
                      jne cmp_false_13
                      mov rax, const_4
                      jmp finish_label_18
                      cmp_false_13:
                      mov rax,const_3
                      finish_label_18:
                      CLEAN_STACK
                      ret
                      lambda_body_end_40:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_39
                      mov qword[Lglob_8], rax
                      jmp lambda_body_end_39
                      lambda_body_start_39:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      mov rbx,rax
                      TYPE rax
                      cmp rax,T_PAIR
                      JNE ERROR_NOT_PAIR
                      mov rax,rbx
                      packed_car rax
                      CLEAN_STACK
                      ret
                      lambda_body_end_39:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_38
                      mov qword[Lglob_7], rax
                      jmp lambda_body_end_38
                      lambda_body_start_38:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rax,[rax]
                      mov rbx,rax
                      TYPE rax
                      cmp rax,T_PAIR
                      JNE ERROR_NOT_PAIR
                      mov rax,rbx
                      packed_cdr rax
                      CLEAN_STACK
                      ret
                      lambda_body_end_38:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_37
                      mov qword[Lglob_55], rax
                      jmp lambda_body_end_37
                      lambda_body_start_37:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rax,[rax]
                      TYPE rax
                      cmp rax, T_CHAR
                      jne cmp_false_12
                      mov rax, const_4
                      jmp finish_label_17
                      cmp_false_12:
                      mov rax,const_3
                      finish_label_17:
                      CLEAN_STACK
                      ret
                      lambda_body_end_37:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_36
                      mov qword[Lglob_52], rax
                      jmp lambda_body_end_36
                      lambda_body_start_36:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get secound param
                      cmp rax, rbx
                      jne cmp_false_11
                      mov rax, const_4 
                      jmp finish_label_16
                      cmp_false_11:
                      mov rax,const_3
                      finish_label_16:
                      CLEAN_STACK
                      ret
                      lambda_body_end_36:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_35
                      mov qword[Lglob_53], rax
                      jmp lambda_body_end_35
                      lambda_body_start_35:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rax,[rax]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne cmp_false_10
                      mov rax, const_4
                      jmp finish_label_15
                      cmp_false_10:
                      mov rax,const_3
                      finish_label_15:
                      CLEAN_STACK
                      ret
                      lambda_body_end_35:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_34
                      ;mov rax,[rax]
                      mov qword[Lglob_10], rax
                      jmp lambda_body_end_34
                      lambda_body_start_34:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get sec param
                      MAKE_PAIR rdx, rbx
                      test_malloc 8
                      mov [rax], rdx   
                      CLEAN_STACK
                      ret
                      lambda_body_end_34:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_33
                      mov qword[Lglob_48], rax
                      jmp lambda_body_end_33
                      lambda_body_start_33:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rdx,[rdx]
                      mov rax, rdx
                      TYPE rax
                      cmp rax, T_CHAR
                      jne ERROR_NOT_CHAR
                          
                      test_malloc 8
                   
                      shr rdx, TYPE_BITS
                      shl rdx, TYPE_BITS
                      or rdx, T_INTEGER
                     
                      mov [rax],rdx
                          
                      CLEAN_STACK
                      ret
                      lambda_body_end_33:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_32
                      mov qword[Lglob_13], rax
                      jmp lambda_body_end_32
                      lambda_body_start_32:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rdx,[rdx]
                      mov rax, qword[const_2] ;nil
                      cmp rdx, rax
                      jne cmp_false_9
                      mov rax, const_4 ; #t
                      jmp finish_label_14
                      cmp_false_9:
                      mov rax, const_3 ; #f
                      finish_label_14:    
                      CLEAN_STACK
                      ret
                      lambda_body_end_32:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_31
                      mov qword[Lglob_25], rax
                      jmp lambda_body_end_31
                      lambda_body_start_31:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rdx, [rdx]
                      cmp rdx, T_INTEGER
                      jne cmp_false_8
                      mov rax, const_4 ; #t
                      jmp finish_label_13
                      cmp_false_8:
                      mov rax, const_3 ; #f
                      finish_label_13:    
                      CLEAN_STACK
                      ret
                      lambda_body_end_31:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_30
                      mov qword[Lglob_46], rax
                      jmp lambda_body_end_30
                      lambda_body_start_30:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      TYPE rax
                      cmp rax, T_PAIR
                      jne cmp_false_7
                      mov rax,const_4
                      jmp finish_label_12
                      cmp_false_7:
                      mov rax,const_3
                      finish_label_12:
                      CLEAN_STACK
                      ret
                      lambda_body_end_30:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_29
                      mov qword[Lglob_47], rax
                      jmp lambda_body_end_29
                      lambda_body_start_29:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne cmp_false_6
                      mov rax, const_4
                      jmp finish_label_11
                      cmp_false_6:
                      cmp rax, T_FRACTION
                      je cmp_true_1
                      mov rax,const_3
                      jmp finish_label_11
                      cmp_true_1:
                      mov rax, const_4                            
                      finish_label_11:
                      CLEAN_STACK
                      ret
                      lambda_body_end_29:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_28
                      mov qword[Lglob_11], rax
                      jmp lambda_body_end_28
                      lambda_body_start_28:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 3*8] ;n
                      cmp rax, 2
                      jne ERROR_NOT_CLOSURE
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get 2nd param
                      mov rdx,[rdx]
                      mov rbx,[rbx]                          
                      mov rax, rdx
                      TYPE rax
                      cmp rax, T_CLOSURE
                      jne ERROR_NOT_CLOSURE
                      mov rax, rbx
                      TYPE rax
                      cmp rax, T_PAIR
                      JNE check_nil_1
                      jmp type_ok_1
                      check_nil_1:
                      cmp rax, T_NIL
                      JNE ERROR_NOT_PAIR
                      type_ok_1:
                      mov rdi, 0
                      mov rcx, rbx
                      mov rax, const_2
                      loop_enter_4:
                      cmp rcx,T_NIL
                      je loop_exit_4
                      mov r8, rcx
                      packed_car r8
                      MAKE_PAIR r8, rax
                      test_malloc 8
                      mov [rax], r8
                      CDR rcx
                      inc rdi
                      jmp loop_enter_4
                      loop_exit_4:
                      ;push params
                      push const_2
                      mov rax, [rax]
                      loop_enter_5:
                      cmp rax,T_NIL
                      je loop_exit_5
                      mov rcx, rax
                      packed_car rcx
                      push rcx
                      CDR rax
                      jmp loop_enter_5             
                      loop_exit_5:
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
                      loop_enter_6:
                      cmp rsi, rdi
                      je loop_exit_6
                      sub r8, 8
                      sub r10,8 
                      .b:          
                      mov r9, [r8]
                      mov [r10], r9
                      inc rsi
                      jmp loop_enter_6
                      loop_exit_6:                                    
                      add rsp, 7*8
                      .b:
                      mov rax, rdx                      
                      CLOSURE_CODE rax
                      jmp rax           
                      lambda_body_end_28:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_27
                      mov qword[Lglob_18], rax
                      jmp lambda_body_end_27
                      lambda_body_start_27:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get 2nd param
                      ;*** check_first ***
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne check_fraction_9
                      
                      ;*** first: integer check second *****
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne check_fraction_7
                      
                      ; **** both are integer *****
                      mov rdx, [rdx]
                      mov rbx, [rbx]                     
                      DATA rdx
                      DATA rbx
                      add rdx, rbx
                      MAKE_INT rdx
                      jmp finish_add_3
                      
                      check_fraction_9:
                      
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      jne ERROR_16
                      
                      ;**first: fraction check second **

                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      je both_fraction_3
                      cmp rax, T_INTEGER
                      jne ERROR_16
                      
                      ; first: fraction second: integer

                      jmp int_with_fract_1

                      check_fraction_7:
                      
                      ;first: integer check second

                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      jne ERROR_16

                      ;first: integer second: fraction
                      ;change between rbx and rdx
                      mov r8, rdx
                      mov rdx, rbx
                      mov rbx, r8

                      jmp int_with_fract_1
                  
                      check_fraction_8:

                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      jne ERROR_16                     
                      both_fraction_3:
                      
                      ADD_FRACTION rdx, rbx               
                      MAKE_FRACTION rdx, rbx
                      REDUCE rdx
                      REMOVE_FRACTION rdx              
                      jmp finish_add_3

                      int_with_fract_1:
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

                      finish_add_3:
                      test_malloc 8
                      mov [rax],rdx
                                            
                      CLEAN_STACK
                      ret
                      ERROR_16:
                      CLEAN_STACK
                      jmp ERROR
                      lambda_body_end_27:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_26
                      mov qword[Lglob_17], rax
                      jmp lambda_body_end_26
                      lambda_body_start_26:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get 2nd para
                      ;*** check_first ***
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne check_fraction_6
                      
                      ;*** first: integer check second *****
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne check_fraction_4
                      
                      ; **** both are integer *****
                      mov rdx, [rdx]
                      mov rbx, [rbx]                     
                      DATA rdx
                      DATA rbx
                      sub rdx, rbx
                      MAKE_INT rdx
                      jmp finish_add_2
                      
                      check_fraction_6:
                      
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      jne ERROR_NOT_NUMBER
                      
                      ;**first: fraction check second **
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      je both_fraction_2
                      cmp rax, T_INTEGER
                      jne ERROR_NOT_NUMBER
                      
                      ; first: fraction second: integer                   
                      
                      mov rax, const_5                 
                      MAKE_FRACTION rbx, rax
                      test_malloc 8
                      mov [rax], rbx
                      mov rbx, rax
                                         
                      jmp both_fraction_2
                      
                      check_fraction_4:
                      
                      ;first: integer check second
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne check_fraction_5
                      ;first: integer second: fraction
                                               
                      mov rax, const_5                 
                      MAKE_FRACTION rdx, rax
                      
                      test_malloc 8
                      mov [rax], rdx
                      mov rdx, rax
                                              
                      jmp both_fraction_2
                      
                      check_fraction_5:
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      jne ERROR_NOT_NUMBER                     
                      both_fraction_2:
                      
                      NEG_FRACTION rbx
                      
                      ADD_FRACTION rdx, rbx 
                                 
                      MAKE_FRACTION rdx, rbx
                      REDUCE rdx
                      REMOVE_FRACTION rdx              
                      
                      finish_add_2:
                      test_malloc 8
                      mov [rax],rdx                      
                      CLEAN_STACK
                      ret
                      lambda_body_end_26:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_25
                      mov qword[Lglob_45], rax
                      jmp lambda_body_end_25
                      lambda_body_start_25:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      TYPE rax
                      cmp rax, T_VECTOR
                      jne cmp_false_5
                      mov rax,const_4
                      jmp finish_label_9
                      cmp_false_5:
                      mov rax,const_3
                      finish_label_9:
                      CLEAN_STACK
                      ret
                      lambda_body_end_25:
                      
                            
                      mov rax, qword[Lglob_47]
                      mov qword[Lglob_42],rax
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_24
                      mov qword[Lglob_43], rax
                      jmp lambda_body_end_24
                      lambda_body_start_24:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      TYPE rax
                      cmp rax, T_STRING
                      jne cmp_false_4
                      mov rax,const_4
                      jmp finish_label_8
                      cmp_false_4:
                      mov rax,const_3
                      finish_label_8:
                      CLEAN_STACK
                      ret
                      lambda_body_end_24:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_23
                      mov qword[Lglob_40], rax
                      jmp lambda_body_end_23
                      lambda_body_start_23:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      TYPE rax
                      cmp rax, T_CLOSURE
                      jne cmp_false_3
                      mov rax,const_4
                      jmp finish_label_7
                      cmp_false_3:
                      mov rax,const_3
                      finish_label_7:
                      CLEAN_STACK
                      ret
                      lambda_body_end_23:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_22
                      mov qword[Lglob_44], rax
                      jmp lambda_body_end_22
                      lambda_body_start_22:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      mov rbx,rax
                      TYPE rax
                      cmp rax,T_FRACTION
                      jne check_integer_2
                      mov rax,rbx
                      packed_car rax
                      jmp finish_label_6
                      check_integer_2:
                      cmp rax, T_INTEGER
                      jne ERROR_NOT_NUMBER
                      mov rax, qword[rbp + 4*8] 
                      finish_label_6:     
                      CLEAN_STACK
                      ret
                      lambda_body_end_22:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_21
                      mov qword[Lglob_50], rax
                      jmp lambda_body_end_21
                      lambda_body_start_21:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rax, [rax]
                      mov rbx,rax
                      TYPE rax
                      cmp rax,T_FRACTION
                      jne check_integer_1
                      mov rax,rbx
                      packed_cdr rax
                      jmp finish_label_5
                      check_integer_1:
                      cmp rax, T_INTEGER
                      jne ERROR_NOT_NUMBER
                      mov rax, const_5 
                      finish_label_5:     
                      CLEAN_STACK
                      ret
                      lambda_body_end_21:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_20
                      mov qword[Lglob_41], rax
                      jmp lambda_body_end_20
                      lambda_body_start_20:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rbx, [rax]
                      TYPE rbx
                      cmp rbx,T_PAIR
                      JNE ERROR_NOT_PAIR
                      mov rbx, [rax]
                      packed_cdr rbx
                      mov rdx, qword[rbp + 5*8]
                      MAKE_PAIR rdx, rbx
                      mov [rax], rdx
                      mov rax, const_1
                      CLEAN_STACK
                      ret
                      lambda_body_end_20:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_19
                      mov qword[Lglob_38], rax
                      jmp lambda_body_end_19
                      lambda_body_start_19:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rbx, [rax]
                      TYPE rbx
                      cmp rbx,T_PAIR
                      JNE ERROR_NOT_PAIR
                      mov rbx, [rax]
                      packed_car rbx
                      mov rdx, qword[rbp + 5*8]
                      MAKE_PAIR rbx, rdx
                      mov [rax], rbx
                      mov rax, const_1
                      CLEAN_STACK
                      ret
                      lambda_body_end_19:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_18
                      mov qword[Lglob_51], rax
                      jmp lambda_body_end_18
                      lambda_body_start_18:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8]
                      mov rbx, qword[rbp + 5*8]    
                      mov rax,[rdx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR_15
                      mov rax,[rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR_15
                      mov rax, [rdx]
                      DATA rax
                      mov r8, rax
                      xor rdx, rdx
                      mov rbx, [rbx]
                      DATA rbx
                      div rbx
                      cmp r8, 0
                      jg positive_2
                      neg rdx         
                      positive_2:               
                      MAKE_INT rdx
                      test_malloc 8
                      mov [rax], rdx                          
                      jmp finish_label_4             
                      ERROR_15:
                      CLEAN_STACK
                      jmp ERROR
                      finish_label_4:
                      CLEAN_STACK
                      ret
                      lambda_body_end_18:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_17
                      mov qword[Lglob_49], rax
                      jmp lambda_body_end_17
                      lambda_body_start_17:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rdx,[rdx]
                      mov rax, rdx
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR_NOT_CHAR    
                      test_malloc 8
                      DATA rdx
                      shl rdx, TYPE_BITS
                      or rdx, T_CHAR
                      mov [rax],rdx
                      CLEAN_STACK
                      ret
                      lambda_body_end_17:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_16
                      mov qword[Lglob_24], rax
                      jmp lambda_body_end_16
                      lambda_body_start_16:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      cmp rdx, const_3
                      jne cmp_false_2
                      mov rax, const_4 ; #t
                      jmp finish_label_3
                      cmp_false_2:
                      mov rax, const_3 ; #f
                      finish_label_3:    
                      CLEAN_STACK
                      ret
                      lambda_body_end_16:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_15
                      mov qword[Lglob_14], rax
                      jmp lambda_body_end_15
                      lambda_body_start_15:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get 2nd param
                      ;*** check_first ***
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne check_fraction_3
                      
                      ;*** first: integer check second *****
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne check_fraction_1
                      
                      ; **** both are integer *****
                      mov rdx, [rdx]
                      mov rbx, [rbx]                     
                      DATA rdx
                      DATA rbx
                      cmp rdx, rbx
                      je equal_1
                      mov rax, const_3                   
                      jmp finish_add_1
                      check_fraction_3:
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      jne ERROR_14
                      
                      ;**first: fraction check second **
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      je both_fraction_1
                      cmp rax, T_INTEGER
                      jne ERROR_14
                      
                      ; first: fraction second: integer                   
                      mov rax, const_3
                      jmp finish_add_1
                      
                      check_fraction_1:
                      
                      ;first: integer check second
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER;
                      jne check_fraction_2
                      ;first: integer second: fraction                      
                      mov rax, const_3
                      jmp finish_add_1
                      
                      check_fraction_2:
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      jne ERROR_14                     
                      both_fraction_1:
                      mov rdx, [rdx] ;first number
                      mov rbx, [rbx] ;second number
                      mov rax, rdx
                      CAR rax ; mone1
                      mov rcx, rbx
                      CAR rcx ; mone2
                      cmp rax, rcx
                      je continue_label_1
                      mov rax, const_3
                      jmp finish_add_1
                      continue_label_1:              
                      mov rax, rdx
                      CDR rax ; mone1
                      mov rcx, rbx
                      CDR rcx ; mone2
                      cmp rax, rcx             
                      mov rax, const_3
                      jne finish_add_1 
                      equal_1:        
                      mov rax, const_4
                      finish_add_1:                  
                      CLEAN_STACK
                      ret
                      ERROR_14:
                      CLEAN_STACK
                      jmp ERROR
                      lambda_body_end_15:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_14
                      mov qword[Lglob_27], rax
                      jmp lambda_body_end_14
                      lambda_body_start_14:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_INTEGER
                      je test_1
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      je test_2
                      jmp ERROR_13
                      test_1:
                      mov rax, [rdx]
                      DATA rax
                      cmp rax,0
                      jg positive_1
                      mov rax, const_3
                      jmp finish_label_2
                      test_2:
                      mov rax, [rdx]
                      CAR rax
                      DATA rax
                      cmp rax,0
                      jg positive_1
                      mov rax,const_3
                      jmp finish_label_2
                      positive_1:
                      mov rax, const_4
                      jmp finish_label_2
                      finish_label_2:
                      CLEAN_STACK
                      ret
                      ERROR_13:
                      CLEAN_STACK
                      jmp ERROR
                      lambda_body_end_14:
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_13
                      mov qword[Lglob_22], rax
                      jmp lambda_body_end_13
                      lambda_body_start_13:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get 2nd param
                      ;*** check_first ***
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_FRACTION
                      je compare_second_2
                      cmp rax, T_INTEGER
                      jne ERROR_12
                      ;*** change one to fraction ***

                      mov rax, const_5                 
                      MAKE_FRACTION rdx, rax
                      test_malloc 8
                      mov [rax], rdx
                      mov rdx, rax

                      ;*** check second ***
                      compare_second_2:
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      je multiple_2
                      cmp rax, T_INTEGER
                      jne ERROR_12

                      ;***change second to fraction ***
                      mov rax, const_5                 
                      MAKE_FRACTION rbx, rax
                      test_malloc 8
                      mov [rax], rbx
                      mov rbx, rax

                      ;***both are fractions time to multiple
                      multiple_2:
                      MUL_FRACTION rdx, rbx
                      MAKE_FRACTION rdx, rbx
                      REDUCE rdx
                      REMOVE_FRACTION rdx
                      test_malloc 8
                      mov [rax],rdx      
                      CLEAN_STACK
                      ret
                      ERROR_12:
                      CLEAN_STACK
                      jmp ERROR
                      lambda_body_end_13:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_12
                      mov qword[Lglob_21], rax
                      jmp lambda_body_end_12
                      lambda_body_start_12:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get 2nd param
                      ;*** check_first ***
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_FRACTION
                      je compare_second_1
                      cmp rax, T_INTEGER
                      jne ERROR_11
                      ;*** change one to fraction ***

                      mov rax, const_5                 
                      MAKE_FRACTION rdx, rax
                      test_malloc 8
                      mov [rax], rdx
                      mov rdx, rax

                      ;*** check second ***
                      compare_second_1:
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_FRACTION
                      je divide_2
                      cmp rax, T_INTEGER
                      jne ERROR_11
                      ;this is integer - divide in zero handling
                      mov rax, [rbx]
                      DATA rax
                      cmp rax, 0
                      je ERROR_11

                      ;***change second to fraction ***
                      mov rax, const_5                 
                      MAKE_FRACTION rbx, rax
                      test_malloc 8
                      mov [rax], rbx
                      mov rbx, rax

                      ;***both are fractions time to divide
                      divide_2:
                      ;***first switch second mone with mechane
                      mov r8, [rbx]
                      CAR r8 ;mone
                      mov rcx, r8 ; check if negative
                      DATA rcx
                      cmp rcx, 0
                      jg divide_1
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
                      jmp multiple_1
                      
                      divide_1:
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
                      multiple_1:
                      MUL_FRACTION rdx, rbx
                      MAKE_FRACTION rdx, rbx
                      REDUCE rdx
                      REMOVE_FRACTION rdx
                      test_malloc 8
                      mov [rax],rdx      
                      CLEAN_STACK
                      ret
                      ERROR_11:
                      CLEAN_STACK
                      jmp ERROR
                      lambda_body_end_12:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_11
                      mov qword[Lglob_39], rax
                      jmp lambda_body_end_11
                      lambda_body_start_11:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_STRING
                      jne ERROR_10
                      mov rcx, [rdx]
                      STRING_LENGTH rcx
                      MAKE_INT rcx
                      test_malloc 8
                      mov [rax], rcx
                      CLEAN_STACK
                      ret
                      ERROR_10:
                      CLEAN_STACK
                      jmp ERROR
                      lambda_body_end_11:
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_10
                      mov qword[Lglob_36], rax
                      jmp lambda_body_end_10
                      lambda_body_start_10:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_VECTOR
                      jne ERROR_9
                      mov rcx, [rdx]
                      VECTOR_LENGTH rcx
                      MAKE_INT rcx
                      test_malloc 8
                      mov [rax], rcx
                      CLEAN_STACK
                      ret
                      ERROR_9:
                      CLEAN_STACK
                      jmp ERROR
                      lambda_body_end_10:
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_9
                      mov qword[Lglob_37], rax
                      jmp lambda_body_end_9
                      lambda_body_start_9:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get second param
                      mov rax, [rdx] 
                      TYPE rax
                      cmp rax, T_VECTOR
                      jne ERROR_8
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR_8
                      mov rbx, [rbx]
                      mov rdx, [rdx]
                      DATA rbx
                      test_malloc 8
                      mov r8, rax
                      VECTOR_REF r8,rdx,rbx
                      test_malloc 8
                      mov [rax], r8
                      CLEAN_STACK
                      ret
                      ERROR_8:
                      CLEAN_STACK
                      jmp ERROR
                      lambda_body_end_9:
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_8
                      mov qword[Lglob_34], rax
                      jmp lambda_body_end_8
                      lambda_body_start_8:
                      push rbp
                      mov rbp, rsp
                      mov rdx, qword[rbp + 4*8] ;get first param
                      mov rbx, qword[rbp + 5*8] ;get second param
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_STRING
                      jne ERROR_7
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR_7
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
                      ERROR_7:
                      CLEAN_STACK
                      jmp ERROR
                      lambda_body_end_8:
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_7
                      mov qword[Lglob_35], rax
                      jmp lambda_body_end_7
                      lambda_body_start_7:
                      push rbp
                      mov rbp, rsp
                      mov rax, qword[rbp + 4*8]
                      mov rax,[rax]
                      TYPE rax
                      cmp rax, T_SYMBOL
                      jne cmp_false_1
                      mov rax, const_4
                      jmp finish_label_1
                      cmp_false_1:
                      mov rax,const_3
                      finish_label_1:
                      CLEAN_STACK
                      ret
                      lambda_body_end_7:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_6
                      mov qword[Lglob_32], rax
                      jmp lambda_body_end_6
                      lambda_body_start_6:
                      push rbp
                      mov rbp, rsp
                      mov rbx, qword[rbp + 4*8] ;get first param
                      mov rcx, qword[rbp + 5*8] ;get second param
                      mov rdx, qword[rbp + 6*8] ;get third param
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_STRING
                      jne ERROR_6
                      mov rax, [rcx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR_6
                      mov rax, [rdx]
                      TYPE rax
                      cmp rax, T_CHAR
                      jne ERROR_6
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
                      ERROR_6:
                      CLEAN_STACK
                      jmp ERROR
                      lambda_body_end_6:
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_5
                      mov qword[Lglob_33], rax
                      jmp lambda_body_end_5
                      lambda_body_start_5:
                      push rbp
                      mov rbp, rsp
                      mov rbx, qword[rbp + 4*8] ;get first param
                      mov rcx, qword[rbp + 5*8] ;get second param
                      mov rdx, qword[rbp + 6*8] ;get third param
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_VECTOR
                      jne ERROR_5
                      mov rax, [rcx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR_5
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
                      ERROR_5:
                      CLEAN_STACK
                      jmp ERROR
                      lambda_body_end_5:
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_4
                      mov qword[Lglob_2], rax
                      jmp lambda_body_end_4
                      lambda_body_start_4:
                      push rbp
                      mov rbp, rsp
                      mov r8, qword[rbp + 3*8] ;n
                      cmp r8, 2
                      jg ERROR_4 ;error
                      cmp r8, 1
                      jl ERROR_4 ;error
                      mov rbx, qword[rbp + 4*8] ;get first param
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR_4
                      cmp r8, 2
                      je regular_case_2
                      ;case of 1 param
                      mov rdx, 0
                      jmp build_string_1

                      regular_case_2:
                      ;REGULAR CASE with value to init
                      mov rcx, qword[rbp + 5*8] ;get second param
                      mov rax, [rcx]
                      TYPE rax
                      cmp rax, T_CHAR
                      jne ERROR_4
                      mov rdx, [rcx]
                      DATA rdx ;the char to init
                      
                      ;Now we build the string - char in rdx
                      build_string_1:
                      mov r9, [rbx]
                      DATA r9; iteration in loop
                      test_malloc rax
                      mov r8, rax ; save pointer to begining of malloc in rax
                      mov rsi, 0

                      loop_enter_3:
                      cmp rsi, r9
                      je loop_exit_3 
                      mov [r8+rsi], dl
                      ;add r8, 1
                      add rsi, 1
                      jmp loop_enter_3

                      loop_exit_3:
                      add r8, r9
                      MAKE_STRING rax, r8
                      test_malloc 8
                      mov [rax], r8
                      CLEAN_STACK
                      ret

                      ERROR_4:
                      CLEAN_STACK
                      jmp ERROR
                      lambda_body_end_4:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_3
                      mov qword[Lglob_30], rax
                      jmp lambda_body_end_3
                      lambda_body_start_3:
                      push rbp
                      mov rbp, rsp
                      mov r8, qword[rbp + 3*8] ;n
                      cmp r8, 2
                      jg ERROR_3 ;error
                      cmp r8, 1
                      jl ERROR_3 ;error
                      mov rbx, qword[rbp + 4*8] ;get first param
                      mov rax, [rbx]
                      TYPE rax
                      cmp rax, T_INTEGER
                      jne ERROR_3
                      cmp r8, 2
                      je regular_case_1
                      ;case of 1 param
                      mov rdx, 0
                      MAKE_INT rdx
                      jmp build_vector_1

                      regular_case_1:
                      ;REGULAR CASE with value to init
                      mov rcx, qword[rbp + 5*8] ;get second param
                      mov rdx, [rcx]

                      ;Now we build the string - value in rdx
                      build_vector_1:
                      mov r9, [rbx]
                      DATA r9; iteration in loop
                      mov r10,r9 ; save condition for end of loop
                      shl r9, 3 ; (multiple by 8 for place to pointer for each value)
                      test_malloc r9
                      mov r8, rax
                      mov r11, r8 ; save pointer to beginning of malloc in r11
                      mov rsi, 0
                      loop_enter_2:
                      cmp rsi, r10
                      je loop_exit_2
                      test_malloc 8
                      mov [rax], rdx
                      mov [r8+rsi*8], rax
                      add rsi, 1
                      jmp loop_enter_2

                      loop_exit_2:
                      add r8, r9
                      MAKE_VECTOR r11, r8
                      test_malloc 8
                      mov [rax], r8
                      CLEAN_STACK
                      ret

                      ERROR_3:
                      CLEAN_STACK
                      jmp ERROR
                      lambda_body_end_3:
                      
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_2
                      mov qword[Lglob_4], rax
                      jmp lambda_body_end_2
                      lambda_body_start_2:
                      push rbp
                      mov rbp, rsp
                      mov rbx, qword[rbp + 4*8] ;get first param
                      mov rbx,[rbx]
                      mov rax, rbx
                      TYPE rax
                      cmp rax, T_SYMBOL
                      JNE ERROR
                      GET_SYMBOL_BUCKET rbx
                      mov rbx, [rbx]
                      CAR rbx
                      test_malloc 8
                      mov [rax],rbx
                      CLEAN_STACK
                      RET
                      lambda_body_end_2:
                            
                      test_malloc 16
                      mov rbx,0 ;setup fake env
                      MAKE_LITERAL_CLOSURE rax, rbx ,lambda_body_start_1
                      mov qword[Lglob_3], rax
                      jmp lambda_body_end_1
                      lambda_body_start_1:
                      push rbp
                      mov rbp, rsp
                      mov rbx, qword[rbp + 4*8] ;get first param
                      mov r9,[rbx]
                      mov rax, r9
                      TYPE rax
                      cmp rax, T_STRING
                      JNE ERROR
                      mov rdx, qword[bucket_head]
                      loop_enter_1:
                      cmp rdx, bucket_0
                      je .create_new_bucket
                      mov r8, rdx
                      mov rdx, [rdx]
                      mov rax, rdx
                      CAR rax
                      STR_CMPR rax, r9
                  	  je .found_bucket ;bucket is in r8
                      packed_cdr rdx
                      jmp loop_enter_1
                      .create_new_bucket:
                      mov rdx, qword[bucket_head]
             		  MAKE_BUCKET rbx, rdx
                      test_malloc 8
                      mov [rax], rbx
                      mov [bucket_head],rax
                      mov r8,rax
                      .found_bucket:
                      MAKE_SYMBOL r8
                      test_malloc 8
                      mov [rax], r8
                      .finish:
                      CLEAN_STACK
                      RET
                      lambda_body_end_1:
                            
                push const_2
                mov rax, 0
                push rax
                mov rax, [const_2]
                push rax
                mov rax, 0x1234
                push rax
                push rbp
          	    mov rbp, rsp
                

                            
                   	test_malloc 8
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_8:
                        cmp rdi, 0
                        je loop_exit_8 
                        mov r10, [rax + rdi*8]            ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10       ;;  env[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_8
                        loop_exit_8:
                        mov r8, [rbp+8*3] ;n
                        add r8, 1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_9:
                        cmp rdi , r8
                        je loop_exit_9
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
              			;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_9
                        loop_exit_9:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_41
                    jmp lambda_body_end_41
                    lambda_body_start_41:
                    push rbp
                    mov rbp, rsp
                    mov r8, [rbp+3*8] ;n
                    sub r8, 0
                    mov rdi, 8* 0
                    add rdi, 3*8
                    mov rsi, r8
                    mov rax, const_2
                    loop_enter_7:
                    cmp rsi, 0
                    je loop_exit_7
                    push rax
                    mov rax, rsi
                    shl rax,3
                    mov r10, rdi
                    add r10,rax
                    mov rax, qword[rbp + r10]
                    push rax
                    mov rax, [Lglob_10]
                    CALL_LIB_FUN rax, 1                    
                    dec rsi
                    jmp loop_enter_7
                    loop_exit_7:
                    mov [rbp + 32], rax
                    mov rax, [rbp + (4+0) * 8]
                    CLEAN_STACK
                    ret
                    lambda_body_end_41:
                    
                         mov qword[Lglob_31], rax
                         mov rax, const_1
                        
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                   	test_malloc 8
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_11:
                        cmp rdi, 0
                        je loop_exit_11 
                        mov r10, [rax + rdi*8]            ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10       ;;  env[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_11
                        loop_exit_11:
                        mov r8, [rbp+8*3] ;n
                        add r8, 1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_12:
                        cmp rdi , r8
                        je loop_exit_12
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
              			;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_12
                        loop_exit_12:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_42
                    jmp lambda_body_end_42
                    lambda_body_start_42:
                    push rbp
                    mov rbp, rsp
                    mov r8, [rbp+3*8] ;n
                    sub r8, 0
                    mov rdi, 8* 0
                    add rdi, 3*8
                    mov rsi, r8
                    mov rax, const_2
                    loop_enter_10:
                    cmp rsi, 0
                    je loop_exit_10
                    push rax
                    mov rax, rsi
                    shl rax,3
                    mov r10, rdi
                    add r10,rax
                    mov rax, qword[rbp + r10]
                    push rax
                    mov rax, [Lglob_10]
                    CALL_LIB_FUN rax, 1                    
                    dec rsi
                    jmp loop_enter_10
                    loop_exit_10:
                    mov [rbp + 32], rax
                    
                    mov rax, const_2
                    push rax           
                    MOV RAX,const_3
                             
push rax

                    mov rax, 1
                    push rax                                           
                    
                   	test_malloc 16
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_14:
                        cmp rdi, 1
                        je loop_exit_14 
                        mov r10, [rax + rdi*8]              ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10        ;;  env'[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_14
                        loop_exit_14:
                        mov r8, [rbp+8*3] ;n
                        add r8,1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_15:
                        cmp rdi , r8
                        je loop_exit_15
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
                        ;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_15
                        loop_exit_15:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_43
                    jmp lambda_body_end_43
                    lambda_body_start_43:
                    push rbp
                    mov rbp, rsp
                    
                mov rax, [rbp + (4+0) * 8]
                mov rbx,rax
               	test_malloc 8
                mov qword[rax],rbx
                
                         mov qword[rbp + (4+0)*8],rax
                         mov rax, const_1
                        
                
                   	test_malloc 24
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_17:
                        cmp rdi, 2
                        je loop_exit_17 
                        mov r10, [rax + rdi*8]              ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10        ;;  env'[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_17
                        loop_exit_17:
                        mov r8, [rbp+8*3] ;n
                        add r8,1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_18:
                        cmp rdi , r8
                        je loop_exit_18
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
                        ;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_18
                        loop_exit_18:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_44
                    jmp lambda_body_end_44
                    lambda_body_start_44:
                    push rbp
                    mov rbp, rsp
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_2
                            mov rax, [rbp + (4+1) * 8]
                            jmp if_exit_2
                            if_else_2:
                            
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax

                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_7]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 2
                    push rax
                    
                mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
                mov rax,qword[rax]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_8]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_10]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_19:
                                    cmp rdi, 6
                                    je loop_exit_19
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_19
                                    loop_exit_19:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            if_exit_2:
                    CLEAN_STACK
                    ret
                    lambda_body_end_44:
                    
                mov rbx,rax
                mov rax, [rbp + (4+0) * 8]
                mov qword[rax],rbx
                mov rax,const_1
                
                    mov rax, const_2
                    push rax
                    mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_1
                            mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
                            jmp if_exit_1
                            if_else_1:
                            
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_7]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax
mov rax,qword[Lglob_28]
                
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_11]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, const_2
                    push rax
                    mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_8]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 2
                    push rax                                           
                    
                mov rax, [rbp + (4+0) * 8]
                mov rax,qword[rax]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_16:
                                    cmp rdi, 6
                                    je loop_exit_16
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_16
                                    loop_exit_16:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            if_exit_1:
                    CLEAN_STACK
                    ret
                    lambda_body_end_43:
                                         
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_13:
                                    cmp rdi, 5
                                    je loop_exit_13
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_13
                                    loop_exit_13:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                    CLEAN_STACK
                    ret
                    lambda_body_end_42:
                    
                         mov qword[Lglob_28], rax
                         mov rax, const_1
                        
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                   	test_malloc 8
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_21:
                        cmp rdi, 0
                        je loop_exit_21 
                        mov r10, [rax + rdi*8]            ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10       ;;  env[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_21
                        loop_exit_21:
                        mov r8, [rbp+8*3] ;n
                        add r8, 1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_22:
                        cmp rdi , r8
                        je loop_exit_22
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
              			;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_22
                        loop_exit_22:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_45
                    jmp lambda_body_end_45
                    lambda_body_start_45:
                    push rbp
                    mov rbp, rsp
                    mov r8, [rbp+3*8] ;n
                    sub r8, 1
                    mov rdi, 8* 1
                    add rdi, 3*8
                    mov rsi, r8
                    mov rax, const_2
                    loop_enter_20:
                    cmp rsi, 0
                    je loop_exit_20
                    push rax
                    mov rax, rsi
                    shl rax,3
                    mov r10, rdi
                    add r10,rax
                    mov rax, qword[rbp + r10]
                    push rax
                    mov rax, [Lglob_10]
                    CALL_LIB_FUN rax, 1                    
                    dec rsi
                    jmp loop_enter_20
                    loop_exit_20:
                    mov [rbp + 40], rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_3
                            MOV RAX,const_4
                             
                            jmp if_exit_3
                            if_else_3:
                            
                    mov rax, const_2
                    push rax           
                    MOV RAX,const_3
                             
push rax

                    mov rax, 1
                    push rax                                           
                    
                   	test_malloc 16
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_24:
                        cmp rdi, 1
                        je loop_exit_24 
                        mov r10, [rax + rdi*8]              ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10        ;;  env'[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_24
                        loop_exit_24:
                        mov r8, [rbp+8*3] ;n
                        add r8,1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_25:
                        cmp rdi , r8
                        je loop_exit_25
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
                        ;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_25
                        loop_exit_25:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_46
                    jmp lambda_body_end_46
                    lambda_body_start_46:
                    push rbp
                    mov rbp, rsp
                    
                mov rax, [rbp + (4+0) * 8]
                mov rbx,rax
               	test_malloc 8
                mov qword[rax],rbx
                
                         mov qword[rbp + (4+0)*8],rax
                         mov rax, const_1
                        
                
                   	test_malloc 24
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_27:
                        cmp rdi, 2
                        je loop_exit_27 
                        mov r10, [rax + rdi*8]              ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10        ;;  env'[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_27
                        loop_exit_27:
                        mov r8, [rbp+8*3] ;n
                        add r8,1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_28:
                        cmp rdi , r8
                        je loop_exit_28
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
                        ;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_28
                        loop_exit_28:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_47
                    jmp lambda_body_end_47
                    lambda_body_start_47:
                    push rbp
                    mov rbp, rsp
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+2) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_4
                            
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_16]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 1
                    push rax                                           
                    mov rax,qword[Lglob_27]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_29:
                                    cmp rdi, 5
                                    je loop_exit_29
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_29
                                    loop_exit_29:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            jmp if_exit_4
                            if_else_4:
                            
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_16]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_27]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_5
                            
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+2) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_7]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+2) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_8]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax
mov rax, [rbp + (4+1) * 8]
push rax

                    mov rax, 3
                    push rax                                           
                    
                mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
                mov rax,qword[rax]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_30:
                                    cmp rdi, 7
                                    je loop_exit_30
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_30
                                    loop_exit_30:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            jmp if_exit_5
                            if_else_5:
                            MOV RAX,const_3
                             
                            if_exit_5:
                            if_exit_4:
                    CLEAN_STACK
                    ret
                    lambda_body_end_47:
                    
                mov rbx,rax
                mov rax, [rbp + (4+0) * 8]
                mov qword[rax],rbx
                mov rax,const_1
                
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 1*8]
                            
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_7]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, const_2
                    push rax
                    mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 1*8]
                            
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_8]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax
mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
push rax

                    mov rax, 3
                    push rax                                           
                    
                mov rax, [rbp + (4+0) * 8]
                mov rax,qword[rax]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_26:
                                    cmp rdi, 7
                                    je loop_exit_26
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_26
                                    loop_exit_26:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                    CLEAN_STACK
                    ret
                    lambda_body_end_46:
                                         
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_23:
                                    cmp rdi, 5
                                    je loop_exit_23
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_23
                                    loop_exit_23:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            if_exit_3:
                    CLEAN_STACK
                    ret
                    lambda_body_end_45:
                    
                         mov qword[Lglob_29], rax
                         mov rax, const_1
                        
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                   	test_malloc 8
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_32:
                        cmp rdi, 0
                        je loop_exit_32 
                        mov r10, [rax + rdi*8]            ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10       ;;  env[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_32
                        loop_exit_32:
                        mov r8, [rbp+8*3] ;n
                        add r8, 1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_33:
                        cmp rdi , r8
                        je loop_exit_33
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
              			;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_33
                        loop_exit_33:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_48
                    jmp lambda_body_end_48
                    lambda_body_start_48:
                    push rbp
                    mov rbp, rsp
                    mov r8, [rbp+3*8] ;n
                    sub r8, 1
                    mov rdi, 8* 1
                    add rdi, 3*8
                    mov rsi, r8
                    mov rax, const_2
                    loop_enter_31:
                    cmp rsi, 0
                    je loop_exit_31
                    push rax
                    mov rax, rsi
                    shl rax,3
                    mov r10, rdi
                    add r10,rax
                    mov rax, qword[rbp + r10]
                    push rax
                    mov rax, [Lglob_10]
                    CALL_LIB_FUN rax, 1                    
                    dec rsi
                    jmp loop_enter_31
                    loop_exit_31:
                    mov [rbp + 40], rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_6
                            MOV RAX,const_4
                             
                            jmp if_exit_6
                            if_else_6:
                            
                    mov rax, const_2
                    push rax           
                    MOV RAX,const_3
                             
push rax

                    mov rax, 1
                    push rax                                           
                    
                   	test_malloc 16
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_35:
                        cmp rdi, 1
                        je loop_exit_35 
                        mov r10, [rax + rdi*8]              ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10        ;;  env'[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_35
                        loop_exit_35:
                        mov r8, [rbp+8*3] ;n
                        add r8,1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_36:
                        cmp rdi , r8
                        je loop_exit_36
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
                        ;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_36
                        loop_exit_36:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_49
                    jmp lambda_body_end_49
                    lambda_body_start_49:
                    push rbp
                    mov rbp, rsp
                    
                mov rax, [rbp + (4+0) * 8]
                mov rbx,rax
               	test_malloc 8
                mov qword[rax],rbx
                
                         mov qword[rbp + (4+0)*8],rax
                         mov rax, const_1
                        
                
                   	test_malloc 24
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_38:
                        cmp rdi, 2
                        je loop_exit_38 
                        mov r10, [rax + rdi*8]              ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10        ;;  env'[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_38
                        loop_exit_38:
                        mov r8, [rbp+8*3] ;n
                        add r8,1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_39:
                        cmp rdi , r8
                        je loop_exit_39
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
                        ;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_39
                        loop_exit_39:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_50
                    jmp lambda_body_end_50
                    lambda_body_start_50:
                    push rbp
                    mov rbp, rsp
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+2) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_7
                            
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_16]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_27]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_24]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_8
                            
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_16]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_25]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 1
                    push rax                                           
                    mov rax,qword[Lglob_24]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_40:
                                    cmp rdi, 5
                                    je loop_exit_40
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_40
                                    loop_exit_40:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            jmp if_exit_8
                            if_else_8:
                            MOV RAX,const_3
                             
                            if_exit_8:
                            jmp if_exit_7
                            if_else_7:
                            
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_16]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_27]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_24]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_9
                            
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_16]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_25]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_24]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_10
                            
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+2) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_7]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+2) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_8]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax
mov rax, [rbp + (4+1) * 8]
push rax

                    mov rax, 3
                    push rax                                           
                    
                mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
                mov rax,qword[rax]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_41:
                                    cmp rdi, 7
                                    je loop_exit_41
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_41
                                    loop_exit_41:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            jmp if_exit_10
                            if_else_10:
                            MOV RAX,const_3
                             
                            if_exit_10:
                            jmp if_exit_9
                            if_else_9:
                            MOV RAX,const_3
                             
                            if_exit_9:
                            if_exit_7:
                    CLEAN_STACK
                    ret
                    lambda_body_end_50:
                    
                mov rbx,rax
                mov rax, [rbp + (4+0) * 8]
                mov qword[rax],rbx
                mov rax,const_1
                
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 1*8]
                            
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_7]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, const_2
                    push rax
                    mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 1*8]
                            
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_8]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax
mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
push rax

                    mov rax, 3
                    push rax                                           
                    
                mov rax, [rbp + (4+0) * 8]
                mov rax,qword[rax]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_37:
                                    cmp rdi, 7
                                    je loop_exit_37
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_37
                                    loop_exit_37:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                    CLEAN_STACK
                    ret
                    lambda_body_end_49:
                                         
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_34:
                                    cmp rdi, 5
                                    je loop_exit_34
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_34
                                    loop_exit_34:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            if_exit_6:
                    CLEAN_STACK
                    ret
                    lambda_body_end_48:
                    
                         mov qword[Lglob_26], rax
                         mov rax, const_1
                        
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                   	test_malloc 8
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_43:
                        cmp rdi, 0
                        je loop_exit_43 
                        mov r10, [rax + rdi*8]            ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10       ;;  env[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_43
                        loop_exit_43:
                        mov r8, [rbp+8*3] ;n
                        add r8, 1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_44:
                        cmp rdi , r8
                        je loop_exit_44
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
              			;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_44
                        loop_exit_44:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_51
                    jmp lambda_body_end_51
                    lambda_body_start_51:
                    push rbp
                    mov rbp, rsp
                    mov r8, [rbp+3*8] ;n
                    sub r8, 0
                    mov rdi, 8* 0
                    add rdi, 3*8
                    mov rsi, r8
                    mov rax, const_2
                    loop_enter_42:
                    cmp rsi, 0
                    je loop_exit_42
                    push rax
                    mov rax, rsi
                    shl rax,3
                    mov r10, rdi
                    add r10,rax
                    mov rax, qword[rbp + r10]
                    push rax
                    mov rax, [Lglob_10]
                    CALL_LIB_FUN rax, 1                    
                    dec rsi
                    jmp loop_enter_42
                    loop_exit_42:
                    mov [rbp + 32], rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_11
                            MOV RAX,const_5
                             
                            jmp if_exit_11
                            if_else_11:
                            
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_7]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax
mov rax,qword[Lglob_23]
                
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_11]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_8]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_22]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_45:
                                    cmp rdi, 6
                                    je loop_exit_45
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_45
                                    loop_exit_45:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            if_exit_11:
                    CLEAN_STACK
                    ret
                    lambda_body_end_51:
                    
                         mov qword[Lglob_23], rax
                         mov rax, const_1
                        
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                   	test_malloc 8
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_47:
                        cmp rdi, 0
                        je loop_exit_47 
                        mov r10, [rax + rdi*8]            ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10       ;;  env[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_47
                        loop_exit_47:
                        mov r8, [rbp+8*3] ;n
                        add r8, 1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_48:
                        cmp rdi , r8
                        je loop_exit_48
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
              			;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_48
                        loop_exit_48:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_52
                    jmp lambda_body_end_52
                    lambda_body_start_52:
                    push rbp
                    mov rbp, rsp
                    mov r8, [rbp+3*8] ;n
                    sub r8, 1
                    mov rdi, 8* 1
                    add rdi, 3*8
                    mov rsi, r8
                    mov rax, const_2
                    loop_enter_46:
                    cmp rsi, 0
                    je loop_exit_46
                    push rax
                    mov rax, rsi
                    shl rax,3
                    mov r10, rdi
                    add r10,rax
                    mov rax, qword[rbp + r10]
                    push rax
                    mov rax, [Lglob_10]
                    CALL_LIB_FUN rax, 1                    
                    dec rsi
                    jmp loop_enter_46
                    loop_exit_46:
                    mov [rbp + 40], rax
                    
                    mov rax, const_2
                    push rax           
                    MOV RAX,const_3
                             
push rax

                    mov rax, 1
                    push rax                                           
                    
                   	test_malloc 16
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_50:
                        cmp rdi, 1
                        je loop_exit_50 
                        mov r10, [rax + rdi*8]              ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10        ;;  env'[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_50
                        loop_exit_50:
                        mov r8, [rbp+8*3] ;n
                        add r8,1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_51:
                        cmp rdi , r8
                        je loop_exit_51
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
                        ;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_51
                        loop_exit_51:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_53
                    jmp lambda_body_end_53
                    lambda_body_start_53:
                    push rbp
                    mov rbp, rsp
                    
                mov rax, [rbp + (4+0) * 8]
                mov rbx,rax
               	test_malloc 8
                mov qword[rax],rbx
                
                         mov qword[rbp + (4+0)*8],rax
                         mov rax, const_1
                        
                
                   	test_malloc 24
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_55:
                        cmp rdi, 2
                        je loop_exit_55 
                        mov r10, [rax + rdi*8]            ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10       ;;  env[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_55
                        loop_exit_55:
                        mov r8, [rbp+8*3] ;n
                        add r8, 1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_56:
                        cmp rdi , r8
                        je loop_exit_56
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
              			;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_56
                        loop_exit_56:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_54
                    jmp lambda_body_end_54
                    lambda_body_start_54:
                    push rbp
                    mov rbp, rsp
                    mov r8, [rbp+3*8] ;n
                    sub r8, 2
                    mov rdi, 8* 2
                    add rdi, 3*8
                    mov rsi, r8
                    mov rax, const_2
                    loop_enter_54:
                    cmp rsi, 0
                    je loop_exit_54
                    push rax
                    mov rax, rsi
                    shl rax,3
                    mov r10, rdi
                    add r10,rax
                    mov rax, qword[rbp + r10]
                    push rax
                    mov rax, [Lglob_10]
                    CALL_LIB_FUN rax, 1                    
                    dec rsi
                    jmp loop_enter_54
                    loop_exit_54:
                    mov [rbp + 48], rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+2) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_13
                            
                    mov rax, const_2
                    push rax           
                    mov rax, [rbp + (4+1) * 8]
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_21]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_57:
                                    cmp rdi, 6
                                    je loop_exit_57
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_57
                                    loop_exit_57:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            jmp if_exit_13
                            if_else_13:
                            
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+2) * 8]
push rax

                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_21]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_10]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
                mov rax,qword[rax]
                
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_11]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_58:
                                    cmp rdi, 6
                                    je loop_exit_58
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_58
                                    loop_exit_58:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            if_exit_13:
                    CLEAN_STACK
                    ret
                    lambda_body_end_54:
                    
                mov rbx,rax
                mov rax, [rbp + (4+0) * 8]
                mov qword[rax],rbx
                mov rax,const_1
                
                    mov rax, const_2
                    push rax
                    mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 1*8]
                            
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_12
                            
                    mov rax, const_2
                    push rax           
                    mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
push rax
MOV RAX,const_5
                             
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_21]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_52:
                                    cmp rdi, 6
                                    je loop_exit_52
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_52
                                    loop_exit_52:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            jmp if_exit_12
                            if_else_12:
                            
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 1*8]
                            
push rax
mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_10]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                mov rax, [rbp + (4+0) * 8]
                mov rax,qword[rax]
                
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_11]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_53:
                                    cmp rdi, 6
                                    je loop_exit_53
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_53
                                    loop_exit_53:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            if_exit_12:
                    CLEAN_STACK
                    ret
                    lambda_body_end_53:
                                         
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_49:
                                    cmp rdi, 5
                                    je loop_exit_49
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_49
                                    loop_exit_49:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                    CLEAN_STACK
                    ret
                    lambda_body_end_52:
                    
                         mov qword[Lglob_20], rax
                         mov rax, const_1
                        
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                   	test_malloc 8
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_60:
                        cmp rdi, 0
                        je loop_exit_60 
                        mov r10, [rax + rdi*8]            ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10       ;;  env[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_60
                        loop_exit_60:
                        mov r8, [rbp+8*3] ;n
                        add r8, 1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_61:
                        cmp rdi , r8
                        je loop_exit_61
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
              			;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_61
                        loop_exit_61:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_55
                    jmp lambda_body_end_55
                    lambda_body_start_55:
                    push rbp
                    mov rbp, rsp
                    mov r8, [rbp+3*8] ;n
                    sub r8, 0
                    mov rdi, 8* 0
                    add rdi, 3*8
                    mov rsi, r8
                    mov rax, const_2
                    loop_enter_59:
                    cmp rsi, 0
                    je loop_exit_59
                    push rax
                    mov rax, rsi
                    shl rax,3
                    mov r10, rdi
                    add r10,rax
                    mov rax, qword[rbp + r10]
                    push rax
                    mov rax, [Lglob_10]
                    CALL_LIB_FUN rax, 1                    
                    dec rsi
                    jmp loop_enter_59
                    loop_exit_59:
                    mov [rbp + 32], rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_14
                            MOV RAX,const_7
                             
                            jmp if_exit_14
                            if_else_14:
                            
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_7]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax
mov rax,qword[Lglob_19]
                
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_11]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_8]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_18]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_62:
                                    cmp rdi, 6
                                    je loop_exit_62
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_62
                                    loop_exit_62:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            if_exit_14:
                    CLEAN_STACK
                    ret
                    lambda_body_end_55:
                    
                         mov qword[Lglob_19], rax
                         mov rax, const_1
                        
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                   	test_malloc 8
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_64:
                        cmp rdi, 0
                        je loop_exit_64 
                        mov r10, [rax + rdi*8]            ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10       ;;  env[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_64
                        loop_exit_64:
                        mov r8, [rbp+8*3] ;n
                        add r8, 1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_65:
                        cmp rdi , r8
                        je loop_exit_65
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
              			;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_65
                        loop_exit_65:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_56
                    jmp lambda_body_end_56
                    lambda_body_start_56:
                    push rbp
                    mov rbp, rsp
                    mov r8, [rbp+3*8] ;n
                    sub r8, 1
                    mov rdi, 8* 1
                    add rdi, 3*8
                    mov rsi, r8
                    mov rax, const_2
                    loop_enter_63:
                    cmp rsi, 0
                    je loop_exit_63
                    push rax
                    mov rax, rsi
                    shl rax,3
                    mov r10, rdi
                    add r10,rax
                    mov rax, qword[rbp + r10]
                    push rax
                    mov rax, [Lglob_10]
                    CALL_LIB_FUN rax, 1                    
                    dec rsi
                    jmp loop_enter_63
                    loop_exit_63:
                    mov [rbp + 40], rax
                    
                    mov rax, const_2
                    push rax           
                    MOV RAX,const_3
                             
push rax

                    mov rax, 1
                    push rax                                           
                    
                   	test_malloc 16
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_67:
                        cmp rdi, 1
                        je loop_exit_67 
                        mov r10, [rax + rdi*8]              ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10        ;;  env'[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_67
                        loop_exit_67:
                        mov r8, [rbp+8*3] ;n
                        add r8,1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_68:
                        cmp rdi , r8
                        je loop_exit_68
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
                        ;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_68
                        loop_exit_68:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_57
                    jmp lambda_body_end_57
                    lambda_body_start_57:
                    push rbp
                    mov rbp, rsp
                    
                mov rax, [rbp + (4+0) * 8]
                mov rbx,rax
               	test_malloc 8
                mov qword[rax],rbx
                
                         mov qword[rbp + (4+0)*8],rax
                         mov rax, const_1
                        
                
                   	test_malloc 24
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_72:
                        cmp rdi, 2
                        je loop_exit_72 
                        mov r10, [rax + rdi*8]            ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10       ;;  env[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_72
                        loop_exit_72:
                        mov r8, [rbp+8*3] ;n
                        add r8, 1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_73:
                        cmp rdi , r8
                        je loop_exit_73
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
              			;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_73
                        loop_exit_73:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_58
                    jmp lambda_body_end_58
                    lambda_body_start_58:
                    push rbp
                    mov rbp, rsp
                    mov r8, [rbp+3*8] ;n
                    sub r8, 2
                    mov rdi, 8* 2
                    add rdi, 3*8
                    mov rsi, r8
                    mov rax, const_2
                    loop_enter_71:
                    cmp rsi, 0
                    je loop_exit_71
                    push rax
                    mov rax, rsi
                    shl rax,3
                    mov r10, rdi
                    add r10,rax
                    mov rax, qword[rbp + r10]
                    push rax
                    mov rax, [Lglob_10]
                    CALL_LIB_FUN rax, 1                    
                    dec rsi
                    jmp loop_enter_71
                    loop_exit_71:
                    mov [rbp + 48], rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+2) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_16
                            
                    mov rax, const_2
                    push rax           
                    mov rax, [rbp + (4+1) * 8]
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_17]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_74:
                                    cmp rdi, 6
                                    je loop_exit_74
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_74
                                    loop_exit_74:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            jmp if_exit_16
                            if_else_16:
                            
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+2) * 8]
push rax

                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_17]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_10]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
                mov rax,qword[rax]
                
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_11]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_75:
                                    cmp rdi, 6
                                    je loop_exit_75
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_75
                                    loop_exit_75:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            if_exit_16:
                    CLEAN_STACK
                    ret
                    lambda_body_end_58:
                    
                mov rbx,rax
                mov rax, [rbp + (4+0) * 8]
                mov qword[rax],rbx
                mov rax,const_1
                
                    mov rax, const_2
                    push rax
                    mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 1*8]
                            
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_15
                            
                    mov rax, const_2
                    push rax           
                    mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
push rax
MOV RAX,const_7
                             
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_17]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_69:
                                    cmp rdi, 6
                                    je loop_exit_69
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_69
                                    loop_exit_69:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            jmp if_exit_15
                            if_else_15:
                            
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 1*8]
                            
push rax
mov rax,qword[rbp + 2*8]
                             mov rax,qword[rax + 0*8]
                             mov rax,qword[rax+ 0*8]
                            
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_10]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                mov rax, [rbp + (4+0) * 8]
                mov rax,qword[rax]
                
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_11]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_70:
                                    cmp rdi, 6
                                    je loop_exit_70
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_70
                                    loop_exit_70:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            if_exit_15:
                    CLEAN_STACK
                    ret
                    lambda_body_end_57:
                                         
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_66:
                                    cmp rdi, 5
                                    je loop_exit_66
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_66
                                    loop_exit_66:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                    CLEAN_STACK
                    ret
                    lambda_body_end_56:
                    
                         mov qword[Lglob_16], rax
                         mov rax, const_1
                        
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                   	test_malloc 8
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_77:
                        cmp rdi, 0
                        je loop_exit_77 
                        mov r10, [rax + rdi*8]            ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10       ;;  env[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_77
                        loop_exit_77:
                        mov r8, [rbp+8*3] ;n
                        add r8, 1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_78:
                        cmp rdi , r8
                        je loop_exit_78
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
              			;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_78
                        loop_exit_78:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_59
                    jmp lambda_body_end_59
                    lambda_body_start_59:
                    push rbp
                    mov rbp, rsp
                    mov r8, [rbp+3*8] ;n
                    sub r8, 1
                    mov rdi, 8* 1
                    add rdi, 3*8
                    mov rsi, r8
                    mov rax, const_2
                    loop_enter_76:
                    cmp rsi, 0
                    je loop_exit_76
                    push rax
                    mov rax, rsi
                    shl rax,3
                    mov r10, rdi
                    add r10,rax
                    mov rax, qword[rbp + r10]
                    push rax
                    mov rax, [Lglob_10]
                    CALL_LIB_FUN rax, 1                    
                    dec rsi
                    jmp loop_enter_76
                    loop_exit_76:
                    mov [rbp + 40], rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_17
                            MOV RAX,const_4
                             
                            jmp if_exit_17
                            if_else_17:
                            
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_8]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_14]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_18
                            
                    mov rax, const_2
                    push rax           
                    mov rax, [rbp + (4+1) * 8]
push rax
mov rax,qword[Lglob_15]
                
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_11]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_79:
                                    cmp rdi, 6
                                    je loop_exit_79
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_79
                                    loop_exit_79:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            jmp if_exit_18
                            if_else_18:
                            MOV RAX,const_3
                             
                            if_exit_18:
                            if_exit_17:
                    CLEAN_STACK
                    ret
                    lambda_body_end_59:
                    
                         mov qword[Lglob_15], rax
                         mov rax, const_1
                        
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                   	test_malloc 8
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_81:
                        cmp rdi, 0
                        je loop_exit_81 
                        mov r10, [rax + rdi*8]            ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10       ;;  env[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_81
                        loop_exit_81:
                        mov r8, [rbp+8*3] ;n
                        add r8, 1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_82:
                        cmp rdi , r8
                        je loop_exit_82
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
              			;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_82
                        loop_exit_82:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_60
                    jmp lambda_body_end_60
                    lambda_body_start_60:
                    push rbp
                    mov rbp, rsp
                    mov r8, [rbp+3*8] ;n
                    sub r8, 1
                    mov rdi, 8* 1
                    add rdi, 3*8
                    mov rsi, r8
                    mov rax, const_2
                    loop_enter_80:
                    cmp rsi, 0
                    je loop_exit_80
                    push rax
                    mov rax, rsi
                    shl rax,3
                    mov r10, rdi
                    add r10,rax
                    mov rax, qword[rbp + r10]
                    push rax
                    mov rax, [Lglob_10]
                    CALL_LIB_FUN rax, 1                    
                    dec rsi
                    jmp loop_enter_80
                    loop_exit_80:
                    mov [rbp + 40], rax
                    
                    mov rax, const_2
                    push rax           
                    mov rax, [rbp + (4+1) * 8]
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_9]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_83:
                                    cmp rdi, 6
                                    je loop_exit_83
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_83
                                    loop_exit_83:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                    CLEAN_STACK
                    ret
                    lambda_body_end_60:
                    
                         mov qword[Lglob_12], rax
                         mov rax, const_1
                        
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                   	test_malloc 8
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_84:
                        cmp rdi, 0
                        je loop_exit_84 
                        mov r10, [rax + rdi*8]              ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10        ;;  env'[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_84
                        loop_exit_84:
                        mov r8, [rbp+8*3] ;n
                        add r8,1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_85:
                        cmp rdi , r8
                        je loop_exit_85
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
                        ;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_85
                        loop_exit_85:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_61
                    jmp lambda_body_end_61
                    lambda_body_start_61:
                    push rbp
                    mov rbp, rsp
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_19
                            mov rax, [rbp + (4+1) * 8]
                            jmp if_exit_19
                            if_else_19:
                            
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_7]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_6]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_8]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 1
                    push rax
                    mov rax, [rbp + (4+0) * 8]
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_10]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_86:
                                    cmp rdi, 6
                                    je loop_exit_86
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_86
                                    loop_exit_86:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            if_exit_19:
                    CLEAN_STACK
                    ret
                    lambda_body_end_61:
                    
                         mov qword[Lglob_6], rax
                         mov rax, const_1
                        
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                   	test_malloc 8
                    mov rbx, rax
                    
                        mov rax, [rbp + 8*2] ;env
                        mov rdi, 0
                        loop_enter_87:
                        cmp rdi, 0
                        je loop_exit_87 
                        mov r10, [rax + rdi*8]              ;; for(i=0;i<m;i++)
                        mov [rbx + rdi*8 + 1*8], r10        ;;  env'[i+1] = env[i]    
                        inc rdi
                        jmp loop_enter_87
                        loop_exit_87:
                        mov r8, [rbp+8*3] ;n
                        add r8,1
                        mov r9, r8
                        shl r9, 3
                        test_malloc r9
                        mov rcx , rax
                        mov rdi, 0
                        loop_enter_88:
                        cmp rdi , r8
                        je loop_exit_88
                        mov r9, [rbp + (4+rdi) * 8]
                        mov [rcx + rdi*8], r9 
                        ;; for (i=0; i<n ; i++) rcx[i] = param[i], sub 3*8 to get param and rdi(i) * 8 for param i
                        inc rdi
                        jmp loop_enter_88
                        loop_exit_88:
                        mov [rbx], rcx
                        
                    test_malloc 16
                    MAKE_LITERAL_CLOSURE rax, rbx, lambda_body_start_62
                    jmp lambda_body_end_62
                    lambda_body_start_62:
                    push rbp
                    mov rbp, rsp
                    
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_8]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_13]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            mov rax, [rax]
                            CMP RAX,QWORD[const_3]
                            JE if_else_20
                            MOV RAX,const_2
                             
                            jmp if_exit_20
                            if_else_20:
                            
                    mov rax, const_2
                    push rax           
                    
                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax
mov rax,qword[Lglob_7]
                
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_6]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_9]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, const_2
                    push rax
                    
                    mov rax, const_2
                    push rax
                    mov rax, [rbp + (4+1) * 8]
push rax
mov rax,qword[Lglob_8]
                
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_6]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax
mov rax, [rbp + (4+0) * 8]
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_11]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
push rax

                    mov rax, 2
                    push rax                                           
                    mov rax,qword[Lglob_10]
                                     
                                    mov rax,[rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
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
                                    loop_enter_89:
                                    cmp rdi, 6
                                    je loop_exit_89
                                    sub r8, 8
                                    sub r10,8             
                                    mov r9, [r8]
                                    mov [r10], r9
                                    inc rdi
                                    jmp loop_enter_89
                                    loop_exit_89:                                    
                                    add r12, 4+1
                                    shl r12, 3 ;(4+n)*8
                                    add rsp, r12                       
                                    CLOSURE_CODE rax
                                    jmp rax
                                    
                            if_exit_20:
                    CLEAN_STACK
                    ret
                    lambda_body_end_62:
                    
                         mov qword[Lglob_9], rax
                         mov rax, const_1
                        
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            MOV RAX,const_9
                             
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                    mov rax, const_2
                    push rax
                    MOV RAX,const_10
                             
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_3]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            MOV RAX,const_25
                             
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                    mov rax, const_2
                    push rax
                    MOV RAX,const_27
                             
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_4]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            MOV RAX,const_29
                             
                         mov qword[Lglob_5], rax
                         mov rax, const_1
                        
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                    mov rax, const_2
                    push rax
                    mov rax,qword[Lglob_5]
                
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_4]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                    mov rax, const_2
                    push rax
                    MOV RAX,const_31
                             
push rax
MOV RAX,const_30
                             
push rax

                    mov rax, 2
                    push rax
                    mov rax,qword[Lglob_2]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                         mov qword[Lglob_1], rax
                         mov rax, const_1
                        
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                            
                    mov rax, const_2
                    push rax
                    mov rax,qword[Lglob_1]
                
push rax

                    mov rax, 1
                    push rax
                    mov rax,qword[Lglob_3]
                
                                    mov rax, [rax]
                                    mov rbx, rax
                                    TYPE rax
                                    cmp rax, T_CLOSURE
                                    JNE ERROR_NOT_CLOSURE
                                    mov rax, rbx
                                    CLOSURE_ENV rbx
                                    push rbx
                                    CLOSURE_CODE rax
                                    call rax
                                    
                            push RAX
                            call write_sob_if_not_void
                            add RSP,8
                jmp END
                ERROR_NOT_CHAR:
                   add rsp, 8 ;clean return addr
                   jmp END
                ERROR_NOT_CLOSURE:
                   add rsp, 8 ;clean return 
                   jmp END
                ERROR_NOT_PAIR:
                   add rsp, 8 ;clean return addr
                   jmp END
                ERROR_NOT_NUMBER:
                   add rsp, 8 ;clean return addr
                   jmp END
                ERROR:
                   push const_6
                   call write_sob_if_not_void
                   add rsp, 16 ;clean error msg + return addr
                   jmp END
                END:
                add rsp, 5*8
          	    ret
