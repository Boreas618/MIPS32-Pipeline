/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off SYNCASYNCNET */
/* verilator lint_off UNDRIVEN */
module Top (
	input 	logic 	rst,
	input 	logic 	clk,
	output 	logic 	halt,
	output 	logic	err,
	output	logic 	[31:0] pc,
	output 	logic 	[31:0] system_counter,
	output	logic	[31:0] last_pc,
	output	logic 	[31:0] last_inst
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
    logic [1:0]reg_dst_d;
    logic [31:0]debug;

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
		.debug(debug)
	);

	/*
	// Decode and Execute
	always @(posedge clk) begin
		if (~rst) begin
			case (inst)
				32'd0: begin
					halt <= 1'b1;
					if (regs[0] != 32'd0)
						err <= 1'b1;
				end
				32'd1: regs[0] <= 32'd1;
				32'd2: regs[1] <= 32'd2;
				32'd3: regs[2] <= regs[0] + regs[1];
				32'd4: regs[0] <= 32'd0;
				default: err <= 1'b1;
			endcase
		end
	end
	*/

	// For debug
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
