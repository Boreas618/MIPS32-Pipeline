
sw.elf:     file format elf32-tradlittlemips


Disassembly of section .text:

00001000 <_ftext>:
    1000:	ac072000 	sw	a3,8192(zero)
    1004:	8c062000 	lw	a2,8192(zero)
    1008:	8c052000 	lw	a1,8192(zero)
    100c:	ac082000 	sw	t0,8192(zero)
    1010:	8c052000 	lw	a1,8192(zero)
	...

Disassembly of section .MIPS.abiflags:

004000b8 <.MIPS.abiflags>:
  4000b8:	02200000 	0x2200000
  4000bc:	05000101 	bltz	t0,4004c4 <_gp+0x3e74b4>
  4000c0:	00000000 	nop
	...

Disassembly of section .reginfo:

004000d0 <_gp+0x3e70c0>:
  4000d0:	000001e0 	0x1e0
	...
  4000e4:	00019010 	0x19010

Disassembly of section .gnu.attributes:

00000000 <.gnu.attributes>:
   0:	00000f41 	0xf41
   4:	756e6700 	jalx	5b99c00 <_gp+0x5b80bf0>
   8:	00070100 	sll	zero,a3,0x4
   c:	05040000 	0x5040000
