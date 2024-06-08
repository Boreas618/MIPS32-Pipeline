/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off SYNCASYNCNET */
/* verilator lint_off UNDRIVEN */
module Top (
    input	logic	rst,
    input	logic	clk,
    output	logic	halt,
    output	logic	err,
    output	logic	[31:0] pc,
    output	logic	[31:0] system_counter,
    output	logic	[31:0] last_pc,
    output	logic	[31:0] last_inst
);

    DebugPort debug_port (
        .clk(clk),
        .inst(inst),
        .if_pc_src(if_pc_src),
        .if_pc_branch_in(if_pc_branch_in),
        .reg_write_d(reg_write_d),
        .mem_to_reg_d(mem_to_reg_d),
        .mem_write_d(mem_write_d),
        .branch_d(branch_d),
        .alu_control_d(alu_control_d),
        .alu_src_d(alu_src_d),
        .reg_dst_d(reg_dst_d),
        .rd1_d(rd1_d),
        .rd2_d(rd2_d),
        .rt_d(rt_d),
        .rd_d(rd_d),
        .imm_d(imm_d),
        .alu_out_e(alu_out_e),
        .write_data_e(write_data_e),
        .write_reg_e(write_reg_e),
        .reg_write_e(reg_write_e),
        .mem_to_reg_e(mem_to_reg_e),
        .mem_write_e(mem_write_e),
        .branch_e(branch_e)
    );
    
    /* Instruction Fetch Stage.
     * 
     * `inst`: the current instruction with MIPS encoding specification.
     * `if_pc_src`: select the next PC.
     * `if_pc_branch_in`: the next PC provided by branch instructions.
     */
    logic [31:0] inst;
    logic [1:0] if_pc_src;
    logic [31:0] if_pc_branch_in;
    
    assign if_pc_src = 2'h0;
    assign if_pc_branch_in = 32'h0;

    always_ff @(posedge clk, negedge rst) begin
        if (rst) begin
            pc <= 32'h1000 - 32'd4;
        end else begin
            case (if_pc_src)
                2'h0: pc <= pc + 32'd4;
                2'h1: pc <= if_pc_branch_in;
                default: pc <= 32'h1000 - 32'd4;
            endcase
        end
    end

    InstMemory inst_mem (
        .reset(rst),
        .addr(pc),
        .r_data(inst),
        .err(m_err)
    );

    logic reg_write_d;
    logic mem_to_reg_d;
    logic mem_write_d;
    logic branch_d;
    logic [3:0]alu_control_d;
    logic alu_src_d;
    logic reg_dst_d;
    logic [31:0]debug;
    logic [31:0]rd1_d;
    logic [31:0]rd2_d;
    logic [4:0]rt_d;
    logic [4:0]rd_d;
    logic [31:0]imm_d;

    Decode decode(
        .rst(rst),
        .clk(clk),
        .inst(inst),
        .pc(pc),
        .reg_write_d(reg_write_d),
        .mem_to_reg_d(mem_to_reg_d),
        .mem_write_d(mem_write_d),
        .branch_d(branch_d),
        .alu_control_d(alu_control_d),
        .alu_src_d(alu_src_d),
        .reg_dst_d(reg_dst_d),
        .debug(debug),
        .rd1_d(rd1_d),
        .rd2_d(rd2_d),
        .rt_d(rt_d),
        .rd_d(rd_d),
        .imm_d(imm_d)
    );

    logic [31:0] alu_out_e;
    logic [31:0] write_data_e;
    logic [4:0] write_reg_e;
    logic reg_write_e;
    logic mem_to_reg_e;
    logic mem_write_e;
    logic branch_e;

    Execute execute (
        .clk(clk),
        .rst(rst),
        .rd1_d(rd1_d),
        .rd2_d(rd2_d),
        .rt_d(rt_d),
        .rd_d(rd_d),
        .imm_d(imm_d),
        .reg_write_d(reg_write_d),
        .mem_to_reg_d(mem_to_reg_d),
        .mem_write_d(mem_write_d),
        .branch_d(branch_d),
        .alu_control_d(alu_control_d),
        .alu_src_d(alu_src_d),
        .reg_dst_d(reg_dst_d),
        .alu_out_e(alu_out_e),
        .write_data_e(write_data_e),
        .write_reg_e(write_reg_e),
        .reg_write_e(reg_write_e),
        .mem_to_reg_e(mem_to_reg_e),
        .mem_write_e(mem_write_e),
        .branch_e(branch_e)
    );

    /* Legacy Debug functionalities.
	 *
	 * Note that this part is planned to be removed in the future and
	 * switch to the DebugPort module.
	 */
    always @(posedge clk) begin
        if (rst) begin
            system_counter <= 32'b0;
            last_pc <= 32'b0;
            last_inst <= 32'b0;
            err <= 1'b0;
        end
        else begin
            system_counter <= system_counter + 32'd1;
            last_pc <= pc;
            last_inst <= inst;
        end
    end

    wire write_enabled;
    wire m_err;
    wire [31:0] w_data;

    assign write_enabled = 1'b0;
    assign w_data = 32'b0;

endmodule
