`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/16 14:57:00
// Design Name: 
// Module Name: linebuffer
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


module linebuffer #(
    parameter IMAGE_WIDTH = 640,
    parameter IMAGE_HEIGHT = 287,
    parameter HALF_WINDOW_SIZE = 2,
    parameter PIXEL_WIDTH = 8
)(
    input clk,
    input rst_n,
    input wire [PIXEL_WIDTH-1:0] in_pixel,
    input wire [31:0] in_pixel_num,
    input wire in_valid,
    output wire [PIXEL_WIDTH*(2*HALF_WINDOW_SIZE+1)*(2*HALF_WINDOW_SIZE+1)-1:0] out_pixel,
    output reg [31:0] out_pixel_num,
    output reg out_valid
    );

// internal registers
reg [PIXEL_WIDTH-1:0] lb [0:(2*HALF_WINDOW_SIZE)*IMAGE_WIDTH-1];
reg [PIXEL_WIDTH-1:0] onemoreline [0:2*HALF_WINDOW_SIZE];
reg [31:0] last_in_pixel_num;
// reg isvalid;
// combinatorial logic
generate
    genvar g;
    genvar q;
    for (g = 0; g < (2*HALF_WINDOW_SIZE+1); g = g + 1) begin
        for (q = 0; q < (2*HALF_WINDOW_SIZE); q = q + 1) begin
            assign out_pixel[g*PIXEL_WIDTH+q*(2*HALF_WINDOW_SIZE+1)*PIXEL_WIDTH+PIXEL_WIDTH-1:g*PIXEL_WIDTH+q*(2*HALF_WINDOW_SIZE+1)*PIXEL_WIDTH] = lb[g+q*IMAGE_WIDTH];
        end
        assign out_pixel[g*PIXEL_WIDTH+(2*HALF_WINDOW_SIZE)*(2*HALF_WINDOW_SIZE+1)*PIXEL_WIDTH+PIXEL_WIDTH-1:g*PIXEL_WIDTH+(2*HALF_WINDOW_SIZE)*(2*HALF_WINDOW_SIZE+1)*PIXEL_WIDTH] = onemoreline[g];
    end
endgenerate

// assign out_position_offset = in_position_offset + HALF_WINDOW_SIZE;
// assign position_col = col_counter-1;
// assign position_row = row_counter;
// assign out_valid = ((col_counter>=2*HALF_WINDOW_SIZE+1) && (row_counter>=2*HALF_WINDOW_SIZE));
integer k;

// sequential logic
initial begin
    out_pixel_num = 0;
    last_in_pixel_num = 0;
    out_valid = 0;
    for (k=0; k<(2*HALF_WINDOW_SIZE)*IMAGE_WIDTH; k=k+1) begin
        lb[k] <= 0;
    end
    for (k=0; k<2*HALF_WINDOW_SIZE+1; k=k+1) begin
        onemoreline[k] <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        out_pixel_num <= 0;
        last_in_pixel_num <= 0;
        out_valid <= 0;
        for (k=0; k<(2*HALF_WINDOW_SIZE)*IMAGE_WIDTH; k=k+1) begin
            lb[k] <= 0;
        end
        for (k=0; k<2*HALF_WINDOW_SIZE+1; k=k+1) begin
            onemoreline[k] <= 0;
        end
    end
    else begin
        if (in_valid) begin
            if (in_pixel_num == last_in_pixel_num + 1) begin
                // shift left
                for (k=0; k<(2*HALF_WINDOW_SIZE*IMAGE_WIDTH-1); k=k+1) begin
                    lb[k] <= lb[k+1];
                end
                lb[(2*HALF_WINDOW_SIZE)*IMAGE_WIDTH-1] <= onemoreline[0];
                for (k=0; k<(2*HALF_WINDOW_SIZE); k=k+1) begin
                    onemoreline[k] <= onemoreline[k+1];
                end
                onemoreline[2*HALF_WINDOW_SIZE] <= in_pixel;
                // counter
                if (in_pixel_num>(HALF_WINDOW_SIZE*2*IMAGE_WIDTH) && ((in_pixel_num%IMAGE_WIDTH)>(2*HALF_WINDOW_SIZE) || (in_pixel_num%IMAGE_WIDTH)==0)) begin
                    out_pixel_num <= out_pixel_num + 1;
                    out_valid <= 1;
                end
                else begin
                    out_valid <= 0;
                end
                last_in_pixel_num <= in_pixel_num;
            end
        end
    end
end

endmodule
