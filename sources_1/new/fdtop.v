`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/18 11:36:41
// Design Name: 
// Module Name: fdtop
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fdtop(
    input clk,
    input rst_n,
    input wire [7:0] in_pixel,
    input wire in_valid,
    input wire [31:0] in_pixel_num,
    output wire out_isfeature,
    output wire out_valid,
    output wire [31:0] out_pixel_num
    );
wire [8*(2*1+1)*(2*1+1)-1:0] lb1sb3_pixel;
wire [31:0] lb1sb3_pixel_num;
wire lb1sb3_valid;
linebuffer #(
    .IMAGE_WIDTH(640),
    .IMAGE_HEIGHT(287),
    .HALF_WINDOW_SIZE(1),
    .PIXEL_WIDTH(8)
) lb1 (
    .clk(clk),
    .rst_n(rst_n),
    .in_pixel(in_pixel),
    .in_pixel_num(in_pixel_num),
    .in_valid(in_valid),
    .out_pixel(lb1sb3_pixel),
    .out_pixel_num(lb1sb3_pixel_num),
    .out_valid(lb1sb3_valid)
    );
wire [15:0] gradient_xx;
wire [15:0] gradient_yy;
wire [15:0] gradient_xy;
wire [31:0] sb3lb2_pixel_num;
wire sb3lb2_valid;
sobel3 #(
    .PIXEL_WIDTH(8)
) sb3 (
    .clk(clk),
    .rst_n(rst_n),
    .in_pixel(lb1sb3_pixel),
    .in_valid(lb1sb3_valid),
    .in_pixel_num(lb1sb3_pixel_num),
    .gradient_xx(gradient_xx),
    .gradient_yy(gradient_yy),
    .gradient_xy(gradient_xy),
    .out_valid(sb3lb2_valid),
    .out_pixel_num(sb3lb2_pixel_num)
    );
wire [16*5*5-1:0] lb2xxgs5xx_pixel;
wire [31:0] lb2xxgs5xx_pixel_num;
wire lb2xxgs5xx_valid;
linebuffer #(
    .IMAGE_WIDTH(638),
    .IMAGE_HEIGHT(285),
    .HALF_WINDOW_SIZE(2),
    .PIXEL_WIDTH(16)
) lb2xx (
    .clk(clk),
    .rst_n(rst_n),
    .in_pixel(gradient_xx),
    .in_pixel_num(sb3lb2_pixel_num),
    .in_valid(sb3lb2_valid),
    .out_pixel(lb2xxgs5xx_pixel),
    .out_pixel_num(lb2xxgs5xx_pixel_num),
    .out_valid(lb2xxgs5xx_valid)
    );
wire [23:0] gs5xxharris_pixel;
wire [31:0] gs5xxharris_pixel_num;
wire gs5xxharris_valid;
gauss5 #(
    .PIXEL_WIDTH(16)
) gs5xx (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(lb2xxgs5xx_valid),
    .in_pixel_num(lb2xxgs5xx_pixel_num),
    .in_pixel(lb2xxgs5xx_pixel),
    .out_pixel(gs5xxharris_pixel),
    .out_pixel_num(gs5xxharris_pixel_num),
    .out_valid(gs5xxharris_valid)
    );
wire [16*5*5-1:0] lb2xygs5xy_pixel;
wire [31:0] lb2xygs5xy_pixel_num;
wire lb2xygs5xy_valid;
linebuffer #(
    .IMAGE_WIDTH(638),
    .IMAGE_HEIGHT(285),
    .HALF_WINDOW_SIZE(2),
    .PIXEL_WIDTH(16)
) lb2xy (
    .clk(clk),
    .rst_n(rst_n),
    .in_pixel(gradient_xy),
    .in_pixel_num(sb3lb2_pixel_num),
    .in_valid(sb3lb2_valid),
    .out_pixel(lb2xygs5xy_pixel),
    .out_pixel_num(lb2xygs5xy_pixel_num),
    .out_valid(lb2xygs5xy_valid)
    );
wire [23:0] gs5xyharris_pixel;
wire [31:0] gs5xyharris_pixel_num;
wire gs5xyharris_valid;
gauss5 #(
    .PIXEL_WIDTH(16)
) gs5xy (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(lb2xygs5xy_valid),
    .in_pixel_num(lb2xygs5xy_pixel_num),
    .in_pixel(lb2xygs5xy_pixel),
    .out_pixel(gs5xyharris_pixel),
    .out_pixel_num(gs5xyharris_pixel_num),
    .out_valid(gs5xyharris_valid)
    );
wire [16*5*5-1:0] lb2yygs5yy_pixel;
wire [31:0] lb2yygs5yy_pixel_num;
wire lb2yygs5yy_valid;
linebuffer #(
    .IMAGE_WIDTH(638),
    .IMAGE_HEIGHT(285),
    .HALF_WINDOW_SIZE(2),
    .PIXEL_WIDTH(16)
) lb2yy (
    .clk(clk),
    .rst_n(rst_n),
    .in_pixel(gradient_yy),
    .in_pixel_num(sb3lb2_pixel_num),
    .in_valid(sb3lb2_valid),
    .out_pixel(lb2yygs5yy_pixel),
    .out_pixel_num(lb2yygs5yy_pixel_num),
    .out_valid(lb2yygs5yy_valid)
    );
wire [23:0] gs5yyharris_pixel;
wire [31:0] gs5yyharris_pixel_num;
wire gs5yyharris_valid;
gauss5 #(
    .PIXEL_WIDTH(16)
) gs5yy (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(lb2yygs5yy_valid),
    .in_pixel_num(lb2yygs5yy_pixel_num),
    .in_pixel(lb2yygs5yy_pixel),
    .out_pixel(gs5yyharris_pixel),
    .out_pixel_num(gs5yyharris_pixel_num),
    .out_valid(gs5yyharris_valid)
    );
wire [45:0] harrisreslb3_pixel;
wire harrisreslb3_valid;
wire [31:0] harrisreslb3_pixel_num;
harrisres hrs(
    .clk(clk),
    .rst_n(rst_n),
    .xx_filtered_pixel(gs5xxharris_pixel),
    .yy_filtered_pixel(gs5yyharris_pixel),
    .xy_filtered_pixel(gs5xyharris_pixel),
    .xx_filtered_pixel_valid(gs5xxharris_valid),
    .yy_filtered_pixel_valid(gs5yyharris_valid),
    .xy_filtered_pixel_valid(gs5xyharris_valid),
    .filtered_pixel_num(gs5xxharris_pixel_num),
    .harris_response(harrisreslb3_pixel),
    .harris_response_valid(harrisreslb3_valid),
    .harris_response_pixel_num(harrisreslb3_pixel_num)
    );
wire [46*5*5-1:0] lb3nms_pixel;
wire [31:0] lb3nms_pixel_num;
wire lb3nms_valid;
linebuffer #(
    .IMAGE_WIDTH(634),
    .IMAGE_HEIGHT(281),
    .HALF_WINDOW_SIZE(2),
    .PIXEL_WIDTH(46)
) lb3 (
    .clk(clk),
    .rst_n(rst_n),
    .in_pixel(harrisreslb3_pixel),
    .in_pixel_num(harrisreslb3_pixel_num),
    .in_valid(harrisreslb3_valid),
    .out_pixel(lb3nms_pixel),
    .out_pixel_num(lb3nms_pixel_num),
    .out_valid(lb3nms_valid)
    );
nms5 #(
    .PIXEL_WIDTH(46)
) nms5 (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(lb3nms_valid),
    .in_pixel_num(lb3nms_pixel_num),
    .in_pixel(lb3nms_pixel),
    .threshold(0),
    .isfeature(out_isfeature),
    .out_valid(out_valid),
    .out_pixel_num(out_pixel_num)
    );
endmodule
