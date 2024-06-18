#include "config.h"

.text
.global _start

_start:
    li $5, 5
    li $6, 6
    li $7, 7
    li $8, 8

    sw $7, 0x2000($0)
    lw $6, 0x2000($0)
    lw $5, 0x2000($0)
    sw $8, 0x2000($0)
    lw $5, 0x2000($0)

    li $9, 8
    li $2, MAGIC
    beq $5, $9, exit

    li $2, -1
    j exit

.org 0x8080
exit:
    nop
    nop