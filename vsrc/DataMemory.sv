/* verilator lint_off UNUSEDSIGNAL */
module DataMemory(
    input   logic   reset,
    input   logic   clk,

    /* Signals for memory access results. */
    input   logic   valid,
    input   logic   [31:0] addr,
    input   logic   write_enabled,
    input   logic   [31:0] w_data,

    /* Signals for memory access responses. */
    output  logic   [31:0] r_data,
    output  logic   [1:0] status
);

    parameter latency_cycles = 1;
    logic [7:0] cycle_counter;

    import "DPI-C" function void mm_read(
        input longint addr,
        output longint data
    );

    import "DPI-C" function void mm_write(
        input longint addr,
        input longint data
    );

    logic [63:0] expanded_addr = {32'b0, addr};

    always_ff @(posedge clk) begin
        if (reset) begin
            status <= 2'b0;
            cycle_counter <= 8'b0;
        end else begin
            if (status == 2'b0) begin
                status <= 2'b1;
                cycle_counter <= 8'b1;
            end else if (status == 2'b1) begin
                if (cycle_counter == latency_cycles) begin
                    if (write_enabled) begin
                        logic [63:0] expanded_w_data = {32'b0, w_data};
                        mm_write(expanded_addr, expanded_w_data);
                    end else begin
                        logic [31:0] dummy_data;
                        mm_read(expanded_addr, {dummy_data, r_data});
                    end
                    status <= 2'b10;
                    cycle_counter <= 8'b0;
                end else begin
                    cycle_counter <= cycle_counter + 1;
                end
            end else begin
                status <= 2'b0;
                cycle_counter <= 8'b0;
            end
        end
    end

endmodule
