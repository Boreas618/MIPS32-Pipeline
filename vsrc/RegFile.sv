/* verilator lint_off WIDTHTRUNC */
module RegFile(
    input   logic   rst,
    input   logic   clk,
    input   logic   [4:0]read_addr_1,
    input   logic   [4:0]read_addr_2,
    input   logic   [4:0]write_addr,
    input   logic   [31:0]write_data,
    input   logic   write_enabled,
    output  logic   [31:0]data_1,
    output  logic   [31:0]data_2
);
    import "DPI-C" function void set_regs_ptr(input logic[31:0] r[]);
	initial begin set_regs_ptr(regs); end

	/* 32 General Purpose Regsiters. */
	logic [31:0] regs[31:0];
	integer i;
	always @(posedge clk) begin
		for (i = 0; i < 31; i = i + 1) begin
			if (rst)
				regs[i] <= {27'b0, i};
		end
	end

    assign data_1 = regs[read_addr_1];
    assign data_2 = regs[read_addr_2];

    always @(posedge clk) begin
        if (write_enabled) begin
            regs[write_addr] <= write_data;
        end
    end
endmodule
