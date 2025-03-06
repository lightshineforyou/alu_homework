//*************************************************************************
//   > 文件名: alu_display.v
//   > 描述  ：ALU显示模块，调用FPGA板上的IO接口和触摸屏
//   > 作者  : LOONGSON
//   > 日期  : 2016-04-14
//*************************************************************************

module alu_display(
    // 时钟与复位信号
    input clk,
    input resetn,  // 低电平有效

    /*// 拨码开关，用于选择输入数
    input [1:0] input_sel, // 00: alu_control, 10: alu_src1, 11: alu_src2*/
 
    // 触摸屏输入接口
    input  [1:0]  input_sel,   // 输入选择：00=alu_control, 10=alu_src1, 11=alu_src2
    input         input_valid, // 输入有效信号
    input  [31:0] input_value, // 输入数据
    
    // 显示控制信号
    input  [5:0]  display_number, // 显示项选择


    // 触摸屏相关接口
    output lcd_rst,
    output lcd_cs,
    output lcd_rs,
    output lcd_wr,
    output lcd_rd,
    inout [15:0] lcd_data_io,
    output lcd_bl_ctr,
    inout ct_int,
    inout ct_sda,
    output ct_scl,
    output ct_rstn

    // 显示输出
    output reg        display_valid,
    output reg [39:0] display_name,  // 5字符ASCII码（每个字符8位）
    output reg [31:0] display_value
);

//-----{调用ALU模块}begin
    reg  [14:0] alu_control;  // ALU控制信号 (15位)
    reg  [31:0] alu_src1;     // ALU操作数1
    reg  [31:0] alu_src2;     // ALU操作数2
    wire [31:0] alu_result;   // ALU结果
    wire [63:0] mul_result;   // 乘法结果
    wire [31:0] quotient;     // 除法结果

    alu alu_module(
        .clk        (clk),
        .resetn     (resetn),       // 补充复位信号连接
        .alu_control(alu_control),
        .alu_src1   (alu_src1),
        .alu_src2   (alu_src2),
        .alu_result (alu_result)，
        .mul_result (mul_result),   // 连接新增输出
        .quotient   (quotient)      // 连接新增输出
    );
//-----{调用ALU模块}end

