`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/07 20:48:47
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
    parameter DATA_WIDTH = 14
)(
    input wire clk,
    input wire rst_n,
    input wire in_window_valid,
    input wire [DATA_WIDTH*5-1:0] in_window_value,
    output reg [4+DATA_WIDTH-1:0] out_event_value,
    output reg out_event_valid
    );
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        out_event_value <= 0;
        out_event_valid <= 0;
    end
    else begin
        if(in_window_valid == 1) begin
            out_event_value <= in_window_value[DATA_WIDTH*0+DATA_WIDTH-1:DATA_WIDTH*0] + 4*in_window_value[DATA_WIDTH*1+DATA_WIDTH-1:DATA_WIDTH*1] + 6*in_window_value[DATA_WIDTH*2+DATA_WIDTH-1:DATA_WIDTH*2] + 4*in_window_value[DATA_WIDTH*3+DATA_WIDTH-1:DATA_WIDTH*3] + in_window_value[DATA_WIDTH*4+DATA_WIDTH-1:DATA_WIDTH*4];
            out_event_valid <= 1;
        end
        else begin
            out_event_value <= 0;
            out_event_valid <= 0;
        end
    end
end
endmodule