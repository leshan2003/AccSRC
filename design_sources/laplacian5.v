`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/13 19:32:28
// Design Name: 
// Module Name: laplacian5
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


module laplacian5 #(
    parameter DATA_WIDTH = 4
)(
    input clk,
    input rst_n,
    input wire [DATA_WIDTH*5*5-1:0] in_window_value,
    input wire in_window_valid,
    input wire [15:0] in_window_addr,
    input wire ready_for_new_event,     // next EventScheduler_yy is ready for new event
    output reg [DATA_WIDTH+4-1:0] out_event_value,
    output reg out_event_valid,
    output reg [15:0] out_event_addr,
    output wire window_req              // Sobel3 is ready for new window
    );
wire signed [10:0] Ix, Iy;
assign window_req = ready_for_new_event;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out_event_value <= 0;
        out_event_valid <= 0;
        out_event_addr <= 0;
    end
    else begin
        if (in_window_valid == 1) begin
            out_event_value <= in_window_value[DATA_WIDTH*12+DATA_WIDTH-1:DATA_WIDTH*12]*16 - in_window_value[DATA_WIDTH*2+DATA_WIDTH-1:DATA_WIDTH*2] - in_window_value[DATA_WIDTH*6+DATA_WIDTH-1:DATA_WIDTH*6] - in_window_value[DATA_WIDTH*7+DATA_WIDTH-1:DATA_WIDTH*7]*2 - in_window_value[DATA_WIDTH*8+DATA_WIDTH-1:DATA_WIDTH*8] - in_window_value[DATA_WIDTH*10+DATA_WIDTH-1:DATA_WIDTH*10] - in_window_value[DATA_WIDTH*11+DATA_WIDTH-1:DATA_WIDTH*11]*2 - in_window_value[DATA_WIDTH*13+DATA_WIDTH-1:DATA_WIDTH*13]*2 - in_window_value[DATA_WIDTH*14+DATA_WIDTH-1:DATA_WIDTH*14] - in_window_value[DATA_WIDTH*16+DATA_WIDTH-1:DATA_WIDTH*16] - in_window_value[DATA_WIDTH*17+DATA_WIDTH-1:DATA_WIDTH*17]*2 - in_window_value[DATA_WIDTH*18+DATA_WIDTH-1:DATA_WIDTH*18] - in_window_value[DATA_WIDTH*22+DATA_WIDTH-1:DATA_WIDTH*22];
            out_event_valid <= 1;
            out_event_addr <= in_window_addr;
        end
        else begin
            out_event_value <= 0;
            out_event_valid <= 0;
            out_event_addr <= 0;
        end
    end
end
endmodule