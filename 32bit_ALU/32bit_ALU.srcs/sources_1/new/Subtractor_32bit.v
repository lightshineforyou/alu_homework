module Subtractor_32bit (
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);
    wire [31:0] b_complement;
    wire CO;

    // 取b的二进制补码
    assign b_complement = ~b + 1;

    // 使用加法器实现减法
    CLA_Add_32bit adder (
        .A(a),
        .B(b_complement),
        .CI_0(1'b0),
        .S(result),
        .CO(CO)
    );
endmodule