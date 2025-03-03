`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Target Device:  
// Tool versions:  
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb;

    reg   [12:0] alu_control;
    reg   [31:0] alu_src1;   
    reg   [31:0] alu_src2;   
    wire  [31:0] alu_result; 
//    wire  [63:0] alu_mul_result; 
    reg clk;
    alu alu_module(
        .clk(clk),
        .alu_control(alu_control),
        .alu_src1   (alu_src1   ),
        .alu_src2   (alu_src2   ),
        .alu_result (alu_result )
//        .alu_mul_result (alu_mul_result )
    );
    
    initial begin
        clk=0;
    end
    always begin
        #5 clk = ~clk;  // 每隔5个时间单位反转一次clk
    end
    initial begin
        //鍔犳硶鎿嶄綔
        alu_control = 13'h1000;
        alu_src1 = 32'd5;
        alu_src2 = 32'd6;
        #50
        alu_control = 13'h000;
        alu_src1 = 32'd0;
        alu_src2 = 32'd0;
        #50
        alu_control = 13'h1000;
        alu_src1 = 32'd9;
        alu_src2 = 32'd8;
        #50
        alu_control = 13'h000;
        alu_src1 = 32'd0;
        alu_src2 = 32'd0;

//        alu_control = 12'h800;
//        alu_src1 = 32'd5;
//        alu_src2 = 32'd6;

//        #5;
//        alu_control = 12'h800;
//        alu_src1 = 32'd7;
//        alu_src2 = 32'd9;
        
//        #5;
//        alu_control = 12'h400;
//        alu_src1 = 32'd7;
//        alu_src2 = 32'd9;
        
//        #5;
//        alu_control = 12'h400;
//        alu_src1 = 32'd16;
//        alu_src2 = 32'd9;
        
//        #5;
//        alu_control = 12'h200;
//        alu_src1 = 32'd7;
//        alu_src2 = 32'd3;
        
//        #5;
//        alu_control = 12'h200;
//        alu_src1 = 32'd1;
//        alu_src2 = 32'd3;
        
//        #5;
//        alu_control = 12'h200;
//        alu_src1 = 32'hffff_fffe;
//        alu_src2 = 32'd3;
        
//        #5;
//        alu_control = 12'h200;
//        alu_src1 = 32'd6;
//        alu_src2 = 32'hffff_ffff;
        
//        #5;
//        alu_control = 12'h200;
//        alu_src1 = 32'hffff_fffe;
//        alu_src2 = 32'hffff_ffff;
        
//        #5;
//        alu_control = 12'h100;
//        alu_src1 = 32'h5;
//        alu_src2 = 32'hf000_0000;
        
//        #5;
//        alu_control = 12'h100;
//        alu_src1 = 32'hf000_0011;
//        alu_src2 = 32'h3;
        
//        #5;
//        alu_control = 12'h80;
//        alu_src1 = 32'hf;
//        alu_src2 = 32'h92;

//        #5;
//        alu_control = 12'h80;
//        alu_src1 = 32'hf0f;
//        alu_src2 = 32'hfff1;
        
//        #5;
//        alu_control = 12'h40;
//        alu_src1 = 32'hf0f;
//        alu_src2 = 32'hfff1;
        
//        #5;
//        alu_control = 12'h40;
//        alu_src1 = 32'hf0f0;
//        alu_src2 = 32'hf0f0_0000;
        
//        #5;
//        alu_control = 12'h20;
//        alu_src1 = 32'hf0f0;
//        alu_src2 = 32'hf0f0_0000;
        
//        #5;
//        alu_control = 12'h20;
//        alu_src1 = 32'h1010;
//        alu_src2 = 32'h101;
        
//        #5;
//        alu_control = 12'h10;
//        alu_src1 = 32'h1010;
//        alu_src2 = 32'h101;
        
//        #5;
//        alu_control = 12'h10;
//        alu_src1 = 32'h1101;
//        alu_src2 = 32'h1100;
        
//        #5;
//        alu_control = 12'h8;
//        alu_src1 = 32'h1;
//        alu_src2 = 32'h10;
        
//        #5;
//        alu_control = 12'h8;
//        alu_src1 = 32'h8;
//        alu_src2 = 32'hf0f0;
        
//        #5;
//        alu_control = 12'h4;
//        alu_src1 = 32'h8;
//        alu_src2 = 32'hf0f0;
        
//        #5;
//        alu_control = 12'h4;
//        alu_src1 = 32'h10;
//        alu_src2 = 32'hffff_ffff;
        
//        #5;
//        alu_control = 12'h2;
//        alu_src1 = 32'h10;
//        alu_src2 = 32'hfa44_6569;
        
//        #5;
//        alu_control = 12'h2;
//        alu_src1 = 32'h10;
//        alu_src2 = 32'h12565665;
        
//        #5;
//        alu_control = 12'h1;
//        alu_src1 = 32'h56515016;
//        alu_src2 = 32'hb61ab255;
        
//        #5;
//        alu_control = 12'h1;
//        alu_src1 = 32'h56515016;
//        alu_src2 = 32'h6551a9a0;
        
//        #5;
//        alu_control = 12'h0;
//        alu_src1 = 32'h56515006;
//        alu_src2 = 32'h6550a9a0;
        
        //鍑忔硶鎿嶄綔
//        #5;
//        alu_control = 13'b00100_0000_0000;
//        alu_src1 = 32'd1;
//        alu_src2 = 32'd2;
        
//        //鏈夌鍙锋瘮杈?
//        #5;
//        alu_control = 13'b00010_0000_0000;
//        alu_src1 = 32'd1;
//        alu_src2 = 32'd2;
        
//        //鏃犵鍙锋瘮杈?
//        #5;
//        alu_control = 13'b00001_0000_0000;
//        alu_src1 = 32'd1;
//        alu_src2 = 32'd2;
        
//        //鎸変綅涓?
//        #5;
//        alu_control = 13'b00000_1000_0000;
//        alu_src1 = 32'h12345678;
//        alu_src2 = 32'hf0f0f0f0;
        
//        //鎸変綅鎴栭潪
//        #5;
//        alu_control = 13'b00000_0100_0000;
//        alu_src1 = 32'he;
//        alu_src2 = 32'd1;

//        //鎸変綅鎴?
//        #5;
//        alu_control = 13'b00000_0010_0000;
//        alu_src1 = 32'he;
//        alu_src2 = 32'd1;
        
//        //鎸変綅寮傛垨
//        #5;
//        alu_control = 13'b00000_0001_0000;
//        alu_src1 = 32'b1010;
//        alu_src2 = 32'b0101;
        
//        //閫昏緫宸︾Щ
//        #5;
//        alu_control = 13'b00000_0000_1000;
//        alu_src1 = 32'd4;
//        alu_src2 = 32'hf;
        
//        //閫昏緫鍙崇Щ
//        #5;
//        alu_control = 13'b00000_0000_0100;
//        alu_src1 = 32'd4;
//        alu_src2 = 32'hf0;

//        //绠楁湳鍙崇Щ        
//        #5;
//        alu_control = 13'b00000_0000_0010;
//        alu_src1 = 32'd4;
//        alu_src2 = 32'hf0000000;

//        //楂樹綅鍔犺浇    
//        #5;
//        alu_control = 13'b00000_0000_0001;
//        alu_src2 = 32'hbfc0;
//        #5;
//        alu_control = 13'b10000_0000_0000;
//        alu_src1 = 32'd4;
//        alu_src2 = 32'd5;
//        #5;
//        alu_control = 13'b10000_0000_0000;
//        alu_src1 = 32'd6;
//        alu_src2 = 32'd5;
    end
endmodule

