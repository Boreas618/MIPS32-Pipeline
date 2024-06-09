/* verilator lint_off UNUSEDSIGNAL */

module DebugPort(
    input   logic   clk,
    input   logic   [31:0] inst,
    input   logic   [1:0] if_pc_src,
    input   logic   [31:0] if_pc_branch_in,
    input   logic   reg_write_d,
    input   logic   mem_to_reg_d,
    input   logic   mem_write_d,
    input   logic   branch_d,
    input   logic   [3:0] alu_control_d,
    input   logic   [1:0] alu_src_d,
    input   logic   reg_dst_d,
    input   logic   [31:0] rd1_d,
    input   logic   [31:0] rd2_d,
    input   logic   [4:0] rt_d,
    input   logic   [4:0] rd_d,
    input   logic   [31:0] imm_d,
    input   logic   [4:0] shamt_d,
    input   logic   [31:0] alu_out_e,
    input   logic   [31:0] write_data_e,
    input   logic   [4:0] write_reg_e,
    input   logic   reg_write_e,
    input   logic   mem_to_reg_e,
    input   logic   mem_write_e,
    input   logic   branch_e,
    input   logic   [31:0] alu_src_a,
    input   logic   [31:0] alu_src_b,
    input   logic   forward_src_a_enabled,
    input   logic   forward_src_b_enabled,
    input   logic   [4:0] write_reg_w,
    input   logic   [31:0] result_w,
    input   logic   reg_write_w,
    input   logic   [31:0] src1_e,
    input   logic   [31:0] src2_e
);

    logic [31:0] aligned_if_pc_src;
    logic [31:0] aligned_reg_write_d;
    logic [31:0] aligned_mem_to_reg_d;
    logic [31:0] aligned_mem_write_d;
    logic [31:0] aligned_branch_d;
    logic [31:0] aligned_alu_control_d;
    logic [31:0] aligned_alu_src_d;
    logic [31:0] aligned_reg_dst_d;
    logic [31:0] aligned_rt_d;
    logic [31:0] aligned_rd_d;
    logic [31:0] aligned_shamt_d;
    logic [31:0] aligned_write_reg_e;
    logic [31:0] aligned_reg_write_e;
    logic [31:0] aligned_mem_to_reg_e;
    logic [31:0] aligned_mem_write_e;
    logic [31:0] aligned_branch_e;
    logic [31:0] aligned_forward_src_a_enabled;
    logic [31:0] aligned_forward_src_b_enabled;
    logic [31:0] aligned_write_reg_w;
    logic [31:0] aligned_reg_write_w;

    AlignTo32 #(2) align_if_pc_src (.in(if_pc_src), .out(aligned_if_pc_src));
    AlignTo32 #(1) align_reg_write_d (.in(reg_write_d), .out(aligned_reg_write_d));
    AlignTo32 #(1) align_mem_to_reg_d (.in(mem_to_reg_d), .out(aligned_mem_to_reg_d));
    AlignTo32 #(1) align_mem_write_d (.in(mem_write_d), .out(aligned_mem_write_d));
    AlignTo32 #(1) align_branch_d (.in(branch_d), .out(aligned_branch_d));
    AlignTo32 #(4) align_alu_control_d (.in(alu_control_d), .out(aligned_alu_control_d));
    AlignTo32 #(2) align_alu_src_d (.in(alu_src_d), .out(aligned_alu_src_d));
    AlignTo32 #(1) align_reg_dst_d (.in(reg_dst_d), .out(aligned_reg_dst_d));
    AlignTo32 #(5) align_rt_d (.in(rt_d), .out(aligned_rt_d));
    AlignTo32 #(5) align_rd_d (.in(rd_d), .out(aligned_rd_d));
    AlignTo32 #(5) align_shamt_d (.in(shamt_d), .out(aligned_shamt_d));
    AlignTo32 #(5) align_write_reg_e (.in(write_reg_e), .out(aligned_write_reg_e));
    AlignTo32 #(1) align_reg_write_e (.in(reg_write_e), .out(aligned_reg_write_e));
    AlignTo32 #(1) align_mem_to_reg_e (.in(mem_to_reg_e), .out(aligned_mem_to_reg_e));
    AlignTo32 #(1) align_mem_write_e (.in(mem_write_e), .out(aligned_mem_write_e));
    AlignTo32 #(1) align_branch_e (.in(branch_e), .out(aligned_branch_e));
    AlignTo32 #(1) align_forward_src_a_enabled (.in(forward_src_a_enabled), .out(aligned_forward_src_a_enabled));
    AlignTo32 #(1) align_forward_src_b_enabled (.in(forward_src_b_enabled), .out(aligned_forward_src_b_enabled));
    AlignTo32 #(5) align_write_reg_w (.in(write_reg_w), .out(aligned_write_reg_w));
    AlignTo32 #(1) align_reg_write_w (.in(reg_write_w), .out(aligned_reg_write_w));

    logic [31:0] aligned_logics [63:0];
    import "DPI-C" function void set_debug_port_ptr(input logic[31:0] r[]);
    initial begin set_debug_port_ptr(aligned_logics); end

    parameter id_port_begin = 7;
    parameter ex_port_begin = 20;
    parameter wb_port_begin = 30;

    always_comb begin
        aligned_logics[0] = inst;
        aligned_logics[1] = aligned_if_pc_src;
        aligned_logics[2] = if_pc_branch_in;
        aligned_logics[3] = alu_src_a;
        aligned_logics[4] = alu_src_b;
        aligned_logics[5] = aligned_forward_src_a_enabled;
        aligned_logics[6] = aligned_forward_src_b_enabled;

        aligned_logics[id_port_begin + 0] = aligned_reg_write_d;
        aligned_logics[id_port_begin + 1] = aligned_mem_to_reg_d;
        aligned_logics[id_port_begin + 2] = aligned_mem_write_d;
        aligned_logics[id_port_begin + 3] = aligned_branch_d;
        aligned_logics[id_port_begin + 4] = aligned_alu_control_d;
        aligned_logics[id_port_begin + 5] = aligned_alu_src_d;
        aligned_logics[id_port_begin + 6] = aligned_reg_dst_d;
        aligned_logics[id_port_begin + 7] = rd1_d;
        aligned_logics[id_port_begin + 8] = rd2_d;
        aligned_logics[id_port_begin + 9] = aligned_rt_d;
        aligned_logics[id_port_begin + 10] = aligned_rd_d;
        aligned_logics[id_port_begin + 11] = imm_d;
        aligned_logics[id_port_begin + 12] = aligned_shamt_d;

        aligned_logics[ex_port_begin + 0] = alu_out_e;
        aligned_logics[ex_port_begin + 1] = write_data_e;
        aligned_logics[ex_port_begin + 2] = aligned_write_reg_e;
        aligned_logics[ex_port_begin + 3] = aligned_reg_write_e;
        aligned_logics[ex_port_begin + 4] = aligned_mem_to_reg_e;
        aligned_logics[ex_port_begin + 5] = aligned_mem_write_e;
        aligned_logics[ex_port_begin + 6] = aligned_branch_e;
        aligned_logics[ex_port_begin + 7] = src1_e;
        aligned_logics[ex_port_begin + 8] = src2_e;

        aligned_logics[wb_port_begin + 0] = aligned_write_reg_w;
        aligned_logics[wb_port_begin + 1] = aligned_reg_write_w;
        aligned_logics[wb_port_begin + 2] = result_w;
    end
endmodule
