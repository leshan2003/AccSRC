`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/16 19:38:02
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
    parameter PIXEL_WIDTH = 46
)(
    input clk,
    input rst_n,
    input in_valid,
    input wire [PIXEL_WIDTH*5*5-1:0] in_pixel,
    input wire [31:0] in_pixel_num,
    input wire [PIXEL_WIDTH-1:0] threshold,
    output wire isfeature,
    output wire out_valid,
    output wire [31:0] out_pixel_num
    );
reg isfeature_0;
reg out_valid_0;
reg [31:0] out_pixel_num_0;
wire [31:0] out_pixel_num_1;
assign out_valid = out_valid_0;
assign isfeature = isfeature_0;
assign out_pixel_num = out_pixel_num_0;

wire [45:0] max_pixel_0;
wire ifmiddle_0;
wire tvalid_0;
max5 max5_0(
    .clk(clk),
    .rst_n(rst_n),
    .tready(in_valid),
    .in_pixel_num(in_pixel_num),
    .pixel_0(in_pixel[PIXEL_WIDTH*0+PIXEL_WIDTH-1:PIXEL_WIDTH*0]),
    .pixel_1(in_pixel[PIXEL_WIDTH*1+PIXEL_WIDTH-1:PIXEL_WIDTH*1]),
    .pixel_2(in_pixel[PIXEL_WIDTH*2+PIXEL_WIDTH-1:PIXEL_WIDTH*2]),
    .pixel_3(in_pixel[PIXEL_WIDTH*3+PIXEL_WIDTH-1:PIXEL_WIDTH*3]),
    .pixel_4(in_pixel[PIXEL_WIDTH*4+PIXEL_WIDTH-1:PIXEL_WIDTH*4]),
    .out_pixel_num(out_pixel_num_1),
    .max_pixel(max_pixel_0),
    .ifmiddle(ifmiddle_0),
    .tvalid(tvalid_0)
);

wire [45:0] max_pixel_1;
wire ifmiddle_1;
wire tvalid_1;
max5 max5_1(
    .clk(clk),
    .rst_n(rst_n),
    .tready(in_valid),
    .pixel_0(in_pixel[PIXEL_WIDTH*5+PIXEL_WIDTH-1:PIXEL_WIDTH*5]),
    .pixel_1(in_pixel[PIXEL_WIDTH*6+PIXEL_WIDTH-1:PIXEL_WIDTH*6]),
    .pixel_2(in_pixel[PIXEL_WIDTH*7+PIXEL_WIDTH-1:PIXEL_WIDTH*7]),
    .pixel_3(in_pixel[PIXEL_WIDTH*8+PIXEL_WIDTH-1:PIXEL_WIDTH*8]),
    .pixel_4(in_pixel[PIXEL_WIDTH*9+PIXEL_WIDTH-1:PIXEL_WIDTH*9]),
    .max_pixel(max_pixel_1),
    .ifmiddle(ifmiddle_1),
    .tvalid(tvalid_1)
);

wire [45:0] max_pixel_2;
wire ifmiddle_2;
wire tvalid_2;
max5 max5_2(
    .clk(clk),
    .rst_n(rst_n),
    .tready(in_valid),
    .pixel_0(in_pixel[PIXEL_WIDTH*10+PIXEL_WIDTH-1:PIXEL_WIDTH*10]),
    .pixel_1(in_pixel[PIXEL_WIDTH*11+PIXEL_WIDTH-1:PIXEL_WIDTH*11]),
    .pixel_2(in_pixel[PIXEL_WIDTH*12+PIXEL_WIDTH-1:PIXEL_WIDTH*12]),
    .pixel_3(in_pixel[PIXEL_WIDTH*13+PIXEL_WIDTH-1:PIXEL_WIDTH*13]),
    .pixel_4(in_pixel[PIXEL_WIDTH*14+PIXEL_WIDTH-1:PIXEL_WIDTH*14]),
    .max_pixel(max_pixel_2),
    .ifmiddle(ifmiddle_2),
    .tvalid(tvalid_2)
);

wire [45:0] max_pixel_3;
wire ifmiddle_3;
wire tvalid_3;
max5 max5_3(
    .clk(clk),
    .rst_n(rst_n),
    .tready(in_valid),
    .pixel_0(in_pixel[PIXEL_WIDTH*15+PIXEL_WIDTH-1:PIXEL_WIDTH*15]),
    .pixel_1(in_pixel[PIXEL_WIDTH*16+PIXEL_WIDTH-1:PIXEL_WIDTH*16]),
    .pixel_2(in_pixel[PIXEL_WIDTH*17+PIXEL_WIDTH-1:PIXEL_WIDTH*17]),
    .pixel_3(in_pixel[PIXEL_WIDTH*18+PIXEL_WIDTH-1:PIXEL_WIDTH*18]),
    .pixel_4(in_pixel[PIXEL_WIDTH*19+PIXEL_WIDTH-1:PIXEL_WIDTH*19]),
    .max_pixel(max_pixel_3),
    .ifmiddle(ifmiddle_3),
    .tvalid(tvalid_3)
);

wire [45:0] max_pixel_4;
wire ifmiddle_4;
wire tvalid_4;
max5 max5_4(
    .clk(clk),
    .rst_n(rst_n),
    .tready(in_valid),
    .pixel_0(in_pixel[PIXEL_WIDTH*20+PIXEL_WIDTH-1:PIXEL_WIDTH*20]),
    .pixel_1(in_pixel[PIXEL_WIDTH*21+PIXEL_WIDTH-1:PIXEL_WIDTH*21]),
    .pixel_2(in_pixel[PIXEL_WIDTH*22+PIXEL_WIDTH-1:PIXEL_WIDTH*22]),
    .pixel_3(in_pixel[PIXEL_WIDTH*23+PIXEL_WIDTH-1:PIXEL_WIDTH*23]),
    .pixel_4(in_pixel[PIXEL_WIDTH*24+PIXEL_WIDTH-1:PIXEL_WIDTH*24]),
    .max_pixel(max_pixel_4),
    .ifmiddle(ifmiddle_4),
    .tvalid(tvalid_4)
);
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        isfeature_0 <= 0;
        out_valid_0 <= 0;
        out_pixel_num_0 <= 0;
    end
    else begin
        if (tvalid_0 == 1 && tvalid_1 == 1 && tvalid_2 == 1 && tvalid_3 == 1 && tvalid_4 == 1) begin
            out_pixel_num_0 <= out_pixel_num_1;
            if (ifmiddle_2 == 0) begin
                isfeature_0 <= 0;
                out_valid_0 <= 1;
            end
            else begin
                if (max_pixel_2 < threshold) begin
                    isfeature_0 <= 0;
                    out_valid_0 <= 1;
                end
                else if (max_pixel_2 > max_pixel_0 && max_pixel_2 > max_pixel_1 && max_pixel_2 > max_pixel_3 && max_pixel_2 > max_pixel_4) begin
                    isfeature_0 <= 1;
                    out_valid_0 <= 1;
                end
                else begin
                    isfeature_0 <= 0;
                    out_valid_0 <= 1;
                end
            end
        end
        else begin
            isfeature_0 <= 0;
            out_valid_0 <= 0;
            out_pixel_num_0 <= 0;
        end
    end
end
endmodule
