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
    beq $5, $9, correct_result
    j wrong_answer

.org 0x4040
wrong_answer:
    nop
    nop

.org 0x8080
correct_result:
    nop
    nop