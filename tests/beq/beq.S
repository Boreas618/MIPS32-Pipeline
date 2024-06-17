.text
.global _start

_start:
    li $3, 3
    li $4, 4
    li $5, 5
    li $6, 6
    li $7, 7
    li $8, 8

    beq $3, $3, skip
    addiu $4, $4, 1
    addiu $5, $5, 2
    addiu $6, $6, 3
    addiu $7, $7, 4
    addiu $8, $8, 5

skip:
    li $9, 30
    addu $10, $4, $5   # $10 = $4 + $5 (4 + 5 = 9)
    addu $10, $10, $6  # $10 = $10 + $6 (9 + 6 = 15)
    addu $10, $10, $7  # $10 = $10 + $7 (15 + 7 = 22)
    addu $10, $10, $8  # $10 = $10 + $8 (22 + 8 = 30)

    beq $10, $9, correct_result
    j wrong_answer

.org 0x4040
wrong_answer:
    nop
    nop

.org 0x8080
correct_result:
    nop
    nop