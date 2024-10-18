`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/16 19:38:22
// Design Name: 
// Module Name: max5
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


module max5(
    input clk,
    input rst_n,
    input tready,
    input [31:0] in_pixel_num,
    input wire [45:0] pixel_0,
    input wire [45:0] pixel_1,
    input wire [45:0] pixel_2,
    input wire [45:0] pixel_3,
    input wire [45:0] pixel_4,
    output wire [45:0] max_pixel,
    output wire [31:0] out_pixel_num,
    output wire ifmiddle,
    output wire tvalid
    );
reg [45:0] max_pixel_0;
reg ifmiddle_0;
reg tvalid_0;
reg [31:0] out_pixel_num_0;
assign max_pixel = max_pixel_0;
assign ifmiddle = ifmiddle_0;
assign tvalid = tvalid_0;
assign out_pixel_num = out_pixel_num_0;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        max_pixel_0 <= 0;
        ifmiddle_0 <= 0;
        tvalid_0 <= 0;
    end
    else begin
        if (tready == 1) begin
            out_pixel_num_0 <= in_pixel_num;
            if (pixel_0 >= pixel_1 && pixel_0 >= pixel_2 && pixel_0 >= pixel_3 && pixel_0 >= pixel_4) begin
                max_pixel_0 <= pixel_0;
                ifmiddle_0 <= 0;
                tvalid_0 <= 1;
            end
            else if (pixel_1 >= pixel_0 && pixel_1 >= pixel_2 && pixel_1 >= pixel_3 && pixel_1 >= pixel_4) begin
                max_pixel_0 <= pixel_1;
                ifmiddle_0 <= 0;
                tvalid_0 <= 1;
            end
            else if (pixel_2 >= pixel_0 && pixel_2 >= pixel_1 && pixel_2 >= pixel_3 && pixel_2 >= pixel_4) begin
                max_pixel_0 <= pixel_2;
                ifmiddle_0 <= 1;
                tvalid_0 <= 1;
            end
            else if (pixel_3 >= pixel_0 && pixel_3 >= pixel_1 && pixel_3 >= pixel_2 && pixel_3 >= pixel_4) begin
                max_pixel_0 <= pixel_3;
                ifmiddle_0 <= 0;
                tvalid_0 <= 1;
            end
            else if (pixel_4 >= pixel_0 && pixel_4 >= pixel_1 && pixel_4 >= pixel_2 && pixel_4 >= pixel_3) begin
                max_pixel_0 <= pixel_4;
                ifmiddle_0 <= 0;
                tvalid_0 <= 1;
            end
            else begin
                max_pixel_0 <= 0;
                ifmiddle_0 <= 0;
                tvalid_0 <= 0;
            end
        end
        else begin
            max_pixel_0 <= 0;
            ifmiddle_0 <= 0;
            tvalid_0 <= 0;
        end
    end
end
endmodule
