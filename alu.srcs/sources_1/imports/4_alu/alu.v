`timescale 1ns / 1ps
`include "../2_multiply/multiply.v"
`include "../32bit_adder/32bit_adder.v"
`include "../divider/divider.v"

module alu(
    // 新增输出
    output [63:0] mul_result,  // 完整64位乘法结果
    output [31:0] quotient,    // 除法商
    // 原有端口保持不变
    
    input  clk,
    input  resetn,  // 新增复位信号
    input  [14:0] alu_control,  // ALU控制信号
    input  [31:0] alu_src1,     // ALU操作数1,为补码
    input  [31:0] alu_src2,     // ALU操作数2，为补码
    output [31:0] alu_result,    // ALU结果
    output [63:0] mul_result,  // 新增输出
    output [31:0] quotient     // 新增输出
);
    // ALU控制信号，独热码
    wire alu_div;   //除法操作
    wire alu_mul;   //乘法操作
    wire alu_add;   //加法操作
    wire alu_sub;   //减法操作
    wire alu_slt;   //有符号比较，小于置位，复用加法器做减法
    wire alu_sltu;  //无符号比较，小于置位，复用加法器做减法
    wire alu_and;   //按位与
    wire alu_nor;   //按位或非
    wire alu_or;    //按位或
    wire alu_xor;   //按位异或
    wire alu_sll;   //逻辑左移
    wire alu_srl;   //逻辑右移
    wire alu_sra;   //算术右移
    wire alu_lui;   //高位加载

    assign alu_div  = alu_control[13];
    assign alu_mul  = alu_control[12];
    assign alu_add  = alu_control[11];
    assign alu_sub  = alu_control[10];
    assign alu_slt  = alu_control[ 9];
    assign alu_sltu = alu_control[ 8];
    assign alu_and  = alu_control[ 7];
    assign alu_nor  = alu_control[ 6];
    assign alu_or   = alu_control[ 5];
    assign alu_xor  = alu_control[ 4];
    assign alu_sll  = alu_control[ 3];
    assign alu_srl  = alu_control[ 2];
    assign alu_sra  = alu_control[ 1];
    assign alu_lui  = alu_control[ 0];
    
    wire [31:0] div_result;
    wire [63:0] mul_result;
    wire [31:0] add_sub_result;
    wire [31:0] slt_result;
    wire [31:0] sltu_result;
    wire [31:0] and_result;
    wire [31:0] nor_result;
    wire [31:0] or_result;
    wire [31:0] xor_result;
    wire [31:0] sll_result;
    wire [31:0] srl_result;
    wire [31:0] sra_result;
    wire [31:0] lui_result;

    assign and_result = alu_src1 & alu_src2;      // 与结果为两数按位与
    assign or_result  = alu_src1 | alu_src2;      // 或结果为两数按位或
    assign nor_result = ~or_result;               // 或非结果为或结果按位取反
    assign xor_result = alu_src1 ^ alu_src2;      // 异或结果为两数按位异或
    assign lui_result = {alu_src2[15:0], 16'd0};  // 立即数装载结果为立即数移位至高半字节

    wire mult_end;
    multiply mul(              // 乘法器
        .clk(clk),        // 时钟
        .mult_begin(alu_mul), // 乘法开始信号
        .mult_op1(alu_src1),   // 乘法源操作数1
        .mult_op2(alu_src2),   // 乘法源操作数2
        .product(mul_result),    // 乘积
        .mult_end(mult_end)    // 乘法结束信号
    );

    // 除法启动信号
    reg div_start;
    always @(posedge clk) begin
        div_start <= alu_div;  // 当 alu_div 为高电平时启动除法
    end

    // 实例化除法模块
    wire [31:0] quotient, remainder;
    wire div_ready, div_error;
    divider u_divider (
        .clk(clk),
        .resetn(resetn),
        .div_start(div_start),
        .dividend(alu_src1),
        .divisor(alu_src2),
        .quotient(quotient),
        .remainder(remainder),
        .div_ready(div_ready),
        .div_error(div_error)
    );

    // 调用 32 位加法器
    wire CO;  // 进位输出
    CLA_Add_32bit cla_adder (
        .A(alu_src1),
        .B(alu_src2),
        .CI_0(alu_add ? 1'b0 : 1'b1),  // 加法或减法选择
        .S(add_sub_result),
        .CO(CO)
    );

    // slt 结果
    assign slt_result[31:1] = 31'd0;
    assign slt_result[0]    = (alu_src1[31] & ~alu_src2[31]) | (~(alu_src1[31]^alu_src2[31]) & add_sub_result[31]);

    // sltu 结果
    assign sltu_result = {31'd0, ~CO};

    // 移位操作
    wire [4:0] shf = alu_src1[4:0];
    assign sll_result = alu_src2 << shf;
    assign srl_result = alu_src2 >> shf;
    assign sra_result = $signed(alu_src2) >>> shf;

    // 选择相应结果输出
    assign alu_result = (alu_mul & mult_end) ? mul_result[31:0] : 
                        (alu_add | alu_sub) ? add_sub_result[31:0] : 
                        alu_slt             ? slt_result :
                        alu_sltu            ? sltu_result :
                        alu_and             ? and_result :
                        alu_nor             ? nor_result :
                        alu_or              ? or_result  :
                        alu_xor             ? xor_result :
                        alu_sll             ? sll_result :
                        alu_srl             ? srl_result :
                        alu_sra             ? sra_result :
                        alu_lui             ? lui_result :
                        alu_div             ? quotient :  // 除法结果
                        32'd0;
endmodule