`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/07 21:35:34
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


module harrisres #(
    parameter DATA_WIDTH = 23
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH-2:0] in_event_value_xx,
    input wire [DATA_WIDTH-1:0] in_event_value_xy,
    input wire [DATA_WIDTH-2:0] in_event_value_yy,
    input wire in_event_valid_xx,
    input wire in_event_valid_xy,
    input wire in_event_valid_yy,
    input wire [15:0] in_event_addr_xx,
    input wire [15:0] in_event_addr_xy,
    input wire [15:0] in_event_addr_yy,
    input wire ready_for_new_event,     // next EventScheduler is ready for new event
    output reg [DATA_WIDTH+22:0] out_event_value,
    output reg out_event_valid,
    output reg [15:0] out_event_addr,
    output wire event_req               // HarrisRes is ready for new window
    );
assign event_req = ready_for_new_event;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        out_event_value <= 0;
        out_event_valid <= 0;
        out_event_addr <= 0;
    end
    else begin
        if(in_event_valid_xx == 1 && in_event_valid_xy == 1 && in_event_valid_yy == 1 && in_event_addr_xx == in_event_addr_xy && in_event_addr_xx == in_event_addr_yy) begin
            out_event_value <= 25 * in_event_value_xx * in_event_value_yy - 25 * in_event_value_xy * in_event_value_xy - (in_event_value_xx + in_event_value_yy) * (in_event_value_xx + in_event_value_yy);
            out_event_valid <= 1;
            out_event_addr <= in_event_addr_xx;
        end
        else begin
            out_event_value <= 0;
            out_event_valid <= 0;
            out_event_addr <= 0;
        end
    end
end
endmodule
