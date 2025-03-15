`timescale 1ns / 1ps

module test_alu();
    // 输入信号
    reg [31:0] a;       // 操作数 a
    reg [31:0] b;       // 操作数 b
    reg CI;             // 进位输入
    reg [3:0] F;        // 功能选择信号
    reg [1:0] dir;      // 移位方向
    reg [4:0] bite;     // 移位位数

    // 输出信号
    wire [31:0] S;      // 运算结果
    wire CO;            // 进位输出

    // 实例化被测试模块
    ALU_32bit uut (
        .a(a),
        .b(b),
        .CI(CI),
        .F(F),
        .dir(dir),
        .bite(bite),
        .S(S),
        .CO(CO)
    );

    // 初始化测试
    initial begin
        // 初始化输入信号
        a = 32'd0;      // 32 位宽，十进制 0
        b = 32'd0;      // 32 位宽，十进制 0
        CI = 1'b0;      // 1 位宽，二进制 0
        F = 4'b0000;    // 4 位宽，二进制 0000
        dir = 2'b00;    // 2 位宽，二进制 00
        bite = 5'b00000; // 5 位宽，二进制 00000

        // 测试功能码 F=0000：恒定输出 1
        #10;
        F = 4'b0000;
        a = 32'd0;
        b = 32'd0;
        #10;
        $display("F=0000: S=%b (Expected: 32'b1)", S);

        // 测试功能码 F=0001：加法
        #10;
        F = 4'b0001;
        a = 32'd15;
        b = 32'd10;
        CI = 1'b0;
        #10;
        $display("F=0001: S=%d (Expected: 25)", S);

        // 测试功能码 F=0010：移位
        #10;
        F = 4'b0010;
        a = 32'b10101010;
        dir = 2'b01; // 循环左移
        bite = 5'd3; // 左移 3 位
        #10;
        $display("F=0010: S=%b (Expected: 32'b01010101)", S);

        // 测试功能码 F=0011：截取
        #10;
        F = 4'b0011;
        a = 32'b11110000;
        bite = 5'd4;
        #10;
        $display("F=0011: S=%b (Expected: 32'b00001111)", S);

        // 测试功能码 F=0100：与操作
        #10;
        F = 4'b0100;
        a = 32'b1100;
        b = 32'b1010;
        #10;
        $display("F=0100: S=%b (Expected: 32'b1000)", S);

        // 测试功能码 F=0101：或操作
        #10;
        F = 4'b0101;
        a = 32'b1100;
        b = 32'b1010;
        #10;
        $display("F=0101: S=%b (Expected: 32'b1110)", S);

        // 测试功能码 F=0110：非操作
        #10;
        F = 4'b0110;
        a = 32'b1100;
        #10;
        $display("F=0110: S=%b (Expected: 32'b0011)", S);

        // 测试功能码 F=0111：异或操作
        #10;
        F = 4'b0111;
        a = 32'b1100;
        b = 32'b1010;
        #10;
        $display("F=0111: S=%b (Expected: 32'b0110)", S);

        // 测试功能码 F=1000：有符号比较
        #10;
        F = 4'b1000;
        a = 32'd5;
        b = -32'd3;
        #10;
        $display("F=1000: S=%b (Expected: 32'b1 if a < b)", S);

        // 测试功能码 F=1001：无符号比较
        #10;
        F = 4'b1001;
        a = 32'd5;
        b = 32'd10;
        #10;
        $display("F=1001: S=%b (Expected: 32'b1 if a < b)", S);

        // 测试功能码 F=1010：乘法
        #10;
        F = 4'b1010;
        a = 32'd3;
        b = 32'd4;
        #10;
        $display("F=1010: S=%d (Expected: 12)", S);

        // 测试功能码 F=1011：除法
        #10;
        F = 4'b1011;
        a = 32'd8;
        b = 32'd2;
        #10;
        $display("F=1011: S=%d (Expected: 4)", S);

        // 测试功能码 F=1100：减法
        #10;
        F = 4'b1100;
        a = 32'd20;
        b = 32'd10;
        #10;
        $display("F=1100: S=%d (Expected: 10)", S);
        // 测试功能码 F=1111：未定义
        #10;
        F = 4'b1111;
        a = 32'd0;
        b = 32'd0;
        #10;
        $display("F=1111: S=%b (Undefined behavior)", S);

        // 测试结束
        $display("Simulation finished.");
        $finish;
    end
endmodule