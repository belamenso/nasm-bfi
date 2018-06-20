default: build cleanup

build: interpret.o bfi.o
	gcc -m32 interpret.o bfi.o -o bfi

bfi.o: bfi.c
	gcc -c -m32 bfi.c -o bfi.o

interpret.o: interpret.asm
	nasm -f elf interpret.asm -o interpret.o

cleanup: interpret.o bfi.o
	rm interpret.o bfi.o
