%:

	echo '(load "compiler.scm") (compile-scheme-file "$(MAKECMDGOALS).scm" "$(MAKECMDGOALS).s")' | scheme -q
	nasm -f elf64 $(MAKECMDGOALS).s -o $(MAKECMDGOALS).o
	gcc -Wall -o $(MAKECMDGOALS) $(MAKECMDGOALS).o

.PHONY: clean

clean: 
	rm -rf *.o $