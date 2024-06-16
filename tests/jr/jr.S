.text
.global _start

_start:
    addiu $4, $4, 1
    lui $t0, %hi(target)
    ori $t0, $t0, %lo(target)
    jr $t0

    addiu $5, $5, 2
    addiu $6, $6, 3

.org 0x200800
target:
    addiu $7, $7, 4
    addiu $8, $8, 5