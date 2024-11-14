`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/13 19:04:13
// Design Name: 
// Module Name: gauss3
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


module gauss3 #(
    parameter DATA_WIDTH = 14
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH*3*3-1:0] in_window_value,
    input wire in_window_valid,
    input wire [15:0] in_window_addr,
    input wire ready_for_new_event,     // next EventScheduler is ready for new event
    output reg [4+DATA_WIDTH-1:0] out_event_value,
    output reg out_event_valid,
    output reg [15:0] out_event_addr,
    output wire window_req              // Gauss5 is ready for new window
    );
assign window_req = ready_for_new_event;

wire out_event_valid_0;
wire [DATA_WIDTH+2-1:0] out_event_value_0;
gauss1d3 #(
    .DATA_WIDTH(DATA_WIDTH)
) gauss1d3_inst_0 (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_valid(in_window_valid),
    .in_window_value(in_window_value[DATA_WIDTH*3*1-1:DATA_WIDTH*3*0]),
    .out_event_value(out_event_value_0),
    .out_event_valid(out_event_valid_0)
    );
wire out_event_valid_1;
wire [DATA_WIDTH+2-1:0] out_event_value_1;
gauss1d3 #(
    .DATA_WIDTH(DATA_WIDTH)
) gauss1d3_inst_1 (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_valid(in_window_valid),
    .in_window_value(in_window_value[DATA_WIDTH*3*2-1:DATA_WIDTH*3*1]),
    .out_event_value(out_event_value_1),
    .out_event_valid(out_event_valid_1)
    );
wire out_event_valid_2;
wire [DATA_WIDTH+2-1:0] out_event_value_2;
gauss1d3 #(
    .DATA_WIDTH(DATA_WIDTH)
) gauss1d3_inst_2 (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_valid(in_window_valid),
    .in_window_value(in_window_value[DATA_WIDTH*3*3-1:DATA_WIDTH*3*2]),
    .out_event_value(out_event_value_2),
    .out_event_valid(out_event_valid_2)
    );
    
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        out_event_value <= 0;
        out_event_valid <= 0;
        out_event_addr <= 0;
    end
    else begin
        if(out_event_valid_0 == 1 && out_event_valid_1 == 1 && out_event_valid_2 == 1) begin
            out_event_value <= out_event_value_0 + 2*out_event_value_1 + 1*out_event_value_2;
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
