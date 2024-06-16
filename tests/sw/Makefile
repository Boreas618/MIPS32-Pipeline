hello.bin:
	mips-linux-gnu-gcc -O0 -c -EL -nostdlib sw.S
	/usr/mips-linux-gnu/bin/ld -EL sw.o -static -Ttext=0x1000 -o sw.elf
	/usr/bin/mips-linux-gnu-objcopy -O binary sw.elf sw.bin

clean:
	rm sw.o sw.elf sw.bin