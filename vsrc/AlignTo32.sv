module AlignTo32 #(parameter WIDTH = 32) (
    input   logic [WIDTH-1:0] in,
    output  logic [31:0] out
);
    always_comb begin
        if (WIDTH <= 32) begin
            out = { {(32-WIDTH){1'b0}}, in };
        end
    end
endmodule
