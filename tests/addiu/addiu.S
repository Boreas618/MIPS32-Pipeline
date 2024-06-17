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
    beq $5, $6, correct_result
    j wrong_answer

.org 0x4040
wrong_answer:
    nop  # No operation
    nop  # No operation

.org 0x8080
correct_result:
    nop  # No operation
    nop  # No operation