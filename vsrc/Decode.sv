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
    input   logic   branch_resume,
    input   logic   dmem_resume,
    output  logic   branch_stall,
    output  logic   dmem_stall,
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
    output  logic   [31:0]pc_plus_4d,
    output  logic   [31:0]jump_addr_d,
    output  logic   [3:0]branch_type_d,
    output  logic   mem_access_d,
    output  logic   magic
);
    logic [5:0] op, funct;
    logic [4:0] rs, rt, rd;
    logic [15:0] imm;

    assign op = inst[31:26];
    assign funct = inst[5:0];
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];

    always_ff @(posedge clk) begin
        shamt_d <= inst[10:6];
        rs_d <= inst[25:21];
        rt_d <= inst[20:16];
        rd_d <= inst[15:11];
        imm <= inst[15:0];
        pc_plus_4d <= pc + 4;
        jump_addr_d <= {pc[31:28], inst[25:0], 2'b0};

        if (branch_stall && branch_resume) begin
            branch_stall <= 1'b0;
        end else if (op == `BEQ || op == `BNE || op == `BGEZ || op == `J || op == `JAL || (op == `RTYPE && funct == `JR)) begin
            if (op == `J) begin
                branch_type_d <= 4'b0001;
            end else if (op == `JAL) begin
                branch_type_d <= 4'b0010;
            end else if (op == `RTYPE && funct == `JR) begin
                branch_type_d <= 4'b0011;
            end else if (op == `BEQ) begin
                branch_type_d <= 4'b0100;
            end else if (op == `BNE) begin
                branch_type_d <= 4'b0101;
            end else if (op == `BGEZ && inst[20:16] == 5'b1) begin
                branch_type_d <= 4'b0110;
            end else if (op == `BGEZ && inst[20:16] != 5'b1) begin
                branch_type_d <= 4'b0111;
            end
            branch_stall <= 1'b1;
        end else begin
            branch_type_d <= 4'b0000;
        end

        if (dmem_stall && dmem_resume) begin
            dmem_stall <= 1'b0;
        end else if (op == `SW  || op == `LW) begin
            dmem_stall <= 1'b1;
        end

        if (rst) begin
            reg_write_d <= 1'b0;
            mem_to_reg_d <= 1'b0;
            mem_write_d <= 1'b0;
            branch_d <= 1'b0;
            alu_control_d <= 4'b0000;
            alu_src_d <= 2'b00;
            reg_dst_d <= 1'b1;
            mem_access_d <= 1'b0;
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
                    mem_access_d <= 1'b0;
                end
                `ADDU: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0000;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                    mem_access_d <= 1'b0;
                end
                `SUBU: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0001;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                    mem_access_d <= 1'b0;
                end
                `AND: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0010;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                    mem_access_d <= 1'b0;
                end
                `OR: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0011;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                    mem_access_d <= 1'b0;
                end
                `NOR: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0100;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                    mem_access_d <= 1'b0;
                end
                `XOR: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0101;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                    mem_access_d <= 1'b0;
                end     
                `SLL: begin
                    if (inst[15:11] == 5'b0) begin
                        reg_write_d <= 1'b0;
                        mem_to_reg_d <= 1'b0;
                        mem_write_d <= 1'b0;
                        branch_d <= 1'b0;
                        alu_control_d <= 4'b0000;
                        alu_src_d <= 2'b00;
                        reg_dst_d <= 1'b0;
                        mem_access_d <= 1'b0;
                    end else begin
                        reg_write_d <= 1'b1;
                        mem_to_reg_d <= 1'b0;
                        mem_write_d <= 1'b0;
                        branch_d <= 1'b0;
                        alu_control_d <= 4'b0110;
                        alu_src_d <= 2'b01;
                        reg_dst_d <= 1'b1;
                        mem_access_d <= 1'b0;
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
                    mem_access_d <= 1'b0;
                end
                `SRL: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b1000;
                    alu_src_d <= 2'b01;
                    reg_dst_d <= 1'b1;
                    mem_access_d <= 1'b0;
                end
                `SLT: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b1001;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                    mem_access_d <= 1'b0;
                end
                `SLTU: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b1010;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                    mem_access_d <= 1'b0;
                end
                `JR: begin
                    reg_write_d <= 1'b0;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b1;
                    alu_control_d <= 4'b1110;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b1;
                    mem_access_d <= 1'b0;
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
                    mem_access_d <= 1'b0;
                end
                `ANDI: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0010;
                    alu_src_d <= 2'b10;
                    reg_dst_d <= 1'b0;
                    mem_access_d <= 1'b0;
                end
                `ORI: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0011;
                    alu_src_d <= 2'b10;
                    reg_dst_d <= 1'b0;
                    mem_access_d <= 1'b0;
                end
                `XORI: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0101;
                    alu_src_d <= 2'b10;
                    reg_dst_d <= 1'b0;
                    mem_access_d <= 1'b0;
                end
                `SLTI: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b1001;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b0;
                    mem_access_d <= 1'b0;
                end
                `SLTIU: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b1010;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b0;
                    mem_access_d <= 1'b0;
                end
                `LUI: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b1011;
                    alu_src_d <= 2'b10;
                    reg_dst_d <= 1'b0;
                    mem_access_d <= 1'b0;
                end
                `BEQ: begin
                    reg_write_d <= 1'b0;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b1;
                    alu_control_d <= 4'b0001;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b0;
                    mem_access_d <= 1'b0;
                end
                `BNE: begin
                    reg_write_d <= 1'b0;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b1;
                    alu_control_d <= 4'b0001;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b0;
                    mem_access_d <= 1'b0;
                end
                `BGEZ: begin
                    reg_write_d <= 1'b0;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b1;
                    alu_control_d <= 4'b1110;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b0;
                    mem_access_d <= 1'b0;
                end
                `SW: begin
                    reg_write_d <= 1'b0;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b1;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0000;
                    alu_src_d <= 2'b11;
                    reg_dst_d <= 1'b0;
                    mem_access_d <= 1'b1;
                end
                `LW: begin
                    reg_write_d <= 1'b1;
                    mem_to_reg_d <= 1'b1;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b0;
                    alu_control_d <= 4'b0000;
                    alu_src_d <= 2'b10;
                    reg_dst_d <= 1'b0;
                    mem_access_d <= 1'b1;
                end
                `J: begin
                    reg_write_d <= 1'b0;
                    mem_to_reg_d <= 1'b0;
                    mem_write_d <= 1'b0;
                    branch_d <= 1'b1;
                    alu_control_d <= 4'b0000;
                    alu_src_d <= 2'b00;
                    reg_dst_d <= 1'b0;
                    mem_access_d <= 1'b0;
                end
                default: begin
                    $display("[PC: %0x] instruction %0x not implemented. ", pc, inst);
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
        .data_2(rd2_d),
        .magic(magic)
    );

    SignExtend extend(
        .in(imm),
        .out(imm_d)
    );

endmodule