//-----{从触摸屏获取输入}begin
    
    // 输入消抖逻辑（新增）
    reg  [2:0] input_valid_sync;
    always @(posedge clk or negedge resetn) begin
        if (!resetn) 
            input_valid_sync <= 3'b0;
        else 
            input_valid_sync <= {input_valid_sync[1:0], input_valid};
    end
    wire stable_input_valid = (input_valid_sync == 3'b111); // 连续3周期有效

    /*always @(posedge clk) begin
        if (!resetn)
            alu_control <= 15'd0;
        else if (input_valid && input_sel == 2'b00)
            alu_control <= input_value[14:0];  // 控制信号宽度改为 15 位
    end

    always @(posedge clk) begin
        if (!resetn)
            alu_src1 <= 32'd0;
        else if (input_valid && input_sel == 2'b10)
            alu_src1 <= input_value;
    end

    always @(posedge clk) begin
        if (!resetn)
            alu_src2 <= 32'd0;
        else if (input_valid && input_sel == 2'b11)
            alu_src2 <= input_value;
    end*/

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            alu_control <= 15'd0;
            alu_src1    <= 32'd0;
            alu_src2    <= 32'd0;
        end else if (stable_input_valid) begin
            case(input_sel)
                2'b00: alu_control <= input_value[14:0];
                2'b10: alu_src1    <= input_value;
                2'b11: alu_src2    <= input_value;
                default: ; 
            endcase
        end
    end
//-----{从触摸屏获取输入}end

//-----{输出到触摸屏显示}begin

    localparam [39:0] DISP_NAME_SRC1  = {8'h53, 8'h52, 8'h43, 8'h5F, 8'h31}; // "SRC_1"
    localparam [39:0] DISP_NAME_SRC2  = {8'h53, 8'h52, 8'h43, 8'h5F, 8'h32}; // "SRC_2"
    localparam [39:0] DISP_NAME_CONTR = {8'h43, 8'h4F, 8'h4E, 8'h54, 8'h52}; // "CONTR"
    localparam [39:0] DISP_NAME_RESUL = {8'h52, 8'h45, 8'h53, 8'h55, 8'h4C}; // "RESUL"
    localparam [39:0] DISP_NAME_MULH  = {8'h4D, 8'h55, 8'h4C, 8'h48, 8'h20}; // "MULH "
    localparam [39:0] DISP_NAME_MULL  = {8'h4D, 8'h55, 8'h4C, 8'h4C, 8'h20}; // "MULL "
    localparam [39:0] DISP_NAME_QUOT  = {8'h51, 8'h55, 8'h4F, 8'h54, 8'h20}; // "QUOT "

    /*always @(posedge clk or negedge resetn) begin
        case(display_number)
            6'd1 : begin
                display_valid <= 1'b1;
                display_name  <= "SRC_1";
                display_value <= alu_src1;
            end
            6'd2 : begin
                display_valid <= 1'b1;
                display_name  <= "SRC_2";
                display_value <= alu_src2;
            end
            6'd3 : begin
                display_valid <= 1'b1;
                display_name  <= "CONTR";
                display_value <= {17'd0, alu_control};  // 保持位宽对齐
            end
            6'd4 : begin
                display_valid <= 1'b1;
                display_name  <= "RESUL";
                display_value <= alu_result;
            end
            6'd5 : begin
                display_valid <= 1'b1;
                display_name  <= "MULH";  // 乘法高 32 位
                display_value <= mul_result[63:32];
            end
            6'd6 : begin
                display_valid <= 1'b1;
                display_name  <= "MULL";  // 乘法低 32 位
                display_value <= mul_result[31:0];
            end
            6'd7 : begin
                display_valid <= 1'b1;
                display_name  <= "QUOT";  // 显示除法商
                display_value <= quotient;
            end
            default : begin
                display_valid <= 1'b0;
                display_name  <= 40'd0;
                display_value <= 32'd0;
            end
        endcase
    end*/

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            display_valid <= 1'b0;
            display_name  <= 40'd0;
            display_value <= 32'd0;
        end else begin
            case(display_number)
                6'd1 : begin
                    display_valid <= 1'b1;
                    display_name  <= DISP_NAME_SRC1;
                    display_value <= alu_src1;
                end
                6'd2 : begin
                    display_valid <= 1'b1;
                    display_name  <= DISP_NAME_SRC2;
                    display_value <= alu_src2;
                end
                6'd3 : begin
                    display_valid <= 1'b1;
                    display_name  <= DISP_NAME_CONTR;
                    display_value <= {17'd0, alu_control};
                end
                6'd4 : begin
                    display_valid <= 1'b1;
                    display_name  <= DISP_NAME_RESUL;
                    display_value <= alu_result;
                end
                6'd5 : begin
                    display_valid <= 1'b1;
                    display_name  <= DISP_NAME_MULH;
                    display_value <= mul_result[63:32];
                end
                6'd6 : begin
                    display_valid <= 1'b1;
                    display_name  <= DISP_NAME_MULL;
                    display_value <= mul_result[31:0];
                end
                6'd7 : begin
                    display_valid <= 1'b1;
                    display_name  <= DISP_NAME_QUOT;
                    display_value <= quotient;
                end
                default : begin
                    display_valid <= 1'b0;
                    display_name  <= 40'd0;
                    display_value <= 32'd0;
                end
            endcase
        end
    end

    lcd_controller u_lcd (
        .clk         (clk),
        .resetn      (resetn),
        .lcd_rst     (lcd_rst),
        .lcd_cs      (lcd_cs),
        .lcd_rs      (lcd_rs),
        .lcd_wr      (lcd_wr),
        .lcd_rd      (lcd_rd),
        .lcd_data_io (lcd_data_io),
        .lcd_bl_ctr  (lcd_bl_ctr),
        .display_valid (display_valid),
        .display_name  (display_name),
        .display_value (display_value)
    );

// 实例化LCD控制器（新增）
    lcd_controller u_lcd (
        .clk         (clk),
        .resetn      (resetn),
        .lcd_rst     (lcd_rst),
        .lcd_cs      (lcd_cs),
        .lcd_rs      (lcd_rs),
        .lcd_wr      (lcd_wr),
        .lcd_rd      (lcd_rd),
        .lcd_data_io (lcd_data_io),
        .lcd_bl_ctr  (lcd_bl_ctr),
        .display_valid (display_valid),
        .display_name  (display_name),
        .display_value (display_value)
    );

//-----{输出到触摸屏显示}end

endmodule
