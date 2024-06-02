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

    logic expanded_addr = {32'b0, addr};

    // Why do we need to use `always_latch` here?
    always_latch @(*) begin
        if (reset) begin
            assign r_data = 32'b0;
        end else if (!write_enabled) begin
            logic [63:0] data;
            mm_read(expanded_addr, data);
            assign r_data = data[31:0];
        end
        assign err = 1'b0;
    end

    always @(posedge clk) begin
        if (write_enabled) begin
            logic [63:0] expanded_w_data;
            mm_write(expanded_addr, expanded_w_data);
            assign w_data = expanded_w_data[31:0];
        end
    end

endmodule
