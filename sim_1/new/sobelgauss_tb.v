`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/16 16:50:56
// Design Name: 
// Module Name: sobelgauss_tb
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


module sobelgauss_tb(

    );
reg clk;
reg [7:0] original_pixel;
reg original_valid;
wire [8*(2*1+1)*(2*1+1)-1:0] lb1sb3_pixel;
wire [15:0] position_col;
wire [15:0] position_row;
wire [15:0] lb1sb3_offset;
wire lb1sb3_valid;
linebuffer #(
    .IMAGE_WIDTH(640),
    .IMAGE_HEIGHT(287),
    .HALF_WINDOW_SIZE(1),
    .PIXEL_WIDTH(8)
) lb1 (
    .clk(clk),
    .rst_n(1'b1),
    .pixel_in(original_pixel),
    .in_valid(original_valid),
    .in_position_offset(16'b0),
    .pixel_out(lb1sb3_pixel),
    .position_col(position_col),
    .position_row(position_row),
    .out_position_offset(lb1sb3_offset),
    .out_valid(lb1sb3_valid)
    );
wire [15:0] gradient_xx;
wire [15:0] gradient_yy;
wire [15:0] gradient_xy;
wire [15:0] sb3lb2_offset;
wire sb3lb2_valid;
sobel3 #(
    .PIXEL_WIDTH(8)
) sb3 (
    .clk(clk),
    .rst_n(1'b1),
    .pixel_in(lb1sb3_pixel),
    .in_valid(lb1sb3_valid),
    .in_position_offset(lb1sb3_offset),
    .gradient_xx(gradient_xx),
    .gradient_yy(gradient_yy),
    .gradient_xy(gradient_xy),
    .out_position_offset(sb3lb2_offset),
    .out_valid(sb3lb2_valid)
    );
wire [16*5*5-1:0] lb2xxgs5xx_pixel;
wire [15:0] lb2xxgs5xx_offset;
wire lb2xxgs5xx_valid;
linebuffer #(
    .IMAGE_WIDTH(638),
    .IMAGE_HEIGHT(285),
    .HALF_WINDOW_SIZE(2),
    .PIXEL_WIDTH(16)
) lb2xx (
    .clk(clk),
    .rst_n(1'b1),
    .pixel_in(gradient_xx),
    .in_valid(sb3lb2_valid),
    .in_position_offset(sb3lb2_offset),
    .pixel_out(lb2xxgs5xx_pixel),
    .out_position_offset(lb2xxgs5xx_offset),
    .out_valid(lb2xxgs5xx_valid)
    );
wire [23:0] gs5xxharris_pixel;
wire [15:0] gs5xxharris_offset;
wire gs5xxharris_valid;
gauss5 #(
    .PIXEL_WIDTH(16)
) gs5xx (
    .clk(clk),
    .rst_n(1'b1),
    .in_valid(lb2xxgs5xx_valid),
    .in_position_offset(lb2xxgs5xx_offset),
    .pixel_in(lb2xxgs5xx_pixel),
    .pixel_out(gs5xxharris_pixel),
    .out_position_offset(gs5xxharris_offset),
    .out_valid(gs5xxharris_valid)
    );
wire [16*5*5-1:0] lb2xygs5xy_pixel;
wire [15:0] lb2xygs5xy_offset;
wire lb2xygs5xy_valid;
linebuffer #(
    .IMAGE_WIDTH(638),
    .IMAGE_HEIGHT(285),
    .HALF_WINDOW_SIZE(2),
    .PIXEL_WIDTH(16)
) lb2xy (
    .clk(clk),
    .rst_n(1'b1),
    .pixel_in(gradient_xy),
    .in_valid(sb3lb2_valid),
    .in_position_offset(sb3lb2_offset),
    .pixel_out(lb2xygs5xy_pixel),
    .out_position_offset(lb2xygs5xy_offset),
    .out_valid(lb2xygs5xy_valid)
    );
wire [23:0] gs5xyharris_pixel;
wire [15:0] gs5xyharris_offset;
wire gs5xyharris_valid;
gauss5 #(
    .PIXEL_WIDTH(16)
) gs5xy (
    .clk(clk),
    .rst_n(1'b1),
    .in_valid(lb2xygs5xy_valid),
    .in_position_offset(lb2xygs5xy_offset),
    .pixel_in(lb2xygs5xy_pixel),
    .pixel_out(gs5xyharris_pixel),
    .out_position_offset(gs5xyharris_offset),
    .out_valid(gs5xyharris_valid)
    );
wire [16*5*5-1:0] lb2yygs5yy_pixel;
wire [15:0] lb2yygs5yy_offset;
wire lb2yygs5yy_valid;
linebuffer #(
    .IMAGE_WIDTH(638),
    .IMAGE_HEIGHT(285),
    .HALF_WINDOW_SIZE(2),
    .PIXEL_WIDTH(16)
) lb2yy (
    .clk(clk),
    .rst_n(1'b1),
    .pixel_in(gradient_yy),
    .in_valid(sb3lb2_valid),
    .in_position_offset(sb3lb2_offset),
    .pixel_out(lb2yygs5yy_pixel),
    .out_position_offset(lb2yygs5yy_offset),
    .out_valid(lb2yygs5yy_valid)
    );
wire [23:0] gs5yyharris_pixel;
wire [15:0] gs5yyharris_offset;
wire gs5yyharris_valid;
gauss5 #(
    .PIXEL_WIDTH(16)
) gs5yy (
    .clk(clk),
    .rst_n(1'b1),
    .in_valid(lb2yygs5yy_valid),
    .in_position_offset(lb2yygs5yy_offset),
    .pixel_in(lb2yygs5yy_pixel),
    .pixel_out(gs5yyharris_pixel),
    .out_position_offset(gs5yyharris_offset),
    .out_valid(gs5yyharris_valid)
    );
wire [45:0] harrisreslb3_pixel;
wire [15:0] harrisreslb3_offset;
wire harrisreslb3_valid;
harrisres hrs(
    .clk(clk),
    .rst_n(1'b1),
    .xx_filtered_pixel(gs5xxharris_pixel),
    .xy_filtered_pixel(gs5xyharris_pixel),
    .yy_filtered_pixel(gs5yyharris_pixel),
    .xx_filtered_pixel_valid(gs5xxharris_valid),
    .xy_filtered_pixel_valid(gs5xyharris_valid),
    .yy_filtered_pixel_valid(gs5yyharris_valid),
    .in_position_offset(gs5yyharris_offset),
    .out_position_offset(harrisreslb3_offset),
    .harris_response(harrisreslb3_pixel),
    .harris_response_valid(harrisreslb3_valid)
    );
wire [46*5*5-1:0] lb3nms_pixel;
wire [15:0] lb3nms_offset;
wire lb3nms_valid;
linebuffer #(
    .IMAGE_WIDTH(634),
    .IMAGE_HEIGHT(281),
    .HALF_WINDOW_SIZE(2),
    .PIXEL_WIDTH(46)
) lb3 (
    .clk(clk),
    .rst_n(1'b1),
    .pixel_in(harrisreslb3_pixel),
    .in_valid(harrisreslb3_valid),
    .in_position_offset(harrisreslb3_offset),
    .pixel_out(lb3nms_pixel),
    .out_position_offset(lb3nms_offset),
    .out_valid(lb3nms_valid)
    );
integer k,fd;
always #10 clk = ~clk;
initial begin
    clk = 0;
    k = 0;
    original_pixel = 0;
    original_valid = 0;
    fd = $fopen("D:/Creativity/01_SLAM_VO_Accelerator/png2int8py/199.dat", "r");
    #20;
    for (k=0; k<640*287; k=k+1) begin
        $fscanf(fd, "%d", original_pixel);
        original_valid = 1;
        #20;
    end
    $fclose(fd);
    for (k=0; k<640*287; k=k+1) begin
        original_pixel = k % 5;
        original_valid = 1;
        #20;
    end
end
endmodule
