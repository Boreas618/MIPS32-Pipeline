module WriteBack(
    input   logic   rst,
    input   logic   clk,
    input   logic   reg_write_m,
    input   logic   mem_to_reg_m,
    input   logic   [31:0] alu_out_m,
    input   logic   [31:0] read_data_m,
    input   logic   [4:0] write_reg_m,
    output  logic   [31:0] result_w,
    output  logic   [4:0] write_reg_w,
    output  logic   reg_write_w
);
    logic   mem_to_reg_w;
    logic   [31:0] read_data_w;

    always_ff @(posedge clk, negedge rst) begin
        if (rst) begin
            reg_write_w <= 1'b0;
            mem_to_reg_w <= 1'b0;
            read_data_w <= 32'b0;
            write_reg_w <= 5'b0;
            result_w <= 32'b0;
        end else begin
            reg_write_w <= reg_write_m;
            mem_to_reg_w <= mem_to_reg_m;
            read_data_w <= read_data_m;
            write_reg_w <= write_reg_m;
            result_w <= mem_to_reg_w ? read_data_w : alu_out_m;
        end
    end
endmodule
