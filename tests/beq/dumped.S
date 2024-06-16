
beq.elf:     file format elf32-tradlittlemips


Disassembly of section .text:

00001000 <_ftext>:
    1000:	24010003 	li	at,3
    1004:	10610003 	beq	v1,at,1014 <_ftext+0x14>
    1008:	00000000 	nop
    100c:	24840001 	addiu	a0,a0,1
    1010:	24a50002 	addiu	a1,a1,2
    1014:	24c60003 	addiu	a2,a2,3
    1018:	24e70004 	addiu	a3,a3,4
    101c:	25080005 	addiu	t0,t0,5

Disassembly of section .MIPS.abiflags:

004000b8 <.MIPS.abiflags>:
  4000b8:	02200000 	0x2200000
  4000bc:	05000101 	bltz	t0,4004c4 <_gp+0x3e74b4>
  4000c0:	00000000 	nop
	...

Disassembly of section .reginfo:

004000d0 <_gp+0x3e70c0>:
  4000d0:	000001fa 	0x1fa
	...
  4000e4:	00019010 	0x19010

Disassembly of section .gnu.attributes:

00000000 <.gnu.attributes>:
   0:	00000f41 	0xf41
   4:	756e6700 	jalx	5b99c00 <_gp+0x5b80bf0>
   8:	00070100 	sll	zero,a3,0x4
   c:	05040000 	0x5040000
