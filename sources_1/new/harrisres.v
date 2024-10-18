`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/16 19:25:07
// Design Name: 
// Module Name: harrisres
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


module harrisres(
    input clk,
    input rst_n,
    input wire [23:0] xx_filtered_pixel,
    input wire [23:0] xy_filtered_pixel,
    input wire [23:0] yy_filtered_pixel,
    input wire [31:0] filtered_pixel_num,
    input xx_filtered_pixel_valid,
    input xy_filtered_pixel_valid,
    input yy_filtered_pixel_valid,
    output wire [45:0] harris_response,
    output wire harris_response_valid,
    output wire [31:0] harris_response_pixel_num
    );
reg [45:0] harris_response_0;
reg harris_response_valid_0;
reg [31:0] harris_response_pixel_num_0;
assign harris_response = harris_response_0;
assign harris_response_valid = harris_response_valid_0;
assign harris_response_pixel_num = harris_response_pixel_num_0;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        harris_response_0 <= 0;
        harris_response_valid_0 <= 0;
        harris_response_pixel_num_0 <= 0;
    end
    else begin
        if (xx_filtered_pixel_valid == 1 && xy_filtered_pixel_valid == 1 && yy_filtered_pixel_valid == 1) begin
            harris_response_0 <= 25 * xx_filtered_pixel * yy_filtered_pixel - 25 * xy_filtered_pixel * xy_filtered_pixel - (xx_filtered_pixel + yy_filtered_pixel) * (xx_filtered_pixel + yy_filtered_pixel);
            harris_response_valid_0 <= 1;
            harris_response_pixel_num_0 <= filtered_pixel_num;
        end
        else begin
            harris_response_valid_0 <= 0;
            harris_response_pixel_num_0 <= 0;
            harris_response_0 <= 0;
        end
    end
end
endmodule
