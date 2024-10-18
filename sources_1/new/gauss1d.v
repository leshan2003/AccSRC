`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/16 16:40:09
// Design Name: 
// Module Name: gauss1d
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


module gauss1d #(
    parameter PIXEL_WIDTH = 16
)(
    input clk,
    input rst_n,
    input tready,
    input wire [PIXEL_WIDTH-1:0] pixel_0,
    input wire [PIXEL_WIDTH-1:0] pixel_1,
    input wire [PIXEL_WIDTH-1:0] pixel_2,
    input wire [PIXEL_WIDTH-1:0] pixel_3,
    input wire [PIXEL_WIDTH-1:0] pixel_4,
    input wire [31:0] in_pixel_num,
    output wire [PIXEL_WIDTH+8-1:0] filtered_pixel_1d,
    output wire [31:0] out_pixel_num,
    output wire tvalid
    );
reg [PIXEL_WIDTH+8-1:0] filtered_pixel_1d_out;
reg [31:0] out_pixel_num_1;
reg tvalid_out;
assign out_pixel_num = out_pixel_num_1;
assign filtered_pixel_1d = filtered_pixel_1d_out;
assign tvalid = tvalid_out;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        filtered_pixel_1d_out <= 0;
        tvalid_out <= 0;
        out_pixel_num_1 <= 0;
    end
    else begin
        if (tready == 1) begin
            filtered_pixel_1d_out <= pixel_0 + 4*pixel_1 + 6*pixel_2 + 4*pixel_3 + pixel_4;
            tvalid_out <= 1;
            out_pixel_num_1 <= in_pixel_num;
        end
        else begin
            filtered_pixel_1d_out <= 0;
            tvalid_out <= 0;
            out_pixel_num_1 <= 0;
        end
    end
end
endmodule
