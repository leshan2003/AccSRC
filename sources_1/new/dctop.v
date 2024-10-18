`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/18 12:41:13
// Design Name: 
// Module Name: dctop
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


module dctop(
    input clk,
    input rst_n,
    input wire [7:0] in_pixel,
    input wire in_valid,
    input wire [31:0] in_pixel_num,
    output wire [255:0] out_descriptor,
    output wire out_valid,
    output wire [31:0] out_descriptor_num
    );
wire [8*(2*2+1)*(2*2+1)-1:0] lb1gs5_pixel;
wire [31:0] lb1gs5_pixel_num;
wire lb1gs5_valid;
linebuffer #(
    .IMAGE_WIDTH(640),
    .IMAGE_HEIGHT(287),
    .HALF_WINDOW_SIZE(2),
    .PIXEL_WIDTH(8)
) lb1 (
    .clk(clk),
    .rst_n(rst_n),
    .in_pixel(in_pixel),
    .in_pixel_num(in_pixel_num),
    .in_valid(in_valid),
    .out_pixel(lb1gs5_pixel),
    .out_pixel_num(lb1gs5_pixel_num),
    .out_valid(lb1gs5_valid)
    );
wire [15:0] gs5lb2_pixel;
wire [31:0] gs5lb2_pixel_num;
wire gs5lb2_valid;
gauss5 #(
    .PIXEL_WIDTH(8)
) gs5 (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(lb1gs5_valid),
    .in_pixel(lb1gs5_pixel),
    .in_pixel_num(lb1gs5_pixel_num),
    .out_pixel_num(gs5lb2_pixel_num),
    .out_pixel(gs5lb2_pixel),
    .out_valid(gs5lb2_valid)
);
wire [16*31*31-1:0] lb2brief31_pixel;
wire [31:0] lb2brief31_pixel_num;
wire lb2brief31_valid;
linebuffer #(
    .IMAGE_WIDTH(636),
    .IMAGE_HEIGHT(283),
    .HALF_WINDOW_SIZE(15),
    .PIXEL_WIDTH(16)
) lb2 (
    .clk(clk),
    .rst_n(rst_n),
    .in_pixel(gs5lb2_pixel),
    .in_pixel_num(gs5lb2_pixel_num),
    .in_valid(gs5lb2_valid),
    .out_pixel(lb2brief31_pixel),
    .out_pixel_num(lb2brief31_pixel_num),
    .out_valid(lb2brief31_valid)
    );
wire [255:0] brief31_descriptor_out;
wire brief31_valid;
wire [31:0] brief31_descriptor_num_out;
brief31 #(
    .PIXEL_WIDTH(16)
) brief31 (
    .clk(clk),
    .rst_n(rst_n),
    .in_pixel(lb2brief31_pixel),
    .in_pixel_num(lb2brief31_pixel_num),
    .in_valid(lb2brief31_valid),
    .out_descriptor(out_descriptor),
    .out_valid(out_valid),
    .out_pixel_num(out_descriptor_num)
);
endmodule
