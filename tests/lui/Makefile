hello.bin:
	mips-linux-gnu-gcc -O0 -c -EL -nostdlib lui.S
	/usr/mips-linux-gnu/bin/ld -EL lui.o -static -Ttext=0x1000 -o lui.elf
	/usr/bin/mips-linux-gnu-objcopy -O binary lui.elf lui.bin

clean:
	rm lui.o lui.elf lui.bin