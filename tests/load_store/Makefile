hello.bin:
	mips-linux-gnu-gcc -O0 -c -EL -nostdlib load_store.S
	/usr/mips-linux-gnu/bin/ld -EL load_store.o -static -Ttext=0x1000 -o load_store.elf
	/usr/bin/mips-linux-gnu-objcopy -O binary load_store.elf load_store.bin

clean:
	rm load_store.o load_store.elf load_store.bin