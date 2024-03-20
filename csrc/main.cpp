#include <stdio.h>
#include <cpu.h>
#include <mm.h>

char logo[] =
	"  _____ ____                    \n"
	" |  ___|  _ \\  ___ _ __  _   _  \n"
	" | |_  | | | |/ __| '_ \\| | | | \n"
	" |  _| | |_| | (__| |_) | |_| | \n"
	" |_|   |____/ \\___| .__/ \\__,_| \n"
	"                  |_|           ";

extern void fdb_start(void);

static void system_init(int argc, char *argv[])
{
	printf("%s\n", logo);
	mm_init();
	cpu_init(argc, argv);
}

static void system_exit(void)
{
	cpu_final();
}

int main(int argc, char *argv[])
{
	system_init(argc, argv);
	fdb_start();
	system_exit();
}
