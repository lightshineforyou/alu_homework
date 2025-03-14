`timescale 1ns / 1ps

module BoothMul_32bit (
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] product
);
    reg [31:0] product_reg;
    integer i;
    // A: accumulator，33位（带符号扩展）  
    // M: 乘数a扩展为33位  
    // Q: 被乘数  
    reg signed [32:0] A;
    reg signed [32:0] M;
    reg [31:0] Q;
    // Q_1：扩展位
    reg Q_1;
    // 组合拼接 {A, Q, Q_1} 共66位
    reg [65:0] combined;

    always @(*) begin
        A   = 33'd0;
        M   = {a[31], a}; // 有符号扩展，最高位复制
        Q   = b;
        Q_1 = 1'b0;
        // 进行32轮高级Booth迭代
        for (i = 0; i < 32; i = i + 1) begin
            // 根据 Q[0] 与 Q_1 的值决定加减 M
            if ({Q[0], Q_1} == 2'b01)
                A = A + M;
            else if ({Q[0], Q_1} == 2'b10)
                A = A - M;
            // 将 {A, Q, Q_1} 作为66位寄存器进行算数右移
            combined = {A, Q, Q_1};
            combined = {combined[65], combined[65:1]};  // 算数右移1位
            {A, Q, Q_1} = combined;
        end
        // 取结果低32位（与 a*b 语义保持一致，即截取低位）
        product_reg = Q;
    end

    assign product = product_reg;
endmodule