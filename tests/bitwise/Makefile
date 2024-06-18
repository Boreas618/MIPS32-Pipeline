hello.bin:
	mips-linux-gnu-gcc -O0 -c -EL -nostdlib -I../ bitwise.S
	/usr/mips-linux-gnu/bin/ld -EL bitwise.o -static -Ttext=0x1000 -o bitwise.elf
	/usr/bin/mips-linux-gnu-objcopy -O binary bitwise.elf bitwise.bin

clean:
	rm bitwise.o bitwise.elf bitwise.bin