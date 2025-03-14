`timescale 1ns / 1ps

module test_alu();
    reg [31:0] a;
    reg [31:0] b;
    reg CI;
    reg [3:0] F;
    reg [1:0] dir;
    reg [4:0] bite;
    wire [31:0] S;
    wire CO;
    ALU_32bit uut(a,b,CI,F,dir,bite,S,CO);
    initial begin
       
         ///有符号比较,325ns
        a=32'b01111111; // 正数
        b=32'b11111111; // 负数
        F=4'b1000;
        dir=0;
        bite=0;
        #25;

        ///无符号比较,350ns
        a=32'b01111111;
        b=32'b11111111;
        F=4'b1001;
        dir=0;
        bite=0;
        #25;
         ///乘法,375ns
        a=32'd1;
        b=32'd2;
        F=4'b1010;
        dir=0;
        bite=0;
        #25;

        ///除法,400ns
        a=32'd1;
        b=32'd1;
        F=4'b1011;
        dir=0;
        bite=0;
        #25;
        end
endmodule
