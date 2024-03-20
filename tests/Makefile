hello.bin:
	gcc -c -nostdlib hello.S
	ld hello.o -Ttext=0x0 -o hello.elf
	objcopy -O binary hello.elf hello.bin

clean:
	rm hello.o hello.elf hello.bin