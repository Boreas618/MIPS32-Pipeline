/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNDRIVEN */

`include "Icode.svh"

module Decode(
    input   logic   rst,
    input   logic   clk,
    input   logic   [31:0]inst,
    input   logic   [31:0]pc,
    input   logic   [4:0]write_reg,
    input   logic   [31:0]write_data,
    input   logic   write_enabled,
    input   logic   resume,
    output  logic   stall,
    output  logic   reg_write_d,
    output  logic   mem_to_reg_d,
    output  logic   mem_write_d,
    output  logic   branch_d,
    output  logic   [3:0]alu_control_d,
    output  logic   [1:0]alu_src_d,
    output  logic   reg_dst_d,
    output  logic   [31:0]rd1_d,
    output  logic   [31:0]rd2_d,
    output  logic   [4:0]rs_d,
    output  logic   [4:0]rt_d,
    output  logic   [4:0]rd_d,
    output  logic   [31:0]imm_d,
    output  logic   [4:0]shamt_d,
    output  logic   [31:0]pc_plus_4d
);
    logic [5:0] op, funct;
    logic [4:0] rs, rt, rd;
    logic [15:0] imm;
    logic [25:0] jump_addr;

    assign op = inst[31:26];
    assign funct = inst[5:0];
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    assign jump_addr = inst[25:0];

    always_ff @(posedge clk) begin
        shamt_d <= inst[10:6];
        rs_d <= inst[25:21];
        rt_d <= inst[20:16];
        rd_d <= inst[15:11];
        imm <= inst[15:0];
        pc_plus_4d <= pc + 0;

        if (stall && resume) begin
            stall <= 1'b0;
        end else if (op == `BEQ) begin
            stall <= 1'b1;
        end

        if (rst) begin
            reg_write_d <= 1'b0;
            mem_to_reg_d <= 1'b0;
            mem_write_d <= 1'b0;
            branch_d <= 1'b0;
            alu_control_d <= 4'b0000;
            alu_src_d <= 2'b00;
            reg_dst_d <= 1'b1;
        end 
        else if (op == `RTYPE) begin
            case(funct)
                /* 
                 * Currently, our CPU doesn't support exception and therefore add is simply
                 * an alias of addu
                 */
                `ADD: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0000;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                end
                `ADDU: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0000;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                end
                `SUBU: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0001;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                end
                `AND: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0010;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                end
                `OR: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0011;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                end
                `NOR: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0100;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                end
                `XOR: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0101;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                end     
                `SLL: begin
                    if (rd_d == 5'b0) begin
                        reg_write_d <= 1'b0;
                        mem_to_reg_d <= 1'b0;
                        mem_write_d <= 1'b0;
                        branch_d <= 1'b0;
                        alu_control_d <= 4'b0000;
                        alu_src_d <= 2'b00;
                        reg_dst_d <= 1'b0;
                    end else begin
                        reg_write_d <= 1'b1;
                        mem_to_reg_d <= 1'b0;
                        mem_write_d <= 1'b0;
                        branch_d <= 1'b0;
                        alu_control_d <= 4'b0110;
                        alu_src_d <= 2'b01;
                        reg_dst_d <= 1'b1;
                    end
                end
                `SRA: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0111;
                    alu_src_d <= 2'b01;
                    reg_dst_d <= 1'b1;
                end
                `SRL: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b1000;
                    alu_src_d <= 2'b01;
                    reg_dst_d <= 1'b1;
                end
                `SLT: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b1001;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                end
                `SLTU: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b1010;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                end
                `JR: begin
                    /*TODO*/
                end
                default: begin
                end
            endcase
        end else begin
            case(op)
                `ADDIU: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0000;
                    alu_src_d <= 2'b10;
                    reg_dst_d <= 1'b0;
                end
                `ANDI: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0010;
                    alu_src_d <= 2'b10;
                    reg_dst_d <= 1'b0;
                end
                `ORI: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0011;
                    alu_src_d <= 2'b10;
                    reg_dst_d <= 1'b0;
                end
                `XORI: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0101;
                    alu_src_d <= 2'b10;
                    reg_dst_d <= 1'b0;
                end
                `SLTI: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b1001;
                    alu_src_d <= 2'b10;
                    reg_dst_d <= 1'b0;
                end
                `SLTIU: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b1010;
                    alu_src_d <= 2'b10;
                    reg_dst_d <= 1'b0;
                end
                `BEQ: begin
                    reg_write_d <= 1'b0;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b1;
                    alu_control_d <= 4'b0001;
                    alu_src_d <= 2'b10;
                    reg_dst_d <= 1'b0;
                end
                `SW: begin
                    reg_write_d <= 1'b0;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b1;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0000;
                    alu_src_d <= 2'b11;
                    reg_dst_d <= 1'b0;
                end
                `LW: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b1;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0000;
                    alu_src_d <= 2'b10;
                    reg_dst_d <= 1'b0;
                end
                default: begin
                    $display("Funct %0d not implemented.", op);
                end
            endcase
        end
    end

    RegFile reg_file(
        .rst(rst),
        .clk(clk),
        .read_addr_1(rs),
        .read_addr_2(rt),
        .write_addr(write_reg),
        .write_data(write_data),
        .write_enabled(write_enabled),
        .data_1(rd1_d),
        .data_2(rd2_d)
    );

    SignExtend extend(
        .in(imm),
        .out(imm_d)
    );

endmodule
