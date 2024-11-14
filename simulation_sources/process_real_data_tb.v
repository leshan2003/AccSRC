`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/08 16:24:59
// Design Name: 
// Module Name: process_real_data_tb
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


module process_real_data_tb(

    );
reg clk, rst_n;
wire in_event_valid_0;
wire [3:0] in_event_value_0;
wire [15:0] in_event_addr_0;
wire event_req, isfeature, feature_valid;
wire [15:0] feature_addr;
raw_event_dispatcher #(
    .EventMEM_DEPTH(65536),
    .DATA_WIDTH(4),
    .eventvaluefile("D:/Event/SP_block_656_eventvalue.txt"),
    .eventaddrrowfile("D:/Event/SP_block_656_eventaddrrow.txt"),
    .eventaddrcolfile("D:/Event/SP_block_656_eventaddrcol.txt")
) raw_event_dispatcher_inst (
    .clk(clk),
    .rst_n(rst_n),
    .out_event_req_0(event_req),
    .in_event_valid_0(in_event_valid_0),
    .in_event_value_0(in_event_value_0),
    .in_event_addr_0(in_event_addr_0)
    );
FD_top #(
    .DATA_WIDTH(4),
    .TODO_WINDOW_FIFO_DEPTH(128)
) FD_top_inst (
    .clk(clk),
    .rst_n(rst_n),
    .in_event_valid_0(in_event_valid_0),
    .in_event_value_0(in_event_value_0),
    .in_event_addr_0(in_event_addr_0),
    .ready_for_new_feature(1),
    .event_req(event_req),
    .out_isfeature(isfeature),
    .out_feature_addr(feature_addr),
    .out_feature_valid(feature_valid)
    );
always begin
    #5 clk = ~clk;
end
initial begin
    clk <= 0;
    rst_n <= 1;
end
endmodule
