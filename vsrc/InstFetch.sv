module InstFetch(
    input   logic   clk,
    input   logic   rst,
    input   logic   [1:0] if_pc_src,
    inout   logic   [63:0] pc_in,
    input   logic   [63:0] pc_branch_in,
    output  logic   [63:0] inst,
    output  logic   m_err
);
    always_ff @(posedge clk, negedge rst) begin
        if (rst) begin
            pc <= 64'h1000 - 64'd8;
        end else begin
            case (if_pc_src)
                2'h0: pc <= pc + 64'd8;
                2'h1: pc <= pc_branch_in;
                default: pc <= 64'h1000 - 64'd8;
            endcase
        end
    end

	InstMemory inst_mem (
		.reset(rst),
		.addr(pc),
		.r_data(inst),
		.err(m_err)
	);

endmodule
