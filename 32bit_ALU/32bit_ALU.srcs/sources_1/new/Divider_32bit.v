`timescale 1ns / 1ps

module Divider_32bit (
    input  [31:0] dividend,
    input  [31:0] divisor,
    output [31:0] quotient
);
    integer i;
    reg [31:0] q;
    reg [32:0] r;
    
    always @(*) begin
        q = 32'd0;
        r = 33'd0;
        // 从最高位开始迭代，实现恢复型除法
        for(i = 31; i >= 0; i = i - 1) begin
            r = {r[31:0], dividend[i]};
            if (r >= {1'b0, divisor}) begin
                r = r - {1'b0, divisor};
                q[i] = 1'b1;
            end
            else begin
                q[i] = 1'b0;
            end
        end
    end

    assign quotient = q;
endmodule