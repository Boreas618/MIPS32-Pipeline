#include "config.h"

.text
.global _start

_start:
    lui $6, 1
    ori $6, $6, 0x2345

    srl $6, $6, 2

    li $7, 0x48D1

    li $2, MAGIC
    beq $6, $7, exit

    li $2, -1
    j exit

.org 0x8080
exit:
    nop
    nop