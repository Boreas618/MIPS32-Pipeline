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

    logic stall;

    logic forward_src_a_enabled;
    logic [31:0] forward_src_a;
    logic forward_src_b_enabled;
    logic [31:0] forward_src_b;

    Hazard hazard(
        .clk(clk),
        .rst(rst),
        .reg_write_e(reg_write_e),
        .reg_write_m(reg_write_m),
        .reg_write_w(reg_write_w),
        .rs_d(rs_d),
        .rt_d(rt_d),
        .write_reg_e(write_reg_e),
        .write_reg_m(write_reg_m),
        .write_reg_w(write_reg_w),
        .alu_out_e(alu_out_e),
        .alu_out_m(alu_out_m),
        .result_w(result_w),
        .forward_src_a_enabled(forward_src_a_enabled),
        .forward_src_a(forward_src_a),
        .forward_src_b_enabled(forward_src_b_enabled),
        .forward_src_b(forward_src_b)
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
    logic resume;

    always_ff @(posedge clk) begin
        if (rst) begin
            pc <= 32'h1000;
        end else begin
            last_pc <= pc;
            case (if_pc_src)
                2'h0: begin
                    pc <= stall ? pc : pc + 32'd4;
                end
                2'h1: begin
                    resume <= 1'b1;
                    pc <= if_pc_branch_in;
                end
                default: begin
                    pc <= 32'h1000;
                end
            endcase  
        end
    end

    InstMemory inst_mem (
        .rst(rst),
        .clk(clk),
        .stall(stall),
        .addr(pc),
        .r_data(inst),
        .err(m_err)
    );

    logic reg_write_d;
    logic mem_to_reg_d;
    logic mem_write_d;
    logic branch_d;
    logic [3:0]alu_control_d;
    logic [1:0]alu_src_d;
    logic reg_dst_d;
    logic [31:0]debug;
    logic [31:0]rd1_d;
    logic [31:0]rd2_d;
    logic [4:0]rs_d;
    logic [4:0]rt_d;
    logic [4:0]rd_d;
    logic [31:0]imm_d;
    logic [4:0]shamt_d;
    logic [31:0]pc_plus_4d;
    logic [31:0]jump_addr_d;
    logic j_inst_d;

    Decode decode(
        .inst(inst),
        .rst(rst),
        .clk(clk),
        .pc(pc),
        .reg_write_d(reg_write_d),
        .mem_to_reg_d(mem_to_reg_d),
        .mem_write_d(mem_write_d),
        .branch_d(branch_d),
        .alu_control_d(alu_control_d),
        .alu_src_d(alu_src_d),
        .reg_dst_d(reg_dst_d),
        .rd1_d(rd1_d),
        .rd2_d(rd2_d),
        .rs_d(rs_d),
        .rt_d(rt_d),
        .rd_d(rd_d),
        .imm_d(imm_d),
        .shamt_d(shamt_d),
        .write_reg(write_reg_w),
        .write_data(result_w),
        .write_enabled(reg_write_w),
        .stall(stall),
        .pc_plus_4d(pc_plus_4d),
        .resume(resume),
        .jump_addr_d(jump_addr_d),
        .j_inst_d(j_inst_d)
    );

    logic [31:0] alu_out_e;
    logic [31:0] write_data_e;
    logic [4:0] write_reg_e;
    logic reg_write_e;
    logic mem_to_reg_e;
    logic mem_write_e;
    logic branch_e;
    logic zero_e;
    logic [31:0] pc_branch_e;
    logic [31:0]jump_addr_e;
    logic j_inst_e;

    Execute execute (
        .clk(clk),
        .rst(rst),
        .shamt_d(shamt_d),
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
        .jump_addr_d(jump_addr_d),
        .j_inst_d(j_inst_d),
        .forward_src_a_enabled(forward_src_a_enabled),
        .forward_src_a(forward_src_a),
        .forward_src_b_enabled(forward_src_b_enabled),
        .forward_src_b(forward_src_b),
        .alu_out_e(alu_out_e),
        .write_data_e(write_data_e),
        .write_reg_e(write_reg_e),
        .reg_write_e(reg_write_e),
        .mem_to_reg_e(mem_to_reg_e),
        .mem_write_e(mem_write_e),
        .branch_e(branch_e),
        .zero_e(zero_e),
        .pc_plus_4d(pc_plus_4d),
        .pc_branch_e(pc_branch_e),
        .jump_addr_e(jump_addr_e),
        .j_inst_e(j_inst_e)
    );

    logic [31:0] read_data_m;
    logic [31:0] alu_out_m;
    logic reg_write_m;
    logic mem_to_reg_m;
    logic [4:0] write_reg_m;

    Memory memory(
        .clk(clk),
        .rst(rst),
        .reg_write_e(reg_write_e),
        .mem_to_reg_e(mem_to_reg_e),
        .mem_write_e(mem_write_e),
        .branch_e(branch_e),
        .alu_out_e(alu_out_e),
        .write_data_e(write_data_e),
        .write_reg_e(write_reg_e),
        .zero_e(zero_e),
        .read_data_m(read_data_m),
        .alu_out_m(alu_out_m),
        .reg_write_m(reg_write_m),
        .mem_to_reg_m(mem_to_reg_m),
        .write_reg_m(write_reg_m),
        .stall(stall),
        .if_pc_branch_in(if_pc_branch_in),
        .if_pc_src(if_pc_src),
        .pc_branch_e(pc_branch_e),
        .jump_addr_e(jump_addr_e),
        .j_inst_e(j_inst_e)
    );

    logic [31:0] result_w;
    logic [4:0] write_reg_w;
    logic reg_write_w;

    WriteBack write_back(
        .rst(rst),
        .clk(clk),
        .reg_write_m(reg_write_m),
        .mem_to_reg_m(mem_to_reg_m),
        .alu_out_m(alu_out_m),
        .read_data_m(read_data_m),
        .write_reg_m(write_reg_m),
        .write_reg_w(write_reg_w),
        .result_w(result_w),
        .reg_write_w(reg_write_w)
    );

    /* Legacy Debug functionalities.
     *
     * Note that this part is planned to be removed in the future and
     * switch to the DebugPort module.
     */
    assign last_inst = inst;
    always @(posedge clk) begin
        if (rst) begin
            system_counter <= 32'b0;
            err <= 1'b0;
        end
        else begin
            system_counter <= system_counter + 32'd1;
        end
    end

    wire write_enabled;
    wire m_err;
    wire [31:0] w_data;

    assign write_enabled = 1'b0;
    assign w_data = 32'b0;

endmodule
