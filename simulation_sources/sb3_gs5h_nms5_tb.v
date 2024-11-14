`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/13 21:07:25
// Design Name: 
// Module Name: sb3_gs5h_nms5_tb
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


module sb3_gs5h_nms5_tb #(
    parameter DATA_WIDTH = 4,
    parameter DATA_WIDTH_2 = 2*(DATA_WIDTH+3),
    parameter DATA_WIDTH_3 = DATA_WIDTH_2 + 8,
    parameter TODO_WINDOW_FIFO_DEPTH = 256
)(

    );
reg clk, rst_n;
wire in_event_valid_0;
wire [DATA_WIDTH-1:0] in_event_value_0;
wire [15:0] in_event_addr_0;
wire event_req;
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
wire [3*3*DATA_WIDTH-1:0] in_window_value_1;
wire [15:0] in_window_addr_1;
wire in_window_valid_1;
EventScheduler3 #(
    .DATA_WIDTH(DATA_WIDTH),
    .HALF_WINDOW_SIZE(1),
    .TODO_WINDOW_FIFO_DEPTH(TODO_WINDOW_FIFO_DEPTH)
) EventScheduler3_inst_sb3 (
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

wire [(DATA_WIDTH_2-1):0] in_event_value_2_xx;
wire [(DATA_WIDTH_2):0] in_event_value_2_xy;
wire [(DATA_WIDTH_2-1):0] in_event_value_2_yy;
wire [15:0] in_event_addr_2;
wire in_event_valid_2, out_event_req_2;
sobel3 #(
    .DATA_WIDTH(DATA_WIDTH)
) sobel3_inst (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_value(in_window_value_1),
    .in_window_valid(in_window_valid_1),
    .in_window_addr(in_window_addr_1),
    .ready_for_new_event(out_event_req_2),
    .gradient_xx(in_event_value_2_xx),
    .gradient_yy(in_event_value_2_yy),
    .gradient_xy(in_event_value_2_xy),
    .out_event_valid(in_event_valid_2),
    .out_event_addr(in_event_addr_2),
    .window_req(out_window_req_1)
    );

// wire out_window_req_3;
// wire [5*5*DATA_WIDTH_2-1:0] in_window_value_3;
// wire [15:0] in_window_addr_3;
// wire in_window_valid_3;
// EventScheduler5 #(
//     .DATA_WIDTH(DATA_WIDTH_2),
//     .HALF_WINDOW_SIZE(2),
//     .TODO_WINDOW_FIFO_DEPTH(TODO_WINDOW_FIFO_DEPTH)
// ) EventScheduler5_inst_gs5 (
//     .clk(clk),
//     .rst_n(rst_n),
//     .in_event_value(in_event_value_2_xx),
//     .in_event_addr(in_event_addr_2),
//     .in_event_valid(in_event_valid_2),
//     .window_req(out_window_req_3),
//     .out_window_value(in_window_value_3),
//     .out_window_addr(in_window_addr_3),
//     .out_window_valid(in_window_valid_3),
//     .ready_for_new_event(out_event_req_2)
//     );

wire [5*5*(DATA_WIDTH+3)*2-1:0] in_window_value_3_xx;
wire [5*5*((DATA_WIDTH+3)*2+1)-1:0] in_window_value_3_xy;
wire [5*5*(DATA_WIDTH+3)*2-1:0] in_window_value_3_yy;
wire [15:0] in_window_addr_3;
wire in_window_valid_3, out_window_req_3;
EventScheduler5_3 #(
    .DATA_WIDTH((DATA_WIDTH+3)*2),
    .HALF_WINDOW_SIZE(2),
    .TODO_WINDOW_FIFO_DEPTH(TODO_WINDOW_FIFO_DEPTH)
) EventScheduler5_3_inst (
    .clk(clk),
    .rst_n(rst_n),
    .in_event_value_xx(in_event_value_2_xx),
    .in_event_value_xy(in_event_value_2_xy),
    .in_event_value_yy(in_event_value_2_yy),
    .in_event_addr(in_event_addr_2),
    .in_event_valid(in_event_valid_2),
    .window_req(out_window_req_3),
    .out_window_value_xx(in_window_value_3_xx),
    .out_window_value_xy(in_window_value_3_xy),
    .out_window_value_yy(in_window_value_3_yy),
    .out_window_addr(in_window_addr_3),
    .out_window_valid(in_window_valid_3),
    .ready_for_new_event(out_event_req_2)
    );
    
wire [DATA_WIDTH_3-1:0] in_event_value_4;
wire [15:0] in_event_addr_4;
wire in_event_valid_4, out_event_req_4;
gauss5 #(
    .DATA_WIDTH(DATA_WIDTH_2)
) gauss5_inst (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_value(in_window_value_3_xx),
    .in_window_valid(in_window_valid_3),
    .in_window_addr(in_window_addr_3),
    .ready_for_new_event(out_event_req_4),
    .out_event_value(in_event_value_4),
    .out_event_valid(in_event_valid_4),
    .out_event_addr(in_event_addr_4),
    .window_req(out_window_req_3)
    );

wire [5*5*DATA_WIDTH_3-1:0] in_window_value_5;
wire [15:0] in_window_addr_5;
wire in_window_valid_5, out_window_req_5;
EventScheduler5_end #(
    .DATA_WIDTH(DATA_WIDTH_3),
    .HALF_WINDOW_SIZE(2),
    .TODO_WINDOW_FIFO_DEPTH(TODO_WINDOW_FIFO_DEPTH)
) EventScheduler5_inst_nms (
    .clk(clk),
    .rst_n(rst_n),
    .in_event_value(in_event_value_4),
    .in_event_addr(in_event_addr_4),
    .in_event_valid(in_event_valid_4),
    .window_req(out_window_req_5),
    .out_window_value(in_window_value_5),
    .out_window_addr(in_window_addr_5),
    .out_window_valid(in_window_valid_5),
    .ready_for_new_event(out_event_req_4)
    );

wire in_isfeature_6;
wire [15:0] in_feature_addr_6;
wire in_feature_valid_6, out_event_req_6;
nms5 #(
    .DATA_WIDTH(DATA_WIDTH_3)
) nms5_inst (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_value(in_window_value_5),
    .in_window_valid(in_window_valid_5),
    .in_window_addr(in_window_addr_5),
    .ready_for_new_feature(out_event_req_6),
    .threshold(0),
    .out_isfeature(in_isfeature_6),
    .out_feature_addr(in_feature_addr_6),
    .out_feature_valid(in_feature_valid_6),
    .window_req(out_window_req_5)
    );
assign out_event_req_6 = 1;

always begin
    #5 clk = ~clk;
end
initial begin
    clk <= 0;
    rst_n <= 1;
end

endmodule