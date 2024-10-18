`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/18 13:11:30
// Design Name: 
// Module Name: fddc_fifo
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


module fddc_fifo #(
    parameter FD_HALF_WINDOW_SUM = 5,
    parameter DC_HALF_WINDOW_SUM = 17,
    parameter FIFODEPTH = 32,
    parameter ORI_IMAGE_WIDTH = 640,
    parameter ORI_IMAGE_HEIGHT = 287
)(
    input clk,
    input rst_n,
    input wire [31:0] fd_pixel_num,
    input wire fd_isfeature,
    input wire fd_valid,
    input wire [255:0] dc_descriptor,
    input wire [31:0] dc_descriptor_num,
    input wire dc_valid,
    output wire [31:0] out_feature_num,
    output wire [255:0] out_feature_descriptor,
    output wire out_feature_valid
    );
reg [31:0] out_feature_num_0;
reg [255:0] out_feature_descriptor_0;
reg out_feature_valid_0;
assign out_feature_num = out_feature_num_0;
assign out_feature_descriptor = out_feature_descriptor_0;
assign out_feature_valid = out_feature_valid_0;
reg [FIFODEPTH*32-1:0] fd_pixel_num_fifo;
reg [FIFODEPTH*32-1:0] dc_descriptor_num_fifo;
reg [FIFODEPTH*255-1:0] dc_descriptor_fifo;
reg [7:0] fd_feature_cnt;
reg [7:0] dc_descriptor_cnt;
reg [31:0] modified_fd_pixel_num;
reg [31:0] modified_dc_pixel_num;
initial begin
    fd_feature_cnt <= 0;
    dc_descriptor_cnt <= 0;
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out_feature_num_0 <= 0;
        out_feature_descriptor_0 <= 0;
        out_feature_valid_0 <= 0;
        fd_pixel_num_fifo <= 0;
        dc_descriptor_num_fifo <= 0;
        dc_descriptor_fifo <= 0;
        fd_feature_cnt <= 0;
        dc_descriptor_cnt <= 0;
        modified_fd_pixel_num <= 0;
        modified_dc_pixel_num <= 0;
    end
    else begin
        if (fd_valid == 1 && fd_isfeature == 1) begin
            modified_fd_pixel_num <= (fd_pixel_num / (ORI_IMAGE_WIDTH-2*FD_HALF_WINDOW_SUM)) * ORI_IMAGE_WIDTH + (fd_pixel_num % (ORI_IMAGE_WIDTH-2*FD_HALF_WINDOW_SUM)) + FD_HALF_WINDOW_SUM;
            if (modified_dc_pixel_num >= HALF_WINDOW_SIZE*ORI_IMAGE_WIDTH+DC_HALF_WINDOW_SUM) begin
                if (fd_feature_cnt < FIFODEPTH) begin
                    case (fd_feature_cnt)
                        0: begin fd_pixel_num_fifo[31:0]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        1: begin fd_pixel_num_fifo[63:32]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        2: begin fd_pixel_num_fifo[95:64]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        3: begin fd_pixel_num_fifo[127:96]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        4: begin fd_pixel_num_fifo[159:128]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        5: begin fd_pixel_num_fifo[191:160]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        6: begin fd_pixel_num_fifo[223:192]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        7: begin fd_pixel_num_fifo[255:224]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        8: begin fd_pixel_num_fifo[287:256]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        9: begin fd_pixel_num_fifo[319:288]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        10: begin fd_pixel_num_fifo[351:320]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        11: begin fd_pixel_num_fifo[383:352]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        12: begin fd_pixel_num_fifo[415:384]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        13: begin fd_pixel_num_fifo[447:416]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        14: begin fd_pixel_num_fifo[479:448]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        15: begin fd_pixel_num_fifo[511:480]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        16: begin fd_pixel_num_fifo[543:512]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        17: begin fd_pixel_num_fifo[575:544]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        18: begin fd_pixel_num_fifo[607:576]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        19: begin fd_pixel_num_fifo[639:608]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        20: begin fd_pixel_num_fifo[671:640]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        21: begin fd_pixel_num_fifo[703:672]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        22: begin fd_pixel_num_fifo[735:704]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        23: begin fd_pixel_num_fifo[767:736]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        24: begin fd_pixel_num_fifo[799:768]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        25: begin fd_pixel_num_fifo[831:800]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        26: begin fd_pixel_num_fifo[863:832]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        27: begin fd_pixel_num_fifo[895:864]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        28: begin fd_pixel_num_fifo[927:896]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        29: begin fd_pixel_num_fifo[959:928]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        30: begin fd_pixel_num_fifo[991:960]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                        31: begin fd_pixel_num_fifo[1023:992]<=fd_pixel_num; fd_feature_cnt<=fd_feature_cnt+1; end
                    endcase
                end
                else begin
                    fd_pixel_num_fifo[991:0] <= fd_pixel_num_fifo[1023:32];
                    fd_pixel_num_fifo[1023:992] <= fd_pixel_num;
                end
            end
        end
        if (dc_valid) begin
            if (dc_descriptor_cnt < FIFODEPTH) begin
                case
                    0: begin dc_descriptor_fifo[1*256-1:0*256] <= dc_descriptor; dc_descriptor_num_fifo[1*32-1:0*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    1: begin dc_descriptor_fifo[2*256-1:1*256] <= dc_descriptor; dc_descriptor_num_fifo[2*32-1:1*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    2: begin dc_descriptor_fifo[3*256-1:2*256] <= dc_descriptor; dc_descriptor_num_fifo[3*32-1:2*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    3: begin dc_descriptor_fifo[4*256-1:3*256] <= dc_descriptor; dc_descriptor_num_fifo[4*32-1:3*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    4: begin dc_descriptor_fifo[5*256-1:4*256] <= dc_descriptor; dc_descriptor_num_fifo[5*32-1:4*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    5: begin dc_descriptor_fifo[6*256-1:5*256] <= dc_descriptor; dc_descriptor_num_fifo[6*32-1:5*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    6: begin dc_descriptor_fifo[7*256-1:6*256] <= dc_descriptor; dc_descriptor_num_fifo[7*32-1:6*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    7: begin dc_descriptor_fifo[8*256-1:7*256] <= dc_descriptor; dc_descriptor_num_fifo[8*32-1:7*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    8: begin dc_descriptor_fifo[9*256-1:8*256] <= dc_descriptor; dc_descriptor_num_fifo[9*32-1:8*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    9: begin dc_descriptor_fifo[10*256-1:9*256] <= dc_descriptor; dc_descriptor_num_fifo[10*32-1:9*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    10: begin dc_descriptor_fifo[11*256-1:10*256] <= dc_descriptor; dc_descriptor_num_fifo[11*32-1:10*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    11: begin dc_descriptor_fifo[12*256-1:11*256] <= dc_descriptor; dc_descriptor_num_fifo[12*32-1:11*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    12: begin dc_descriptor_fifo[13*256-1:12*256] <= dc_descriptor; dc_descriptor_num_fifo[13*32-1:12*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    13: begin dc_descriptor_fifo[14*256-1:13*256] <= dc_descriptor; dc_descriptor_num_fifo[14*32-1:13*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    14: begin dc_descriptor_fifo[15*256-1:14*256] <= dc_descriptor; dc_descriptor_num_fifo[15*32-1:14*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    15: begin dc_descriptor_fifo[16*256-1:15*256] <= dc_descriptor; dc_descriptor_num_fifo[16*32-1:15*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    16: begin dc_descriptor_fifo[17*256-1:16*256] <= dc_descriptor; dc_descriptor_num_fifo[17*32-1:16*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    17: begin dc_descriptor_fifo[18*256-1:17*256] <= dc_descriptor; dc_descriptor_num_fifo[18*32-1:17*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    18: begin dc_descriptor_fifo[19*256-1:18*256] <= dc_descriptor; dc_descriptor_num_fifo[19*32-1:18*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    19: begin dc_descriptor_fifo[20*256-1:19*256] <= dc_descriptor; dc_descriptor_num_fifo[20*32-1:19*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    20: begin dc_descriptor_fifo[21*256-1:20*256] <= dc_descriptor; dc_descriptor_num_fifo[21*32-1:20*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    21: begin dc_descriptor_fifo[22*256-1:21*256] <= dc_descriptor; dc_descriptor_num_fifo[22*32-1:21*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    22: begin dc_descriptor_fifo[23*256-1:22*256] <= dc_descriptor; dc_descriptor_num_fifo[23*32-1:22*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    23: begin dc_descriptor_fifo[24*256-1:23*256] <= dc_descriptor; dc_descriptor_num_fifo[24*32-1:23*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    24: begin dc_descriptor_fifo[25*256-1:24*256] <= dc_descriptor; dc_descriptor_num_fifo[25*32-1:24*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    25: begin dc_descriptor_fifo[26*256-1:25*256] <= dc_descriptor; dc_descriptor_num_fifo[26*32-1:25*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    26: begin dc_descriptor_fifo[27*256-1:26*256] <= dc_descriptor; dc_descriptor_num_fifo[27*32-1:26*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    27: begin dc_descriptor_fifo[28*256-1:27*256] <= dc_descriptor; dc_descriptor_num_fifo[28*32-1:27*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    28: begin dc_descriptor_fifo[29*256-1:28*256] <= dc_descriptor; dc_descriptor_num_fifo[29*32-1:28*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    29: begin dc_descriptor_fifo[30*256-1:29*256] <= dc_descriptor; dc_descriptor_num_fifo[30*32-1:29*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    30: begin dc_descriptor_fifo[31*256-1:30*256] <= dc_descriptor; dc_descriptor_num_fifo[31*32-1:30*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                    31: begin dc_descriptor_fifo[32*256-1:31*256] <= dc_descriptor; dc_descriptor_num_fifo[32*32-1:31*32] <= dc_descriptor_num; descriptor_cnt <= descriptor_cnt + 1; end
                endcase
            end
            else begin
                dc_descriptor_fifo[31*256-1:0*256] <= dc_descriptor_fifo[32*256-1:1*256];
                dc_descriptor_num_fifo[31*32-1:0*32] <= dc_descriptor_num_fifo[32*32-1:1*32];
                dc_descriptor_fifo[32*256-1:31*256] <= dc_descriptor;
                dc_descriptor_num_fifo[32*32-1:31*32] <= dc_descriptor_num;
            end
        end
        if (fd_pixel_num_fifo[31:0] == dc_descriptor_num_fifo[31:0] && fd_pixel_num_fifo[31:0] != 0) begin
            out_feature_num_0 <= fd_pixel_num_fifo[31:0];
            out_feature_descriptor_0 <= dc_descriptor_fifo[31*256-1:0*256];
            out_feature_valid_0 <= 1;
            fd_pixel_num_fifo[991:0] <= fd_pixel_num_fifo[1023:32];
            dc_descriptor_fifo[31*256-1:0*256] <= dc_descriptor_fifo[32*256-1:1*256];
            dc_descriptor_num_fifo[31*32-1:0*32] <= dc_descriptor_num_fifo[32*32-1:1*32];
            fd_feature_cnt <= fd_feature_cnt - 1;
            dc_descriptor_cnt <= dc_descriptor_cnt - 1;
        end
        else begin
            out_feature_valid_0 <= 0;
        end
    end
end
endmodule
