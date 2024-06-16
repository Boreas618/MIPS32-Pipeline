    .text
    .global _start

_start:
    li $1, 1
    li $3, 3
    li $6, 6
    li $7, 7

    addu $6, $3, $1
    addu $6, $6, $6
    addu $7, $6, $1
    addu $8, $7, $6

    li $9, 17 
    beq $8, $9, correct_result
    j wrong_answer

.org 0x4040
wrong_answer:
    nop
    nop

.org 0x8080
correct_result:
    nop
    nop

