module SimulatedMemory(
    input reset,
    input clk,
    input write_enabled,
    input [31:0] addr,
    input [31:0] w_data,
    output reg err,
    output reg [31:0] r_data
);

    import "DPI-C" function void mm_read(
        input longint addr,
        output longint data
    );

    import "DPI-C" function void mm_write(
        input longint addr,
        input longint data
    );

    // Write to memory.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_data <= 32'b0;
            err <= 1'b0;
        end else if (write_enabled) begin
            mm_write(addr, w_data);
            err <= 1'b0;
        end
    end

    // Read from memory.
    always @(*) begin
        if (!write_enabled) begin
            mm_read(addr, r_data);
        end else begin
            r_data = 32'b0;
        end
    end

endmodule