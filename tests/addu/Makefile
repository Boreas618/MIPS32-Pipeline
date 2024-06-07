hello.bin:
	mips-linux-gnu-gcc -O0 -c -EL -nostdlib addu.S
	/usr/mips-linux-gnu/bin/ld -EL addu.o -static -Ttext=0x1000 -o addu.elf
	/usr/bin/mips-linux-gnu-objcopy -O binary addu.elf addu.bin

clean:
	rm addu.o addu.elf addu.bin