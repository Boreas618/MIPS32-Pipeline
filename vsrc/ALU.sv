module ALU (
    input   logic   [ 3:0]  alu_ctrl,
    input   logic   [31:0]  src1,
    input   logic   [31:0]  src2,
    output  logic   [31:0]  out
);
    always_comb begin
        case(alu_ctrl)
            4'b0000: out = src1 + src2;
            4'b0001: out = src1 - src2;
            4'b0010: out = src1 & src2;
            4'b0011: out = src1 | src2;
            4'b0100: out = ~ (src1 | src2);
            4'b0101: out = src1 ^ src2;        
            4'b0110: out = src2 << src1;
            4'b0111: out = $signed(src2) >>> src1;
            4'b1000: out = src2 >> src1;
            4'b1001: out = {31'b0, $signed(src1) < $signed(src2)};
            4'b1010: out = {31'b0, src1 < src2};
            4'b1111: out = src2;
            default: out = 32'b0;
        endcase
    end
endmodule
