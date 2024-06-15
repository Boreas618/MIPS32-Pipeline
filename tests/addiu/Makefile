hello.bin:
	mips-linux-gnu-gcc -O0 -c -EL -nostdlib addiu.S
	/usr/mips-linux-gnu/bin/ld -EL addiu.o -static -Ttext=0x1000 -o addiu.elf
	/usr/bin/mips-linux-gnu-objcopy -O binary addiu.elf addiu.bin

clean:
	rm addiu.o addiu.elf addiu.bin