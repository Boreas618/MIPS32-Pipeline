module WriteBack(
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
    logic   [31:0] alu_out_w;
    logic   [31:0] read_data_w;

    assign reg_write_w = reg_write_m;
    assign mem_to_reg_w = mem_to_reg_m;
    assign alu_out_w = alu_out_m;
    assign read_data_w = read_data_m;
    assign write_reg_w = write_reg_m;

    assign result_w = mem_to_reg_w ? read_data_w : alu_out_w;
    
endmodule
