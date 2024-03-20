#include <cpu.h>

static bool check_registers(void)
{
	if (cpu.pc == 32 && cpu.regs[0] == 1 && cpu.regs[1] == 2 & cpu.regs[2] == 3)
		return true;
	return false;
}

void fdb_start(void)
{
	printf("FDU debugger start...\n");
	char op;

	while (!cpu.halt) {
		printf("(fdb) ");
		scanf(" %c", &op);

		switch (op) {
		case 'n':
			cpu_exec_once();
			printf("0x%lu: 0x%lu\n", cpu.last_pc, cpu.last_inst);
			break;
		case 'r':
			while (!cpu.halt && !cpu.err)
				cpu_exec_once();
			break;
		default:
			printf("Unkown opcode.\n");
		}

		if (cpu.err) {
			printf("Error happened.\n");
			return;
		}
	}

	if (cpu.err) {
		printf("Error happend.\n");
		return;
	}

	if (check_registers())
		printf("Accepted.\n");
	else
	 	printf("Wrong Answer.\n");
}