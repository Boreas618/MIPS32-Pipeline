`ifndef __ICODE_SVH__
`define __ICODE_SVH__

`define RTYPE 6'b000000
`define ADD 6'b100000
`define ADDU 6'b100001
`define SUBU 6'b100011
`define AND 6'b100100
`define OR 6'b100101
`define NOR 6'b100111
`define XOR 6'b100110
`define SLL 6'b000000
`define SRA 6'b000011
`define SRL 6'b000010
`define SLT 6'b101010
`define SLTU 6'b101011
`define JR 6'b001000

`define ADDIU 6'b001001
`define ANDI 6'b001100
`define ORI 6'b001101
`define XORI 6'b001110
`define SLTI 6'b001010
`define SLTIU 6'b001011
`define LUI 6'b001111
`define BEQ 6'b000100
`define BNE 6'b000101
`define LW 6'b100011
`define SW 6'b101011

`define J 6'b000010
`define JAL 6'b000011

`endif
