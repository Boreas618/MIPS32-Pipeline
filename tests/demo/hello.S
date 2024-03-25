.data
.global s
s:
.string "Hello, world!\n"

.text
.global _start
_start:
	movq s(%rip), %rax
	ret