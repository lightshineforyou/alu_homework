`timescale 1ns / 1ps

module tb();

    reg clk;
    reg resetn;
    reg [14:0] alu_control;
    reg [31:0] alu_src1;
    reg [31:0] alu_src2;
    wire [31:0] alu_result;
    wire [63:0] mul_result;
    wire [31:0] quotient;

    alu alu_module (
        .clk(clk),
        .resetn(resetn),
        .alu_control(alu_control),
        .alu_src1(alu_src1),
        .alu_src2(alu_src2),
        .alu_result(alu_result),
        .mul_result(mul_result),
        .quotient(quotient)
    );

    initial begin
        clk = 0;
        resetn = 0;
        #10 resetn = 1;
    end

    always #5 clk = ~clk;

    initial begin
        // ????
        alu_control = 15'b0000_1000_0000_000;
        alu_src1 = 32'd10;
        alu_src2 = 32'd20;
        #20;

        // ????
        alu_control = 15'b0000_0100_0000_000;
        alu_src1 = 32'd30;
        alu_src2 = 32'd10;
        #20;

        // ????
        alu_control = 15'b0001_0000_0000_000;
        alu_src1 = 32'd5;
        alu_src2 = 32'd6;
        #20;

        // ????
        alu_control = 15'b0010_0000_0000_000;
        alu_src1 = 32'd20;
        alu_src2 = 32'd4;
        #20;

        // ?????
        alu_control = 15'b0000_0000_1000_000;
        alu_src1 = 32'hFF00FF00;
        alu_src2 = 32'h00FF00FF;
        #20;

        // ?????
        alu_control = 15'b0000_0000_0100_000;
        alu_src1 = 32'hFF00FF00;
        alu_src2 = 32'h00FF00FF;
        #20;

        // ??????
        alu_control = 15'b0000_0000_0010_000;
        alu_src1 = 32'hFF00FF00;
        alu_src2 = 32'h00FF00FF;
        #20;

        // ??????
        alu_control = 15'b0000_0000_0001_000;
        alu_src1 = 32'd1;
        alu_src2 = 32'd2;
        #20;

        // ??????
        alu_control = 15'b0000_0000_0000_100;
        alu_src1 = 32'd4;
        alu_src2 = 32'd1;
        #20;

        // ??????
        alu_control = 15'b0000_0000_0000_010;
        alu_src1 = 32'd8;
        alu_src2 = 32'd1;
        #20;

        // ??????
        alu_control = 15'b0000_0000_0000_001;
        alu_src1 = 32'd0;
        alu_src2 = 32'h1234;
        #20;

        $stop;
    end
endmodule

