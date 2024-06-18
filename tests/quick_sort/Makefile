hello.bin:
	mips-linux-gnu-gcc -O0 -c -EL -nostdlib -I../ quick_sort.c
	/usr/mips-linux-gnu/bin/ld -EL quick_sort.o -static -T linker_script.ld -o quick_sort.elf
	/usr/bin/mips-linux-gnu-objcopy -O binary quick_sort.elf quick_sort.bin

clean:
	rm quick_sort.o quick_sort.elf quick_sort.bin