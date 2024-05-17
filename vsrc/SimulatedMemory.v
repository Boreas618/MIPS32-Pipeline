module SimulatedMemory(
    input reset,
    input clk,
    input write_enabled,
    input [63:0] addr,
    input [63:0] w_data,
    output reg err,
    output reg [63:0] r_data
);

    import "DPI-C" function void mm_read(
        input longint addr,
        output longint data
    );

    import "DPI-C" function void mm_write(
        input longint addr,
        input longint data
    );

    // Why do we need to use `always_latch` here?
    always_latch @(*) begin
        if (reset) begin
            assign r_data = 64'b0;
        end else if (!write_enabled) begin
            reg [63:0] data;
            mm_read(addr, data);
            assign r_data = data;
        end
        assign err = 1'b0;
    end

    always @(posedge clk) begin
        if (write_enabled) begin
            mm_write(addr, w_data);
        end
    end

endmodule
