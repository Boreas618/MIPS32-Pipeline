/* Memory management */

#include <utils.h>

#include <stdint.h>
#include <string.h>
#include <stdio.h>

#define MEM_SIZE 1024
#define GUEST_BASE 0x1000

uint64_t mem[MEM_SIZE];

void mm_init(const char *img_name)
{
	FILE *fp;

	memset(mem, 0, sizeof(mem));

	if (img_name != NULL) {
		fp = fopen(img_name, "rb");
		if (fp == NULL)
			perror_exit("%s not found.\n", img_name);

		// You should make it more robust.
		fread(mem, sizeof(mem), 1, fp);
		fclose(fp);
	}
}

static inline uint64_t guest_to_host(uint64_t addr)
{
	return (uint64_t)mem + addr - GUEST_BASE;
}

extern "C" void mm_read(long long addr, long long *data)
{
	uint64_t host_addr = guest_to_host(addr);
	*data = *(long long *)host_addr;
}
