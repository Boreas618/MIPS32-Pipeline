/* verilator lint_off UNUSEDSIGNAL */
module InstMemory(
    input   logic   clk,
    input   logic   rst,
    input   logic   stall,
    input   logic   [31:0] addr,
    output  logic   err,
    output  logic   [31:0] r_data
);

    import "DPI-C" function void mm_read(
        input longint addr,
        output longint data
    );

    logic [63:0] expanded_addr = {32'b0, addr};

    always_ff @(posedge clk) begin
        if (rst || stall) begin
            r_data <= 32'b0;
        end else begin
            logic [63:0] data;
            mm_read(expanded_addr, data);
            r_data <= data[31:0];
        end
        err <= 1'b0;
    end

endmodule
