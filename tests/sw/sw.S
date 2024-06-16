.text
.global _start
_start:
    sw $7, 0x2000($0) 
    lw $6, 0x2000($0)
    lw $5, 0x2000($0)
    sw $8, 0x2000($0)
    lw $5, 0x2000($0)