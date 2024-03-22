#ifndef __UTILS_H__
#define __UTILS_H__

#include <stdint.h>

#define perror(...) do { \
	fprintf(stderr, __VA_ARGS__); \
	exit(1); \
} while(0)

extern void disasm_init(const char *triple);
extern void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);

#endif // __UTILS_H__