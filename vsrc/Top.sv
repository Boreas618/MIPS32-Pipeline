/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off SYNCASYNCNET */
/* verilator lint_off UNDRIVEN */
`include "Config.svh"

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

    always_comb begin
        if (pc == `EXIT_ADDR) begin
            halt = 1'b1;
            err = ~magic;
        end else begin
            halt = 1'b0;
            err = 1'b0;
        end
    end

    logic branch_stall;
    logic imem_stall;
    logic dmem_stall;
    logic branch_resume;
    logic dmem_resume;
    logic stall;

    assign imem_stall = ~(imem_status == 2'b10);
    assign branch_resume = branch_e;
    assign dmem_resume = dmem_status == 2'b10;
    assign stall = branch_stall || imem_stall || dmem_stall;

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
    
    /* 
     * Instruction Fetch Stage.
     * 
     * `inst`: the current instruction with MIPS encoding specification.
     * `if_pc_src`: select the next PC.
     * `if_pc_branch_in`: the next PC provided by branch instructions.
     */
    logic [31:0] inst;
    logic [1:0] if_pc_src;
    logic [31:0] if_pc_branch_in;
    logic [1:0] imem_status;

    always_ff @(posedge clk) begin
        if (rst) begin
            pc <= `TEXT_BASE;
        end else begin
            last_pc <= pc;
            case (if_pc_src)
                2'h0: begin
                    pc <= stall ? pc : pc + 32'd4;
                end
                2'h1: begin
                    pc <= if_pc_branch_in;
                end
                default: begin
                    pc <= `TEXT_BASE;
                end
            endcase  
        end
    end

    InstMemory inst_mem (
        .rst(rst),
        .clk(clk),
        .stall(dmem_stall || branch_stall),
        .addr(pc),
        .r_data(inst),
        .r_data_status(imem_status)
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
    logic [3:0] branch_type_d;
    logic mem_access_d;
    logic magic;

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
        .branch_stall(branch_stall),
        .dmem_stall(dmem_stall),
        .pc_plus_4d(pc_plus_4d),
        .branch_resume(branch_resume),
        .dmem_resume(dmem_resume),
        .jump_addr_d(jump_addr_d),
        .branch_type_d(branch_type_d),
        .magic(magic),
        .mem_access_d(mem_access_d)
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
    logic [3:0] branch_type_e;
    logic mem_access_e;

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
        .branch_type_d(branch_type_d),
        .mem_access_d(mem_access_d),
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
        .branch_type_e(branch_type_e),
        .mem_access_e(mem_access_e)
    );

    logic [31:0] read_data_m;
    logic [31:0] alu_out_m;
    logic reg_write_m;
    logic mem_to_reg_m;
    logic [4:0] write_reg_m;
    logic [1:0] dmem_status;

    Memory memory(
        .clk(clk),
        .rst(rst),
        .mem_access_e(mem_access_e),
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
        .if_pc_branch_in(if_pc_branch_in),
        .if_pc_src(if_pc_src),
        .pc_branch_e(pc_branch_e),
        .jump_addr_e(jump_addr_e),
        .branch_type_e(branch_type_e),
        .dmem_status(dmem_status)
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

    /* 
     * Legacy Debug functionalities.
     *
     * Note that this part is planned to be removed in the future and
     * switch to the DebugPort module.
     */
    assign last_inst = inst;
    always @(posedge clk) begin
        if (rst) begin
            system_counter <= 32'b0;
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
