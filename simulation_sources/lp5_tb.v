`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/13 20:33:11
// Design Name: 
// Module Name: lp5_tb
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


module lp5_tb #(
    parameter DATA_WIDTH = 4,
    parameter DATA_WIDTH_2 = DATA_WIDTH+4,
    parameter TODO_WINDOW_FIFO_DEPTH = 256
)(

    );
reg clk, rst_n;
wire in_event_valid_0;
wire [DATA_WIDTH-1:0] in_event_value_0;
wire [15:0] in_event_addr_0;
wire event_req;
wire [15:0] feature_addr;
raw_event_dispatcher #(
    .EventMEM_DEPTH(65536),
    .DATA_WIDTH(DATA_WIDTH),
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

wire out_window_req_1;
wire [5*5*DATA_WIDTH-1:0] in_window_value_1;
wire [15:0] in_window_addr_1;
wire in_window_valid_1;
EventScheduler5_end #(
    .DATA_WIDTH(DATA_WIDTH),
    .TODO_WINDOW_FIFO_DEPTH(TODO_WINDOW_FIFO_DEPTH)
) EventScheduler5_inst (
    .clk(clk),
    .rst_n(rst_n),
    .in_event_value(in_event_value_0),
    .in_event_addr(in_event_addr_0),
    .in_event_valid(in_event_valid_0),
    .window_req(out_window_req_1),
    .out_window_value(in_window_value_1),
    .out_window_addr(in_window_addr_1),
    .out_window_valid(in_window_valid_1),
    .ready_for_new_event(event_req)
    );

wire [DATA_WIDTH_2-1:0] in_event_value_2;
wire [15:0] in_event_addr_2;
wire in_event_valid_2, out_event_req_2;
laplacian5 #(
    .DATA_WIDTH(DATA_WIDTH)
) laplacian5_inst (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_value(in_window_value_1),
    .in_window_valid(in_window_valid_1),
    .in_window_addr(in_window_addr_1),
    .ready_for_new_event(out_event_req_2),
    .out_event_value(in_event_value_2),
    .out_event_valid(in_event_valid_2),
    .out_event_addr(in_event_addr_2),
    .window_req(out_window_req_1)
    );

assign out_event_req_2 = 1;
always begin
    #5 clk = ~clk;
end
initial begin
    clk <= 0;
    rst_n <= 1;
end

endmodule