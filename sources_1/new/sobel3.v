`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/16 16:23:52
// Design Name: 
// Module Name: sobel3
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


module sobel3 #(
    parameter PIXEL_WIDTH = 8
)(
    input clk,
    input rst_n,
    input wire [PIXEL_WIDTH*3*3-1:0] in_pixel,
    input wire in_valid,
    input wire [31:0] in_pixel_num,
    output wire [15:0] gradient_xx,
    output wire [15:0] gradient_yy,
    output wire [15:0] gradient_xy,
    output wire out_valid,
    output wire [31:0] out_pixel_num
    );
wire signed [10:0] Ix, Iy;
reg [15:0] xx;
reg [15:0] yy;
reg [15:0] xy;
reg [31:0] pixel_num;
reg isvalid;
assign Ix = (in_pixel[23:16]+2*in_pixel[47:40]+in_pixel[71:64])-(in_pixel[7:0]+2*in_pixel[31:24]+in_pixel[55:48]);
assign Iy = (in_pixel[55:48]+2*in_pixel[63:56]+in_pixel[71:64])-(in_pixel[7:0]+2*in_pixel[15:8]+in_pixel[23:16]);
assign gradient_xx = xx;
assign gradient_yy = yy;
assign gradient_xy = xy;
assign out_valid = isvalid;
assign out_pixel_num = pixel_num;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        xx <= 0;
        xy <= 0;
        yy <= 0;
        isvalid <= 0;
        pixel_num <= 0;
    end
    else begin
        if (in_valid == 1) begin
            xx <= Ix * Ix;
            xy <= Ix * Iy;
            yy <= Iy * Iy;
            isvalid <= 1;
            pixel_num <= in_pixel_num;
        end
        else begin
            xx <= 0;
            xy <= 0;
            yy <= 0;
            isvalid <= 0;
            pixel_num <= 0;
        end
    end
end
endmodule
