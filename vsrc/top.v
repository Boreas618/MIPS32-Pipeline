/*
 * We use a self-defined ISA here,
 * you should change it to your chosen ISA (MIPS or LoongArch).
 *
 * instructions:
 * 0x1: write 1 to reg1
 * 0x2: write 2 to reg2
 * 0x3: write reg1 + reg2 to reg3
 * 0x4: write 0 to reg1
 * 0x0: halt, set err if reg1 != 0.
 *
 * PC always points to the address of next instruction here.
 * After reset, PC will be set to 0x1000.
 */
module top (
	input	wire					clk,
	input	wire					rst,

	output	reg		[63:0]			pc,
	output	reg						halt,

	output	reg		[63:0]			counter,	// system counter
	output	reg		[63:0]			last_pc,
	output	reg		[63:0]			last_inst,
	output	reg						err
);

	import "DPI-C" function void set_regs_ptr(input logic[63:0] r[]);

	import "DPI-C" function void mm_read(
		input	longint		addr,
		output	longint		data
	);

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
	end

endmodule
