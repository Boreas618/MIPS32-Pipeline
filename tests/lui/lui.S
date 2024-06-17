.text
.global _start

_start:
    lui $6, 1
    ori $6, $6, 0x2345

    srl $6, $6, 2

    li $7, 0x48D1
    beq $6, $7, correct_result
    j wrong_answer

.org 0x4040
wrong_answer:
    nop
    nop

.org 0x8080
correct_result:
    nop
    nop