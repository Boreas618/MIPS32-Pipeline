/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNDRIVEN */

`include "Icode.svh"

module Decode(
    input   logic   rst,
    input   logic   clk,
    input   logic   [31:0]inst,
    input   logic   [31:0]pc,
    output  logic   reg_write_d,
    output  logic   mem_to_reg_d,
    output  logic   mem_write_d,
    output  logic   branch_d,
    output  logic   [3:0]alu_control_d,
    output  logic   alu_src_d,
    output  logic   reg_dst_d,
    output  logic   [31:0]debug,
    output  logic   [31:0]rd1_d,
    output  logic   [31:0]rd2_d,
    output  logic   [4:0]rt_d,
    output  logic   [4:0]rd_d,
    output  logic   [31:0]imm_d
);

    logic [5:0] op, funct;
    logic [4:0] rs, rt, rd, shamt;
    logic [15:0] imm;
    logic [25:0] jump_addr;
    logic [31:0] wirte_data;
    logic write_enabled;
    logic [31:0] write_data;

    assign op = inst[31:26];
    assign funct = inst[5:0];
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    assign shamt = inst[10:6];
    assign imm = inst[15:0];
    assign jump_addr = inst[25:0];

    always_comb begin
        if (op == `RTYPE) begin
            case(funct)
                `ADDU: begin
                    write_enabled = 1'b1;
                    write_data = rd1_d + rd2_d;
                end
                `SUBU: begin
                    write_enabled = 1'b1;
                    write_data = rd1_d - rd2_d;
                end

                default: begin
                end
            endcase
        end
    end

    RegFile reg_file(
        .rst(rst),
        .clk(clk),
        .read_addr_1(rs),
        .read_addr_2(rt),
        .write_addr(rd),
        .write_data(write_data),
        .write_enabled(write_enabled),
        .data_1(rd1_d),
        .data_2(rd2_d)
    );

    SignExtend extend(
        .in(imm),
        .out(imm_d)
    );

    assign debug = write_data;
    assign rt_d = inst[20:16];
    assign rd_d = inst[15:11];



endmodule