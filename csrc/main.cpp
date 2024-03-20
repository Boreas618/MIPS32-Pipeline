#include <stdio.h>
#include <cpu.h>
#include <mm.h>

extern void fdb_start(void);

static void system_init(int argc, char *argv[])
{
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
