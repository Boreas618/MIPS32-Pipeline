module Execute(
    input   logic   clk,
    input   logic   rst,
    input   logic   [31:0] rd1_d,
    input   logic   [31:0] rd2_d,
    input   logic   [4:0]rt_d,
    input   logic   [4:0]rd_d,
    input   logic   [31:0]imm_d,
    input   logic   reg_write_d,
    input   logic   mem_to_reg_d,
    input   logic   mem_write_d,
    input   logic   branch_d,
    input   logic   [3:0] alu_control_d,
    input   logic   alu_src_d,
    input   logic   reg_dst_d,
    output  logic   [31:0] alu_out_e,
    output  logic   [31:0] write_data_e,
    output  logic   [4:0] write_reg_e,
    output  logic   reg_write_e,
    output  logic   mem_to_reg_e,
    output  logic   mem_write_e,
    output  logic   branch_e
);
    logic [3:0]alu_control_e;
    logic alu_src_e;
    logic reg_dst_e;
    logic [31:0]rd1_e;
    logic [31:0]rd2_e;
    logic [4:0]rt_e;
    logic [4:0]rd_e;
    logic [31:0]imm_e;
    logic [31:0]src1_e;
    logic [31:0]src2_e;

    assign src1_e = rd1_e;
    assign src2_e = alu_src_e ? imm_e : rd2_e;
    assign write_data_e = rd2_e;
    assign write_reg_e = reg_dst_e ? rd_e :rt_e;

    always_ff @(posedge clk, negedge rst) begin
        if (rst) begin
            reg_write_e <= 0;
            mem_to_reg_e <= 0;
            mem_write_e <= 0;
            branch_e <= 0;
            alu_control_e <= 4'b0;
            alu_src_e <= 0;
            reg_dst_e <= 0;
            rd1_e <= 32'b0;
            rd2_e <= 32'b0;
            rt_e <= 5'b0;
            rd_e <= 5'b0;
            imm_e <= 32'b0;
        end else begin
            reg_write_e <= reg_write_d;
            mem_to_reg_e <= mem_to_reg_d;
            mem_write_e <= mem_write_d;
            branch_e <= branch_d;
            alu_control_e <= alu_control_d;
            alu_src_e <= alu_src_d;
            reg_dst_e <= reg_dst_d;
            rd1_e <= rd1_d;
            rd2_e <= rd2_d;
            rt_e <= rt_d;
            rd_e <= rd_d;
            imm_e <= imm_d;
        end
    end

    ALU alu(
		.alu_ctrl(alu_control_e),
		.src1(src1_e),
		.src2(src2_e),
		.out(alu_out_e)
	);

endmodule
