
//*************************************************************************
//   > 文件名: divider.v
//   > 描述  ：32位有符号补码除法器（非恢复余数法）
//   > 作者  ：LOONGSON
//   > 日期  ：2023-10-01
//*************************************************************************
module divider (
    input         clk,          // 时钟
    input         resetn,       // 低电平复位
    input         div_start,    // 除法启动信号（高电平有效）
    input  [31:0] dividend,     // 被除数（补码）
    input  [31:0] divisor,      // 除数（补码）
    output [31:0] quotient,     // 商（补码）
    output [31:0] remainder,    // 余数（补码）
    output        div_ready,    // 除法完成信号（高电平有效）
    output        div_error     // 除数为0错误（高电平有效）
);

    //---------------------{ 状态机定义 }---------------------
    localparam IDLE   = 2'b00;  // 空闲状态
    localparam CALC   = 2'b01;  // 计算状态
    localparam ADJUST = 2'b10;  // 调整余数状态
    reg [1:0] state;

    //---------------------{ 内部寄存器 }---------------------
    reg [63:0] reg_remainder;  // 余数寄存器（64位，高位为符号扩展）
    reg [31:0] reg_quotient;   // 商寄存器
    reg [5:0]  counter;        // 迭代计数器（32次迭代）
    reg        dividend_sign;  // 被除数符号
    reg        divisor_sign;   // 除数符号

    //---------------------{ 初始化与复位 }---------------------
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state          <= IDLE;
            reg_remainder  <= 64'd0;
            reg_quotient   <= 32'd0;
            counter        <= 6'd0;
            dividend_sign  <= 1'b0;
            divisor_sign   <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (div_start) begin
                        // 检测除数为0错误
                        if (divisor == 32'd0) begin
                            state <= IDLE;
                        end else begin
                            // 保存符号并转换为绝对值
                            dividend_sign <= dividend[31];
                            divisor_sign  <= divisor[31];
                            reg_remainder <= {32'd0, (dividend[31] ? -dividend : dividend)};
                            reg_quotient  <= 32'd0;
                            counter       <= 6'd0;
                            state         <= CALC;
                        end
                    end
                end

                CALC: begin
                    if (counter < 6'd32) begin
                        // 左移余数和商
                        reg_remainder <= reg_remainder << 1;
                        reg_quotient  <= reg_quotient << 1;

                        // 计算当前余数
                        if (reg_remainder[63]) begin
                            // 余数为负，执行加法
                            reg_remainder <= (reg_remainder << 1) + {divisor[31] ? -divisor : divisor, 32'd0};
                        end else begin
                            // 余数为正，执行减法
                            reg_remainder <= (reg_remainder << 1) - {divisor[31] ? -divisor : divisor, 32'd0};
                        end

                        // 设置商位
                        reg_quotient[0] <= ~reg_remainder[63];
                        counter <= counter + 1;
                    end else begin
                        state <= ADJUST;
                    end
                end

                ADJUST: begin
                    // 调整余数的符号
                    if (reg_remainder[63]) begin
                        reg_remainder <= reg_remainder + {divisor[31] ? -divisor : divisor, 32'd0};
                    end

                    // 调整商的符号
                    reg_quotient <= (dividend_sign ^ divisor_sign) ? -reg_quotient : reg_quotient;

                    // 调整余数的符号（余数符号与被除数一致）
                    reg_remainder[63:32] <= dividend_sign ? -reg_remainder[63:32] : reg_remainder[63:32];
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

    //---------------------{ 输出逻辑 }---------------------
    assign quotient   = (state == IDLE) ? reg_quotient : 32'd0;
    assign remainder  = (state == IDLE) ? reg_remainder[63:32] : 32'd0;
    assign div_ready  = (state == IDLE);
    assign div_error  = (divisor == 32'd0) && div_start;

endmodule