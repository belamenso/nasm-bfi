default:
	nasm -f elf interpret.asm -o interpret.o
	gcc -c -m32 bfi.c -o bfi.o
	gcc -m32 interpret.o bfi.o -o bfi
