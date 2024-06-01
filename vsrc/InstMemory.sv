module InstMemory(
    input   logic   reset,
    input   logic   [63:0] addr,
    output  logic   err,
    output  logic   [63:0] r_data
);

    import "DPI-C" function void mm_read(
        input longint addr,
        output longint data
    );

    always_latch begin
        if (reset) begin
            r_data = 64'b0;
        end else begin
            logic [63:0] data;
            mm_read(addr, data);
            r_data = data;
        end
        err = 1'b0;
    end

endmodule
