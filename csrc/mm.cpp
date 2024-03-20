#include <stdint.h>
#include <string.h>

#define MEM_SIZE 1024
#define GUEST_BASE 0

uint64_t mem[MEM_SIZE];

void mm_init(void)
{
	memset(mem, 0, sizeof(mem));

	mem[0] = 0x1;
	mem[1] = 0x2;
	mem[2] = 0x3;
	mem[3] = 0x0;
}

static inline uint64_t guest_to_host(uint64_t addr)
{
	return (uint64_t)((void *)mem + addr - GUEST_BASE);	
}

extern "C" void mm_read(long long addr, long long *data)
{
	uint64_t host_addr = guest_to_host(addr);
	*data = *(long long *)host_addr;
}
