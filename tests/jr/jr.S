.text
.global _start

_start:
    li $4, 4
    li $5, 5
    lui $t0, %hi(target)
    ori $t0, $t0, %lo(target)
    jr $t0
    addiu $5, $5, 2

.org 0x4040
wrong_answer:
    nop
    nop

.org 0x8080
correct_result:
    nop
    nop

.org 0x20800
target:
    addiu $5, $5, 1
    addiu $5, $5, 1
    addiu $5, $5, 1
    addu $5, $5, $4

    li $6, 12
    beq $5, $6, correct_result
    j wrong_answer
