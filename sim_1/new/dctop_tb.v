`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/18 12:44:15
// Design Name: 
// Module Name: dctop_tb
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


module dctop_tb(

    );
reg clk;
reg [7:0] in_pixel;
reg in_valid;
reg [31:0] in_pixel_num;
wire [255:0] out_descriptor;
wire out_valid;
wire [31:0] out_descriptor_num;
dctop dctop1 (
    .clk(clk),
    .rst_n(1'b1),
    .in_pixel(in_pixel),
    .in_valid(in_valid),
    .in_pixel_num(in_pixel_num),
    .out_descriptor(out_descriptor),
    .out_valid(out_valid),
    .out_descriptor_num(out_descriptor_num)
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
    for (k=0; k<640*287; k=k+1) begin
        $fscanf(fd, "%d", in_pixel);
        in_valid <= 1;
        in_pixel_num <= in_pixel_num + 1;
        #20;
    end
    $fclose(fd);
    // for (k=0; k<640*287; k=k+1) begin
    //     in_pixel <= k % 5;
    //     in_valid <= 1;
    //     in_pixel_num <= in_pixel_num + 1;
    //     #20;
    // end
end
endmodule
