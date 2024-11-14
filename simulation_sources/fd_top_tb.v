`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/07 22:37:05
// Design Name: 
// Module Name: fd_top_tb
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


module fd_top_tb(

    );
reg clk, rst_n, in_event_valid_0;
reg [3:0] in_event_value_0;
reg [15:0] in_event_addr_0;
wire event_req, isfeature, feature_valid;
wire [15:0] feature_addr;

FD_top #(
    .DATA_WIDTH(4)
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
    in_event_valid_0 <= 0;
    in_event_addr_0 <= 0;
    in_event_value_0 <= 0;
    #5;
    in_event_value_0 <= 4'b1111;
    in_event_addr_0 <= {8'd48, 8'd48};
    in_event_valid_0 <= 1;
    #10;
    in_event_valid_0 <= 0;
    #4000;
    in_event_value_0 <= 4'b1000;
    in_event_addr_0 <= {8'd58, 8'd58};
    in_event_valid_0 <= 1;
    #10;
    in_event_valid_0 <= 0;
    #4000;
    in_event_value_0 <= 4'b1000;
    in_event_addr_0 <= {8'd68, 8'd58};
    in_event_valid_0 <= 1;
    #10;
    in_event_valid_0 <= 0;
end
endmodule
