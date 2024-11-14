`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/07 16:47:40
// Design Name: 
// Module Name: FD_top
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


module FD_top #(
    parameter DATA_WIDTH = 4,
    parameter TODO_WINDOW_FIFO_DEPTH = 32,
    parameter HASH_MEM_DEPTH = 128
)(
    input wire clk,
    input wire rst_n,
    input wire in_event_valid_0,
    input wire [DATA_WIDTH-1:0] in_event_value_0,
    input wire [15:0] in_event_addr_0,
    input wire ready_for_new_feature,       // next block is ready for new feature
    output wire event_req,
    output wire out_isfeature,
    output wire [15:0] out_feature_addr,
    output wire out_feature_valid
    );
wire out_window_req_1;
wire [3*3*DATA_WIDTH-1:0] in_window_value_1;
wire [15:0] in_window_addr_1;
wire in_window_valid_1;
EventScheduler3 #(
    .DATA_WIDTH(DATA_WIDTH),
    .HALF_WINDOW_SIZE(1),
    .TODO_WINDOW_FIFO_DEPTH(TODO_WINDOW_FIFO_DEPTH),
    .HASH_MEM_DEPTH(HASH_MEM_DEPTH)
) EventScheduler3_inst (
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

wire [((DATA_WIDTH+3)*2-1):0] in_event_value_2_xx;
wire [((DATA_WIDTH+3)*2):0] in_event_value_2_xy;
wire [((DATA_WIDTH+3)*2-1):0] in_event_value_2_yy;
wire [15:0] in_event_addr_2;
wire in_event_valid_2, out_event_req_2;
sobel3 #(
    .DATA_WIDTH(4)
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
// assign out_event_req_2 = 1;
wire [5*5*(DATA_WIDTH+3)*2-1:0] in_window_value_3_xx;
wire [5*5*((DATA_WIDTH+3)*2+1)-1:0] in_window_value_3_xy;
wire [5*5*(DATA_WIDTH+3)*2-1:0] in_window_value_3_yy;
wire [15:0] in_window_addr_3;
wire in_window_valid_3, out_window_req_3;
EventScheduler5_3 #(
    .DATA_WIDTH((DATA_WIDTH+3)*2),
    .HALF_WINDOW_SIZE(2),
    .TODO_WINDOW_FIFO_DEPTH(TODO_WINDOW_FIFO_DEPTH),
    .HASH_MEM_DEPTH(HASH_MEM_DEPTH)
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
// assign out_window_req_3 = 1;
wire [15:0] in_event_addr_4_xx;
wire [((DATA_WIDTH+3)*2+7):0] in_event_value_4_xx;
wire in_event_valid_4_xx, out_event_req_4;
wire out_window_req_3_xx, out_window_req_3_xy, out_window_req_3_yy;
assign out_window_req_3 = out_window_req_3_xx & out_window_req_3_xy & out_window_req_3_yy;
gauss5 #(
    .DATA_WIDTH((DATA_WIDTH+3)*2)
) gauss5_inst_xx (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_value(in_window_value_3_xx),
    .in_window_valid(in_window_valid_3),
    .in_window_addr(in_window_addr_3),
    .ready_for_new_event(out_event_req_4),
    .out_event_valid(in_event_valid_4_xx),
    .out_event_addr(in_event_addr_4_xx),
    .out_event_value(in_event_value_4_xx),
    .window_req(out_window_req_3_xx)
    );
wire [15:0] in_event_addr_4_xy;
wire [((DATA_WIDTH+3)*2+8):0] in_event_value_4_xy;
wire in_event_valid_4_xy, out_event_req_4;
gauss5 #(
    .DATA_WIDTH((DATA_WIDTH+3)*2+1)
) gauss5_inst_xy (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_value(in_window_value_3_xy),
    .in_window_valid(in_window_valid_3),
    .in_window_addr(in_window_addr_3),
    .ready_for_new_event(out_event_req_4),
    .out_event_valid(in_event_valid_4_xy),
    .out_event_addr(in_event_addr_4_xy),
    .out_event_value(in_event_value_4_xy),
    .window_req(out_window_req_3_xy)
    );
wire [15:0] in_event_addr_4_yy;
wire [((DATA_WIDTH+3)*2+7):0] in_event_value_4_yy;
wire in_event_valid_4_yy, out_event_req_4;
gauss5 #(
    .DATA_WIDTH((DATA_WIDTH+3)*2)
) gauss5_inst_yy (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_value(in_window_value_3_yy),
    .in_window_valid(in_window_valid_3),
    .in_window_addr(in_window_addr_3),
    .ready_for_new_event(out_event_req_4),
    .out_event_valid(in_event_valid_4_yy),
    .out_event_addr(in_event_addr_4_yy),
    .out_event_value(in_event_value_4_yy),
    .window_req(out_window_req_3_yy)
    );
// assign out_event_req_4 = 1;
wire [(((DATA_WIDTH+3)*2+9)*2-1):0] in_event_value_5;
wire [15:0] in_event_addr_5;
wire in_event_valid_5, out_event_req_5;
harrisres #(
    .DATA_WIDTH((DATA_WIDTH+3)*2+9)
) harrisres_inst (
    .clk(clk),
    .rst_n(rst_n),
    .in_event_value_xx(in_event_value_4_xx),
    .in_event_value_yy(in_event_value_4_yy),
    .in_event_value_xy(in_event_value_4_xy),
    .in_event_valid_xx(in_event_valid_4_xx),
    .in_event_valid_yy(in_event_valid_4_yy),
    .in_event_valid_xy(in_event_valid_4_xy),
    .in_event_addr_xx(in_event_addr_4_xx),
    .in_event_addr_yy(in_event_addr_4_yy),
    .in_event_addr_xy(in_event_addr_4_xy),
    .ready_for_new_event(out_event_req_5),
    .out_event_valid(in_event_valid_5),
    .out_event_addr(in_event_addr_5),
    .out_event_value(in_event_value_5),
    .event_req(out_event_req_4)
    );
wire [5*5*(((DATA_WIDTH+3)*2+9)*2)-1:0] in_window_value_6;
wire [15:0] in_window_addr_6;
wire in_window_valid_6, out_window_req_6;
EventScheduler5 #(
    .DATA_WIDTH((((DATA_WIDTH+3)*2+9)*2)),
    .HALF_WINDOW_SIZE(2),
    .TODO_WINDOW_FIFO_DEPTH(TODO_WINDOW_FIFO_DEPTH),
    .HASH_MEM_DEPTH(HASH_MEM_DEPTH)
) EventScheduler5_inst_nms (
    .clk(clk),
    .rst_n(rst_n),
    .in_event_value(in_event_value_5),
    .in_event_addr(in_event_addr_5),
    .in_event_valid(in_event_valid_5),
    .window_req(out_window_req_6),
    .out_window_value(in_window_value_6),
    .out_window_addr(in_window_addr_6),
    .out_window_valid(in_window_valid_6),
    .ready_for_new_event(out_event_req_5)
    );
// assign out_window_req_6 = 1;
wire out_feature_req_7;
nms5 #(
    .DATA_WIDTH((((DATA_WIDTH+3)*2+9)*2))
) nms5_inst (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_value(in_window_value_6),
    .in_window_valid(in_window_valid_6),
    .in_window_addr(in_window_addr_6),
    .ready_for_new_feature(ready_for_new_feature),
    .threshold(0),
    .out_isfeature(out_isfeature),
    .out_feature_addr(out_feature_addr),
    .out_feature_valid(out_feature_valid),
    .window_req(out_window_req_6)
    );

endmodule
