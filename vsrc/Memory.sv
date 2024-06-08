/* verilator lint_off UNUSEDSIGNAL */

module Memory(
    input   logic   clk,
    input   logic   rst,
    input   logic   reg_write_e,
    input   logic   mem_to_reg_e,
    input   logic   mem_write_e,
    input   logic   branch_e,
    input   logic   [31:0] alu_out_e,
    input   logic   [31:0] write_data_e,
    input   logic   [4:0] write_reg_e,
    input   logic   zero_e,
    output  logic   [31:0] read_data_m,
    output  logic   [31:0] alu_out_m,
    output  logic   [4:0] write_reg_m,
    output  logic   reg_write_m,
    output  logic   mem_to_reg_m
);
    logic zero_m;
    logic [31:0] write_data_m;
    logic mem_write_m;
    logic branch_m;
    logic err;

    assign reg_write_m = reg_write_e;
    assign mem_to_reg_m = mem_to_reg_e;
    assign mem_write_m = mem_write_e;
    assign branch_m = branch_e;
    assign alu_out_m = alu_out_e;
    assign write_data_m = write_data_e;
    assign write_reg_m = write_reg_e;
    assign zero_m = zero_e;

    DataMemory data_memory(
        .reset(rst),
        .clk(clk),
        .write_enabled(mem_write_m),
        .addr(alu_out_m),
        .w_data(write_data_m),
        .err(err),
        .r_data(read_data_m)
    );

endmodule
