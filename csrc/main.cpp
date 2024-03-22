#include <fdb.h>
#include <cpu.h>
#include <mm.h>

#include <stdio.h>

static char logo[] =
	"  _____ ____                    \n"
	" |  ___|  _ \\  ___ _ __  _   _  \n"
	" | |_  | | | |/ __| '_ \\| | | | \n"
	" |  _| | |_| | (__| |_) | |_| | \n"
	" |_|   |____/ \\___| .__/ \\__,_| \n"
	"                  |_|           ";

static void system_init(int argc, char *argv[])
{
	mm_init();
	cpu_init(argc, argv);
	fdb_init();

	printf("%s\n", logo);
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
