#include "config.h"

.text
.global _start

_start:
    li $1, 1
    li $3, 3
    li $5, 5
    li $7, 7

    addu $5, $3, $1
    addu $5, $5, $5
    addu $7, $5, $1
    addu $8, $7, $5
    subu $8, $8, $1
    subu $8, $8, $1
    li $9, 15

    li $2, MAGIC
    beq $8, $9, exit

    li $2, -1
    j exit

.org 0x8080
exit:
    nop  # No operation
    nop  # No operation

