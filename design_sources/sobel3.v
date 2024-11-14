`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/07 12:10:18
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
    parameter DATA_WIDTH = 4
)(
    input clk,
    input rst_n,
    input wire [DATA_WIDTH*3*3-1:0] in_window_value,
    input wire in_window_valid,
    input wire [15:0] in_window_addr,
    input wire ready_for_new_event,     // next EventScheduler_yy is ready for new event
    output reg [13:0] gradient_xx,
    output reg [13:0] gradient_yy,
    output reg [14:0] gradient_xy,
    output reg out_event_valid,
    output reg [15:0] out_event_addr,
    output wire window_req              // Sobel3 is ready for new window
    );
wire signed [10:0] Ix, Iy;
assign Ix = (in_window_value[DATA_WIDTH*3-1:DATA_WIDTH*2]+2*in_window_value[DATA_WIDTH*6-1:DATA_WIDTH*5]+in_window_value[DATA_WIDTH*9-1:DATA_WIDTH*8])-(in_window_value[DATA_WIDTH*1-1:0]+2*in_window_value[DATA_WIDTH*4-1:DATA_WIDTH*3]+in_window_value[DATA_WIDTH*7-1:DATA_WIDTH*6]);
assign Iy = (in_window_value[DATA_WIDTH*7-1:DATA_WIDTH*6]+2*in_window_value[DATA_WIDTH*8-1:DATA_WIDTH*7]+in_window_value[DATA_WIDTH*9-1:DATA_WIDTH*8])-(in_window_value[DATA_WIDTH*1-1:0]+2*in_window_value[DATA_WIDTH*2-1:DATA_WIDTH]+in_window_value[DATA_WIDTH*3-1:DATA_WIDTH*2]);
assign window_req = ready_for_new_event;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        gradient_xx <= 0;
        gradient_xy <= 0;
        gradient_yy <= 0;
        out_event_valid <= 0;
        out_event_addr <= 0;
    end
    else begin
        if (in_window_valid == 1) begin
            gradient_xx <= Ix * Ix;
            gradient_xy <= Ix * Iy;
            gradient_yy <= Iy * Iy;
            out_event_valid <= 1;
            out_event_addr <= in_window_addr;
        end
        else begin
            gradient_xx <= 0;
            gradient_xy <= 0;
            gradient_yy <= 0;
            out_event_valid <= 0;
            out_event_addr <= 0;
        end
    end
end
endmodule
