hello.bin:
	mips-linux-gnu-gcc -O0 -c -EL -nostdlib branch.S
	/usr/mips-linux-gnu/bin/ld -EL branch.o -static -Ttext=0x1000 -o branch.elf
	/usr/bin/mips-linux-gnu-objcopy -O binary branch.elf branch.bin

clean:
	rm branch.o branch.elf branch.bin