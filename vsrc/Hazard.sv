/* verilator lint_off UNUSEDSIGNAL */
module Hazard(
    input   logic   rst,
    input   logic   clk,
    input   logic   reg_write_e,
    input   logic   reg_write_m,
    input   logic   reg_write_w,
    input   logic   [4:0] rs_d,
    input   logic   [4:0] rt_d,
    input   logic   [4:0] write_reg_e,
    input   logic   [4:0] write_reg_m,
    input   logic   [4:0] write_reg_w,
    input   logic   [31:0] alu_out_e,
    input   logic   [31:0] alu_out_m,
    input   logic   [31:0] result_w,
    output  logic   forward_src_a_enabled,
    output  logic   [31:0] forward_src_a,
    output  logic   forward_src_b_enabled,
    output  logic   [31:0] forward_src_b
);
    always @(*) begin
        if (reg_write_e && write_reg_e == rs_d) begin
            forward_src_a_enabled = 1'b1;
            forward_src_a = alu_out_e;
        end else if (reg_write_m && write_reg_m == rs_d) begin
            forward_src_a_enabled = 1'b1;
            forward_src_a = alu_out_m;
        end else if (reg_write_w && write_reg_w == rs_d) begin
            forward_src_a_enabled = 1'b1;
            forward_src_a = result_w;
        end else begin
            forward_src_a_enabled = 1'b0;
            forward_src_a = 32'b0;
        end

        if (reg_write_e && write_reg_e == rt_d) begin
            forward_src_b_enabled = 1'b1;
            forward_src_b = alu_out_e;
        end else if (reg_write_m && write_reg_m == rt_d) begin
            forward_src_b_enabled = 1'b1;
            forward_src_b = alu_out_m;
        end else if (reg_write_w && write_reg_w == rt_d) begin
            forward_src_b_enabled = 1'b1;
            forward_src_b = result_w;
        end else begin
            forward_src_b_enabled = 1'b0;
            forward_src_b = 32'b0;
        end
    end
endmodule
