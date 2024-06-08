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

    always_latch begin
        if (reset) begin
            r_data = 32'b0;
        end else begin
            logic [63:0] data;
            mm_read(expanded_addr, data);
            assign r_data = data[31:0];
        end
        err = 1'b0;
    end

    always @(posedge clk) begin
        if (write_enabled) begin
            logic [63:0] expanded_w_data = {32'b0, w_data};;
            mm_write(expanded_addr, expanded_w_data);
        end
    end

endmodule
