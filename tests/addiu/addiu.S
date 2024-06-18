#include "config.h"

.text
.global _start

_start:
    li $3, 3
    li $4, 4
    li $5, 5
    li $6, 6

    addiu $3, $3, 1
    addiu $4, $3, 5
    addiu $4, $4, 1
    addiu $4, $4, 1
    addiu $3, $3, 1
    addu $5, $4, $3
    li $6, 0x10

    li $2, MAGIC
    beq $5, $6, exit
    
    li $2, -1
    j exit

.org 0x8080
exit:
    nop  # No operation
    nop  # No operation