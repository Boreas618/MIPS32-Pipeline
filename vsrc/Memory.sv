/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNDRIVEN */
module Memory(
    input   logic   clk,
    input   logic   rst,
    input   logic   mem_access_e,
    input   logic   reg_write_e,
    input   logic   mem_to_reg_e,
    input   logic   mem_write_e,
    input   logic   branch_e,
    input   logic   [31:0] alu_out_e,
    input   logic   [31:0] write_data_e,
    input   logic   [4:0] write_reg_e,
    input   logic   zero_e,
    input   logic   [31:0] pc_branch_e,
    input   logic   [31:0] jump_addr_e,
    input   logic   [3:0] branch_type_e,
    output  logic   [31:0] read_data_m,
    output  logic   [31:0] alu_out_m,
    output  logic   [4:0] write_reg_m,
    output  logic   reg_write_m,
    output  logic   mem_to_reg_m,
    output  logic   [1:0] if_pc_src,
    output  logic   [31:0] if_pc_branch_in,
    output  logic   [1:0] dmem_status
);
    logic zero_m;
    logic [31:0] write_data_m;
    logic mem_write_m;
    logic branch_m;
    logic is_jump;
    logic branch_take;
    logic mem_access_m;

    always_comb begin
        is_jump = (branch_type_e == 4'b0001) || (branch_type_e == 4'b0010) || (branch_type_e == 4'b0011);
        branch_take = (branch_e) && ((zero_e && branch_type_e == 4'b0100) ||(!zero_e && branch_type_e == 4'b0101) || (($signed(alu_out_e) >= 0) && branch_type_e == 4'b0110) || (($signed(alu_out_e) < 0) && branch_type_e == 4'b0111));

        if_pc_src = (is_jump || branch_take) ? 2'b1 : 2'b0;

        if (branch_e) begin
            if (branch_take) begin
                if_pc_branch_in = pc_branch_e;
            end else if (branch_type_e == 4'b0011) begin
                if_pc_branch_in = alu_out_e;
            end else if (branch_type_e == 4'b0010 || branch_type_e == 4'b0001) begin
                if_pc_branch_in = jump_addr_e;
            end else begin
                if_pc_branch_in = 32'b0;
            end
        end else begin
            if_pc_branch_in = 32'b0;
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            reg_write_m <= 1'b0;
            mem_to_reg_m <= 1'b0;
            mem_write_m <= 1'b0;
            branch_m <= 1'b0;
            alu_out_m <= 32'b0;
            write_data_m <= 32'b0;
            write_reg_m <= 5'b0;
            zero_m <= 1'b0;
            mem_access_m <= 1'b0;
        end else begin
            reg_write_m <= reg_write_e;
            mem_to_reg_m <= mem_to_reg_e;
            mem_write_m <= mem_write_e;
            branch_m <= branch_e;
            alu_out_m <= alu_out_e;
            write_data_m <= write_data_e;
            write_reg_m <= write_reg_e;
            zero_m <= zero_e;
            mem_access_m <= mem_access_e;
        end
    end

    DataMemory data_memory(
        .reset(rst),
        .clk(clk),
        .write_enabled(mem_write_m),
        .valid(1),
        .addr(alu_out_m),
        .w_data(write_data_m),
        .r_data(read_data_m),
        .status(dmem_status)
    );

endmodule
