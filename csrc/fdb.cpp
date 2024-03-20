#include <cpu.h>
#include <set>

std::set<uint64_t> brks;

static bool check_registers(void)
{
	if (cpu.pc == 40 && cpu.regs[0] == 0 && cpu.regs[1] == 2 & cpu.regs[2] == 3)
		return true;
	return false;
}

static void fdb_run(void)
{
	while (!cpu.halt && !cpu.err) {
		cpu_exec_once();
		if (brks.count(cpu.pc)) {
			printf("Breakpoint hit at 0x%lx.\n", cpu.pc);
			break;
		}
	}
}

static void fdb_print(void)
{
	int i;

	printf("pc = 0x%lx\n", cpu.pc);
	for (i = 0; i < 3; i++)
		printf("regs[%d] = 0x%lx\n", i, cpu.regs[i]);
}

void fdb_start(void)
{
	char op;
	uint64_t addr;

	printf("FDU debugger start...\n");

	while (!cpu.halt) {
		printf("(fdb) ");
		scanf(" %c", &op);

		switch (op) {
		/* next */
		case 'n':
			cpu_exec_once();
			printf("0x%lx: 0x%lx\n", cpu.last_pc, cpu.last_inst);
			break;
		
		/* run */
		case 'r':
			fdb_run();
			break;
		
		/* breakpoint */
		case 'b':
			scanf(" 0x%lx", &addr);
			brks.insert(addr);
			break;
		
		/* print */
		case 'p':
			fdb_print();
			break;
		
		case 'q':
			return;
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
