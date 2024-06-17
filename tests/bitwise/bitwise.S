.data

.text
.globl main

main:
    # Load initial values into registers
    li $t0, 0x55        # $t0 = 0x55 (0101 0101)
    li $t1, 0xAA        # $t1 = 0xAA (1010 1010)

    # Bitwise AND operation
    and $t2, $t0, $t1   # $t2 = $t0 & $t1 (0000 0000)
    li $t3, 0x00
    bne $t2, $t3, wrong_answer  # Branch to wrong_answer if $t2 != 0x00

    # Bitwise OR operation
    or $t4, $t0, $t1    # $t4 = $t0 | $t1 (1111 1111)
    li $t3, 0xFF
    bne $t4, $t3, wrong_answer  # Branch to wrong_answer if $t4 != 0xFF

    # Bitwise XOR operation
    xor $t5, $t0, $t1   # $t5 = $t0 ^ $t1 (1111 1111)
    li $t3, 0xFF
    bne $t5, $t3, wrong_answer  # Branch to wrong_answer if $t5 != 0xFF

    # Bitwise NOT operation
    nor $t6, $t0, $zero # $t6 = ~ $t0 (1010 1010)
    li $t3, 0xFFFFFFAA
    bne $t6, $t3, wrong_answer  # Branch to wrong_answer if $t6 != 0xFFFFFFAA

    # Bitwise shift left operation
    sll $t7, $t0, 2     # $t7 = $t0 << 2 (0101 0101 << 2 = 0101 0100)
    li $t3, 0x154
    bne $t7, $t3, wrong_answer  # Branch to wrong_answer if $t7 != 0x154

    # Bitwise shift right operation
    srl $t8, $t0, 2     # $t8 = $t0 >> 2 (0101 0101 >> 2 = 0001 0101)
    li $t3, 0x15
    bne $t8, $t3, wrong_answer  # Branch to wrong_answer if $t8 != 0x15

    # If all checks pass, branch to correct_result
    j correct_result

.org 0x4040
wrong_answer:
    nop
    nop

.org 0x8080
correct_result:
    nop
    nop