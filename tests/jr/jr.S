#include "config.h"

.text
.global _start

_start:
    li $4, 4
    li $5, 5
    lui $t0, %hi(target)
    ori $t0, $t0, %lo(target)
    jr $t0
    addiu $5, $5, 2

.org 0x8080
exit:
    nop
    nop

.org 0x20800
target:
    addiu $5, $5, 1
    addiu $5, $5, 1
    addiu $5, $5, 1
    addu $5, $5, $4

    li $6, 12
    li $2, MAGIC
    beq $5, $6, exit

    li $2, -1
    j exit
