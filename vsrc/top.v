module top (
	input rst,
	input clk,
	output halt,
	output err,
	output [31:0] pc,
	output [31:0] system_counter,
	output [31:0] last_pc,
	output [31:0] last_inst
);
	/*
	import "DPI-C" function void set_regs_ptr(input logic[31:0] r[]);

	initial begin
		set_regs_ptr(regs);
	end

	// Registers
	reg		[63:0]			regs[2:0];
	integer i;

	always @(posedge clk) begin
		for (i = 0; i < 2; i = i + 1) begin
			if (rst)
				regs[i] <= 64'd0;
		end
	end

	// Program counter
	always @(posedge clk) begin
		if (rst)
			pc <= 64'h1000;
		else
			pc <= pc + 64'd8;
	end

	// Current instruction
	reg		[63:0]			inst;

	always @(*) begin
		mm_read(pc, inst);
	end

	// Decode and Execute
	always @(posedge clk) begin
		if (~rst) begin
			case (inst)
				64'd0: begin
					halt <= 1'b1;
					if (regs[0] != 64'd0)
						err <= 1'b1;
				end
				64'd1: regs[0] <= 64'd1;
				64'd2: regs[1] <= 64'd2;
				64'd3: regs[2] <= regs[0] + regs[1];
				64'd4: regs[0] <= 64'd0;
				default: err <= 1'b1;
			endcase
		end
	end

	// For debug
	always @(posedge clk) begin
		if (rst) begin
			counter <= 64'b0;
			last_pc <= 64'b0;
			last_inst <= 64'b0;
			err <= 1'b0;
		end
		else begin
			counter <= counter + 64'd1;
			last_pc <= pc;
			last_inst <= inst;
		end
	end*/

	wire write_enabled;
	wire [31:0] addr;
	wire [31:0] w_data;
	wire [31:0] r_data;

	SimulatedMemory simulatedMemory (
		.reset(rst),
		.clk(clk),
		.write_enabled(write_enabled),
		.addr(addr),
		.w_data(w_data),
		.r_data(r_data)
	);


endmodule
