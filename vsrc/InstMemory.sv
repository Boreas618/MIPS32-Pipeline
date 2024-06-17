/* verilator lint_off UNUSEDSIGNAL */
module InstMemory(
    input   logic   clk,
    input   logic   rst,
    input   logic   stall,

    /* Signals for memory access requests. */
    input   logic   [31:0] addr,

    /* Signals for memory access responses. */
    output  logic   [31:0] r_data,
    output  logic   [1:0] r_data_status
);

    /* 
     * Note that these constructs are used for simulating the memory
     * access latencies.
     */
    parameter latency_cycles = 1;
    logic [7:0] cycle_counter;

    import "DPI-C" function void mm_read(
        input longint addr,
        output longint data
    );

    logic [63:0] expanded_addr = {32'b0, addr};

    always_ff @(posedge clk) begin
        if (rst || stall) begin
            r_data_status <= 2'b0;
            cycle_counter <= 8'b0;
            r_data <= 32'b0;
        end else begin
            if (r_data_status == 2'b0) begin
                r_data_status <= 2'b1;
                cycle_counter <= 8'b0;
                r_data <= 32'b0;
            end else if (r_data_status == 2'b1) begin
                if (cycle_counter == latency_cycles) begin
                    logic [63:0] data;
                    mm_read(expanded_addr, data);
                    r_data <= data[31:0];
                    r_data_status <= 2'b10;
                    cycle_counter <= 8'b0;
                end else begin
                    cycle_counter <= cycle_counter + 1;
                end
            end else begin
                r_data_status <= 2'b0;
                cycle_counter <= 8'b0;
                r_data <= 32'b0;
            end
        end
    end

endmodule
