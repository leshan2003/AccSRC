`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/08 16:07:34
// Design Name: 
// Module Name: raw_event_dispatcher
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


module raw_event_dispatcher #(
    parameter EventMEM_DEPTH = 1000,
    parameter DATA_WIDTH = 4,
    parameter eventvaluefile = "D:/Event/eventvalue.txt",
    parameter eventaddrrowfile = "D:/Event/eventaddrrow.txt",
    parameter eventaddrcolfile = "D:/Event/eventaddrcol.txt"
)(
    input wire clk,
    input wire rst_n,
    input wire out_event_req_0,
    output reg in_event_valid_0,
    output reg [DATA_WIDTH-1:0] in_event_value_0,
    output reg [15:0] in_event_addr_0
    );
reg [DATA_WIDTH-1:0] event_value_mem [0:EventMEM_DEPTH-1];
reg [7:0] event_addrrow_mem [0:EventMEM_DEPTH-1];
reg [7:0] event_addrcol_mem [0:EventMEM_DEPTH-1];
reg [15:0] event_cnt;
wire [7:0] row = event_addrrow_mem[event_cnt];
wire [7:0] col = event_addrcol_mem[event_cnt];
reg wait_reg;
initial begin
    $readmemh(eventvaluefile, event_value_mem);
    $readmemh(eventaddrrowfile, event_addrrow_mem);
    $readmemh(eventaddrcolfile, event_addrcol_mem);
    in_event_valid_0 <= 0;
    in_event_value_0 <= 0;
    in_event_addr_0 <= 0;
    event_cnt <= 0;
    wait_reg <= 0;
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        $readmemh(eventvaluefile, event_value_mem);
        $readmemh(eventaddrrowfile, event_addrrow_mem);
        $readmemh(eventaddrcolfile, event_addrcol_mem);
        in_event_valid_0 <= 0;
        in_event_value_0 <= 0;
        in_event_addr_0 <= 0;
        event_cnt <= 0;
        wait_reg <= 0;
    end else begin
        if (out_event_req_0 && wait_reg == 0) begin
            in_event_valid_0 <= 1;
            in_event_value_0 <= event_value_mem[event_cnt];
            in_event_addr_0 <= {event_addrrow_mem[event_cnt], event_addrcol_mem[event_cnt]};
            event_cnt <= event_cnt + 1;
            wait_reg <= 1;
        end
        else begin
            wait_reg <= 0;
            in_event_valid_0 <= 0;
        end
    end
end
endmodule
