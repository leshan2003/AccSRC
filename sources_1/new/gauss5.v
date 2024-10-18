`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/16 16:39:37
// Design Name: 
// Module Name: gauss5
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


module gauss5 #(
    parameter PIXEL_WIDTH = 16
)(
    input clk,
    input rst_n,
    input in_valid,
    input wire [PIXEL_WIDTH*5*5-1:0] in_pixel,
    input wire [31:0] in_pixel_num,
    output wire [PIXEL_WIDTH+8-1:0] out_pixel,
    output wire out_valid,
    output wire [31:0] out_pixel_num
    );
reg [PIXEL_WIDTH+8-1:0] out_pixel_0;
reg out_valid_0;
reg [31:0] out_pixel_num_0;
wire [31:0] out_pixel_num_1;
assign out_valid = out_valid_0;
assign out_pixel = out_pixel_0;
assign out_pixel_num = out_pixel_num_0;

wire [PIXEL_WIDTH+8-1:0] sum_part_0;
wire tvalid_0;
gauss1d #(
    .PIXEL_WIDTH(PIXEL_WIDTH)
) gauss1d_0(
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
    .filtered_pixel_1d(sum_part_0),
    .tvalid(tvalid_0)
);
wire [PIXEL_WIDTH+8-1:0] sum_part_1;
wire tvalid_1;
gauss1d #(
    .PIXEL_WIDTH(PIXEL_WIDTH)
) gauss1d_1(
    .clk(clk),
    .rst_n(rst_n),
    .tready(in_valid),
    .pixel_0(in_pixel[PIXEL_WIDTH*5+PIXEL_WIDTH-1:PIXEL_WIDTH*5]),
    .pixel_1(in_pixel[PIXEL_WIDTH*6+PIXEL_WIDTH-1:PIXEL_WIDTH*6]),
    .pixel_2(in_pixel[PIXEL_WIDTH*7+PIXEL_WIDTH-1:PIXEL_WIDTH*7]),
    .pixel_3(in_pixel[PIXEL_WIDTH*8+PIXEL_WIDTH-1:PIXEL_WIDTH*8]),
    .pixel_4(in_pixel[PIXEL_WIDTH*9+PIXEL_WIDTH-1:PIXEL_WIDTH*9]),
    .filtered_pixel_1d(sum_part_1),
    .tvalid(tvalid_1)
);
wire [PIXEL_WIDTH+8-1:0] sum_part_2;
wire tvalid_2;
gauss1d #(
    .PIXEL_WIDTH(PIXEL_WIDTH)
) gauss1d_2(
    .clk(clk),
    .rst_n(rst_n),
    .tready(in_valid),
    .pixel_0(in_pixel[PIXEL_WIDTH*10+PIXEL_WIDTH-1:PIXEL_WIDTH*10]),
    .pixel_1(in_pixel[PIXEL_WIDTH*11+PIXEL_WIDTH-1:PIXEL_WIDTH*11]),
    .pixel_2(in_pixel[PIXEL_WIDTH*12+PIXEL_WIDTH-1:PIXEL_WIDTH*12]),
    .pixel_3(in_pixel[PIXEL_WIDTH*13+PIXEL_WIDTH-1:PIXEL_WIDTH*13]),
    .pixel_4(in_pixel[PIXEL_WIDTH*14+PIXEL_WIDTH-1:PIXEL_WIDTH*14]),
    .filtered_pixel_1d(sum_part_2),
    .tvalid(tvalid_2)
);
wire [PIXEL_WIDTH+8-1:0] sum_part_3;
wire tvalid_3;
gauss1d #(
    .PIXEL_WIDTH(PIXEL_WIDTH)
) gauss1d_3(
    .clk(clk),
    .rst_n(rst_n),
    .tready(in_valid),
    .pixel_0(in_pixel[PIXEL_WIDTH*15+PIXEL_WIDTH-1:PIXEL_WIDTH*15]),
    .pixel_1(in_pixel[PIXEL_WIDTH*16+PIXEL_WIDTH-1:PIXEL_WIDTH*16]),
    .pixel_2(in_pixel[PIXEL_WIDTH*17+PIXEL_WIDTH-1:PIXEL_WIDTH*17]),
    .pixel_3(in_pixel[PIXEL_WIDTH*18+PIXEL_WIDTH-1:PIXEL_WIDTH*18]),
    .pixel_4(in_pixel[PIXEL_WIDTH*19+PIXEL_WIDTH-1:PIXEL_WIDTH*19]),
    .filtered_pixel_1d(sum_part_3),
    .tvalid(tvalid_3)
);
wire [PIXEL_WIDTH+8-1:0] sum_part_4;
wire tvalid_4;
gauss1d #(
    .PIXEL_WIDTH(PIXEL_WIDTH)
) gauss1d_4(
    .clk(clk),
    .rst_n(rst_n),
    .tready(in_valid),
    .pixel_0(in_pixel[PIXEL_WIDTH*20+PIXEL_WIDTH-1:PIXEL_WIDTH*20]),
    .pixel_1(in_pixel[PIXEL_WIDTH*21+PIXEL_WIDTH-1:PIXEL_WIDTH*21]),
    .pixel_2(in_pixel[PIXEL_WIDTH*22+PIXEL_WIDTH-1:PIXEL_WIDTH*22]),
    .pixel_3(in_pixel[PIXEL_WIDTH*23+PIXEL_WIDTH-1:PIXEL_WIDTH*23]),
    .pixel_4(in_pixel[PIXEL_WIDTH*24+PIXEL_WIDTH-1:PIXEL_WIDTH*24]),
    .filtered_pixel_1d(sum_part_4),
    .tvalid(tvalid_4)
);
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out_pixel_0 <= 0;
        out_valid_0 <= 0;
        out_pixel_num_0 <= 0;
    end
    else begin
        if (tvalid_0 == 1 && tvalid_1 == 1 && tvalid_2 == 1 && tvalid_3 == 1 && tvalid_4 == 1) begin
            out_pixel_0 <= sum_part_0 + 4*sum_part_1 + 6*sum_part_2 + 4*sum_part_3 + sum_part_4;
            out_valid_0 <= 1;
            out_pixel_num_0 <= out_pixel_num_1;
        end
        else begin
            out_pixel_0 <= 0;
            out_valid_0 <= 0;
            out_pixel_num_0 <= 0;
        end
    end
end
endmodule
