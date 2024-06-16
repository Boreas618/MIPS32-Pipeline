hello.bin:
	mips-linux-gnu-gcc -O0 -c -EL -nostdlib beq.S
	/usr/mips-linux-gnu/bin/ld -EL beq.o -static -Ttext=0x1000 -o beq.elf
	/usr/bin/mips-linux-gnu-objcopy -O binary beq.elf beq.bin

clean:
	rm beq.o beq.elf beq.bin