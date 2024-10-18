`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/16 15:32:44
// Design Name: 
// Module Name: lb_tb
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


module lb_tb(

    );
parameter IMAGE_WIDTH = 640;
parameter IMAGE_HEIGHT = 287;
parameter HALF_WINDOW_SIZE = 2;
parameter PIXEL_WIDTH = 8;
reg clk;
reg [PIXEL_WIDTH-1:0] in_pixel;
reg [31:0] in_pixel_num;
reg in_valid;
wire [PIXEL_WIDTH*(2*HALF_WINDOW_SIZE+1)*(2*HALF_WINDOW_SIZE+1)-1:0] out_pixel;
wire [31:0] out_pixel_num;
wire out_valid;
linebuffer #(
    .IMAGE_WIDTH(IMAGE_WIDTH),
    .IMAGE_HEIGHT(IMAGE_HEIGHT),
    .HALF_WINDOW_SIZE(HALF_WINDOW_SIZE),
    .PIXEL_WIDTH(PIXEL_WIDTH)
) lb (
    .clk(clk),
    .rst_n(1'b1),
    .in_pixel(in_pixel),
    .in_pixel_num(in_pixel_num),
    .in_valid(in_valid),
    .out_pixel(out_pixel),
    .out_pixel_num(out_pixel_num),
    .out_valid(out_valid)
    );
integer k,fd;
always #10 clk = ~clk;
initial begin
    clk = 1;
    k = 0;
    in_pixel = 0;
    in_valid = 0;
    in_pixel_num = 0;
    fd = $fopen("D:/Creativity/01_SLAM_VO_Accelerator/png2int8py/199.dat", "r");
    #20;
    // for (k=0; k<640*287; k=k+1) begin
    //     $fscanf(fd, "%d", in_pixel);
    //     in_valid = 1;
    //     #20;
    // end
    $fclose(fd);
    for (k=0; k<640*287; k=k+1) begin
        in_pixel = k % 5;
        in_valid = 1;
        in_pixel_num = in_pixel_num + 1;
        #20;
    end
end
endmodule
