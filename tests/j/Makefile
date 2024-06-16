hello.bin:
	mips-linux-gnu-gcc -O0 -c -EL -nostdlib j.S
	/usr/mips-linux-gnu/bin/ld -EL j.o -static -Ttext=0x1000 -o j.elf
	/usr/bin/mips-linux-gnu-objcopy -O binary j.elf j.bin

clean:
	rm j.o j.elf j.bin