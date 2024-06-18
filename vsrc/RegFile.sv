/* verilator lint_off WIDTHTRUNC */
module RegFile(
    input   logic   rst,
    input   logic   clk,
    input   logic   [4:0]read_addr_1,
    input   logic   [4:0]read_addr_2,
    input   logic   [4:0]write_addr,
    input   logic   [31:0]write_data,
    input   logic   write_enabled,
    output  logic   [31:0]data_1,
    output  logic   [31:0]data_2
);
    import "DPI-C" function void set_regs_ptr(input logic[31:0] r[]);
    initial begin set_regs_ptr(regs); end

    /* 32 General Purpose Regsiters. */
    logic [31:0] regs[31:0];
    integer i;
    always_ff @(posedge clk) begin
        if (rst) begin
            for (i = 0; i <= 31; i = i + 1) begin
                if (i == 32'd29) begin
                    regs[i] <= 32'h8000;
                end else if (i == 32'd31) begin
                    regs[i] <= 32'h9080;
                end else begin
                    regs[i] <= 32'b0;
                end
            end
        end
    end

    always_ff @(posedge clk) begin
        if (write_enabled && write_addr == read_addr_1) begin
            data_1 <= write_data;
        end else begin
            data_1 <= regs[read_addr_1];
        end

        if (write_enabled && write_addr == read_addr_2) begin
            data_2 <= write_data;
        end else begin
            data_2 <= regs[read_addr_2];
        end
    end

    always_ff @(posedge clk) begin
        if (write_enabled) begin
            regs[write_addr] <= write_data;
        end
    end
endmodule
