#include <fdb.h>
#include <cpu.h>
#include <mm.h>

#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>

static char logo[] =
	"  _____ ____                    \n"
	" |  ___|  _ \\  ___ _ __  _   _  \n"
	" | |_  | | | |/ __| '_ \\| | | | \n"
	" |  _| | |_| | (__| |_) | |_| | \n"
	" |_|   |____/ \\___| .__/ \\__,_| \n"
	"                  |_|           ";

bool debug = false;
char *img_name;

static void print_help(const char *self)
{
	printf("Usage: %s [OPTIONS] IMAGE\n\n", self);
	printf("\t-d, --debug\t\t\tEnable debug mode\n");
	printf("\n");
	exit(1);
}

static void parse_args(int argc, char *argv[])
{
	struct option options[] = {
		{"debug", no_argument, NULL, 'd'},
		{0, 0, NULL, 0}};

	int opt;

	while ((opt = getopt_long(argc, argv, "-d", options, NULL)) != -1)
	{
		switch (opt)
		{
		case 'd':
			debug = true;
			break;

		case 1:
			img_name = optarg;
			break;

		default:
			print_help(argv[0]);
		}
	}

	if (!img_name)
		print_help(argv[0]);
}

static void system_init(int argc, char *argv[])
{
	parse_args(argc, argv);

	mm_init(img_name);
	cpu_init(argc, argv);
	fdb_init(debug);

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

	return 0;
}
