/* verilator lint_off UNUSEDSIGNAL */
module DataMemory(
    input   logic   reset,
    input   logic   clk,
    input   logic   write_enabled,
    input   logic   [31:0] addr,
    input   logic   [31:0] w_data,
    output  logic   err,
    output  logic   [31:0] r_data
);

    import "DPI-C" function void mm_read(
        input longint addr,
        output longint data
    );

    import "DPI-C" function void mm_write(
        input longint addr,
        input longint data
    );

    logic [63:0] expanded_addr = {32'b0, addr};

    assign err = 1'b0;

    always_ff @(posedge clk) begin
        if (write_enabled) begin
            logic [63:0] expanded_w_data = {32'b0, w_data};
            mm_write(expanded_addr, expanded_w_data);
        end else begin
            logic [31:0] dummy_data;
            mm_read(expanded_addr, {dummy_data, r_data});
        end
    end

endmodule
