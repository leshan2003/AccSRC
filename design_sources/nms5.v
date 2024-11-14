`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/07 22:21:07
// Design Name: 
// Module Name: nms5
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


module nms5 #(
    parameter DATA_WIDTH = 46
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH*5*5-1:0] in_window_value,
    input wire in_window_valid,
    input wire [15:0] in_window_addr,
    input wire ready_for_new_feature,       // next block is ready for new feature
    input wire threshold,
    output reg out_isfeature,
    output reg [15:0] out_feature_addr,
    output reg out_feature_valid,
    output wire window_req                  // NMS5 is ready for new window
    );
assign window_req = ready_for_new_feature;

wire [DATA_WIDTH-1:0] out_max_value_0, out_max_value_1, out_max_value_2, out_max_value_3, out_max_value_4;
wire ifmiddle_0, ifmiddle_1, ifmiddle_2, ifmiddle_3, ifmiddle_4, out_max_valid_0, out_max_valid_1, out_max_valid_2, out_max_valid_3, out_max_valid_4;
max5 #(
    .DATA_WIDTH(DATA_WIDTH)
) max5_inst_0 (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_value(in_window_value[DATA_WIDTH*5*0+DATA_WIDTH*5-1:DATA_WIDTH*5*0]),
    .in_window_valid(in_window_valid),
    .out_max_value(out_max_value_0),
    .ifmiddle(ifmiddle_0),
    .out_max_valid(out_max_valid_0)
    );
max5 #(
    .DATA_WIDTH(DATA_WIDTH)
) max5_inst_1 (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_value(in_window_value[DATA_WIDTH*5*1+DATA_WIDTH*5-1:DATA_WIDTH*5*1]),
    .in_window_valid(in_window_valid),
    .out_max_value(out_max_value_1),
    .ifmiddle(ifmiddle_1),
    .out_max_valid(out_max_valid_1)
    );
max5 #(
    .DATA_WIDTH(DATA_WIDTH)
) max5_inst_2 (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_value(in_window_value[DATA_WIDTH*5*2+DATA_WIDTH*5-1:DATA_WIDTH*5*2]),
    .in_window_valid(in_window_valid),
    .out_max_value(out_max_value_2),
    .ifmiddle(ifmiddle_2),
    .out_max_valid(out_max_valid_2)
    );
max5 #(
    .DATA_WIDTH(DATA_WIDTH)
) max5_inst_3 (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_value(in_window_value[DATA_WIDTH*5*3+DATA_WIDTH*5-1:DATA_WIDTH*5*3]),
    .in_window_valid(in_window_valid),
    .out_max_value(out_max_value_3),
    .ifmiddle(ifmiddle_3),
    .out_max_valid(out_max_valid_3)
    );
max5 #(
    .DATA_WIDTH(DATA_WIDTH)
) max5_inst_4 (
    .clk(clk),
    .rst_n(rst_n),
    .in_window_value(in_window_value[DATA_WIDTH*5*4+DATA_WIDTH*5-1:DATA_WIDTH*5*4]),
    .in_window_valid(in_window_valid),
    .out_max_value(out_max_value_4),
    .ifmiddle(ifmiddle_4),
    .out_max_valid(out_max_valid_4)
    );

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        out_isfeature <= 0;
        out_feature_addr <= 0;
        out_feature_valid <= 0;
    end
    else begin
        if(out_max_valid_0 == 1 && out_max_valid_1 == 1 && out_max_valid_2 == 1 && out_max_valid_3 == 1 && out_max_valid_4 == 1) begin
            out_feature_addr <= in_window_addr;
            if(ifmiddle_2 == 0) begin
                out_isfeature <= 0;
                out_feature_valid <= 1;
            end
            else begin
                if(out_max_value_2 < threshold) begin
                    out_isfeature <= 0;
                    out_feature_valid <= 1;
                end
                else begin
                    if(out_max_value_2 >= out_max_value_0 && out_max_value_2 >= out_max_value_1 && out_max_value_2 >= out_max_value_3 && out_max_value_2 >= out_max_value_4) begin
                        out_isfeature <= 1;
                        out_feature_valid <= 1;
                    end
                    else begin
                        out_isfeature <= 0;
                        out_feature_valid <= 1;
                    end
                end
            end
        end
        else begin
            out_isfeature <= 0;
            out_feature_addr <= 0;
            out_feature_valid <= 0;
        end
    end
end
endmodule
