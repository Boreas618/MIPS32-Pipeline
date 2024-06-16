/* Memory management */

#include <utils.h>

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <iostream>

#define MEM_SIZE 8192 * 1024
#define GUEST_BASE 0x1000

uint64_t mem[MEM_SIZE];

void mm_init(const char *img_name)
{
	FILE *fp;

	memset(mem, 0, sizeof(mem));

	if (img_name != NULL)
	{
		fp = fopen(img_name, "rb");
		if (fp == NULL)
			perror_exit("%s not found.\n", img_name);

		// You should make it more robust.
		fread(mem, sizeof(mem), 1, fp);
		fclose(fp);
	}
}

inline uint64_t guest_to_host(uint64_t addr)
{
	return (uint64_t)mem + addr - GUEST_BASE;
}

extern "C" void mm_read(uint64_t addr, uint64_t *data)
{
	uint64_t host_addr = guest_to_host(addr);
	*data = *(uint64_t *)host_addr;
}

extern "C" void mm_write(uint64_t addr, uint32_t data)
{
	uint64_t host_addr = guest_to_host(addr);
	*(uint32_t *)host_addr = data;
}
