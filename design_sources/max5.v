`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/07 22:21:17
// Design Name: 
// Module Name: max5
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


module max5 #(
    parameter DATA_WIDTH = 46
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH*5-1:0] in_window_value,
    input wire in_window_valid,
    output reg out_max_value,
    output reg ifmiddle,
    output reg out_max_valid
    );
wire [DATA_WIDTH-1:0] value0, value1, value2, value3, value4;
assign value0 = in_window_value[DATA_WIDTH*0+DATA_WIDTH-1:DATA_WIDTH*0];
assign value1 = in_window_value[DATA_WIDTH*1+DATA_WIDTH-1:DATA_WIDTH*1];
assign value2 = in_window_value[DATA_WIDTH*2+DATA_WIDTH-1:DATA_WIDTH*2];
assign value3 = in_window_value[DATA_WIDTH*3+DATA_WIDTH-1:DATA_WIDTH*3];
assign value4 = in_window_value[DATA_WIDTH*4+DATA_WIDTH-1:DATA_WIDTH*4];
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        out_max_valid <= 0;
        out_max_value <= 0;
        ifmiddle <= 0;
    end
    else begin
        if(in_window_valid) begin
            if(value0 >= value1 && value0 >= value2 && value0 >= value3 && value0 >= value4) begin
                out_max_value <= value0;
                ifmiddle <= 0;
                out_max_valid <= 1;
            end
            else if(value1 >= value0 && value1 >= value2 && value1 >= value3 && value1 >= value4) begin
                out_max_value <= value1;
                ifmiddle <= 0;
                out_max_valid <= 1;
            end
            else if(value2 >= value0 && value2 >= value1 && value2 >= value3 && value2 >= value4) begin
                out_max_value <= value2;
                ifmiddle <= 1;
                out_max_valid <= 1;
            end
            else if(value3 >= value0 && value3 >= value1 && value3 >= value2 && value3 >= value4) begin
                out_max_value <= value3;
                ifmiddle <= 0;
                out_max_valid <= 1;
            end
            else begin
                out_max_value <= value4;
                ifmiddle <= 0;
                out_max_valid <= 1;
            end
        end
        else begin
            out_max_valid <= 0;
            out_max_value <= 0;
            ifmiddle <= 0;
        end
    end
end
endmodule
