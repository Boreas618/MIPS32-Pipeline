.text
.global _start

_start:
    addiu $4, $4, 1
    j target
    addiu $5, $5, 2
    addiu $6, $6, 3
target:
    addiu $7, $7, 4
    addiu $8, $8, 5