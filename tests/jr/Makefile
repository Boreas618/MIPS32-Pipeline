hello.bin:
	mips-linux-gnu-gcc -O0 -c -EL -nostdlib jr.S
	/usr/mips-linux-gnu/bin/ld -EL jr.o -static -Ttext=0x1000 -o jr.elf
	/usr/bin/mips-linux-gnu-objcopy -O binary jr.elf jr.bin

clean:
	rm jr.o jr.elf jr.bin