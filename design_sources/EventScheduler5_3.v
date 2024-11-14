`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/07 12:23:19
// Design Name: 
// Module Name: EventScheduler5_3
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


module EventScheduler5_3 #(
    parameter DATA_WIDTH = 14,
    parameter HALF_WINDOW_SIZE = 2,
    parameter WINDOW_SIZE = 2*HALF_WINDOW_SIZE+1,
    parameter TODO_WINDOW_FIFO_DEPTH = 64,
    parameter HASH_MEM_DEPTH = 256
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH-1:0] in_event_value_xx,
    input wire [DATA_WIDTH-0:0] in_event_value_xy,
    input wire [DATA_WIDTH-1:0] in_event_value_yy,
    input wire [16-1:0] in_event_addr,
    input wire in_event_valid,
    input wire window_req,                  // the next computing block needing a new event from EventScheduler
    output wire [WINDOW_SIZE*WINDOW_SIZE*DATA_WIDTH-1:0] out_window_value_xx,
    output wire [WINDOW_SIZE*WINDOW_SIZE*(DATA_WIDTH+1)-1:0] out_window_value_xy,
    output wire [WINDOW_SIZE*WINDOW_SIZE*DATA_WIDTH-1:0] out_window_value_yy,
    output reg [16-1:0] out_window_addr,
    output reg out_window_valid,
    output wire ready_for_new_event         // EventScheduler being ready to receive a new event
    );
wire [8-1:0] in_event_addr_col;
wire [8-1:0] in_event_addr_row;
assign in_event_addr_col = in_event_addr[8-1:0];
assign in_event_addr_row = in_event_addr[16-1:8];
reg [16-1:0] last_event_addr;
wire [15:0] event_addr_diff = in_event_addr - last_event_addr;
reg [DATA_WIDTH-1:0] last_event_value_xx;
reg [DATA_WIDTH-0:0] last_event_value_xy;
reg [DATA_WIDTH-1:0] last_event_value_yy;
reg [16-1:0] last_available_window_addr;
reg [16-1:0] todo_window_addr_fifo [0:TODO_WINDOW_FIFO_DEPTH-1][0:WINDOW_SIZE-1];
wire [15:0] diff10 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[1]][1] - todo_window_addr_fifo[todo_window_addr_fifo_rdpt[0]][0];
wire [15:0] diff20 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[2]][2] - todo_window_addr_fifo[todo_window_addr_fifo_rdpt[0]][0];
wire [15:0] diff30 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[3]][3] - todo_window_addr_fifo[todo_window_addr_fifo_rdpt[0]][0];
wire [15:0] diff40 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[4]][4] - todo_window_addr_fifo[todo_window_addr_fifo_rdpt[0]][0];
wire [15:0] diff21 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[2]][2] - todo_window_addr_fifo[todo_window_addr_fifo_rdpt[1]][1];
wire [15:0] diff31 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[3]][3] - todo_window_addr_fifo[todo_window_addr_fifo_rdpt[1]][1];
wire [15:0] diff41 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[4]][4] - todo_window_addr_fifo[todo_window_addr_fifo_rdpt[1]][1];
wire [15:0] diff32 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[3]][3] - todo_window_addr_fifo[todo_window_addr_fifo_rdpt[2]][2];
wire [15:0] diff42 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[4]][4] - todo_window_addr_fifo[todo_window_addr_fifo_rdpt[2]][2];
wire [15:0] diff43 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[4]][4] - todo_window_addr_fifo[todo_window_addr_fifo_rdpt[3]][3];
wire [15:0] diff0 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[0]][0] - last_available_window_addr;
wire [15:0] diff1 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[1]][1] - last_available_window_addr;
wire [15:0] diff2 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[2]][2] - last_available_window_addr;
wire [15:0] diff3 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[3]][3] - last_available_window_addr;
wire [15:0] diff4 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[4]][4] - last_available_window_addr;
wire [15:0] sel0 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[0]][0] - min_todo_addr - 1;
wire [15:0] sel1 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[1]][1] - min_todo_addr - 1;
wire [15:0] sel2 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[2]][2] - min_todo_addr - 1;
wire [15:0] sel3 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[3]][3] - min_todo_addr - 1;
wire [15:0] sel4 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[4]][4] - min_todo_addr - 1;
reg [6:0] todo_window_addr_fifo_wrpt[0:WINDOW_SIZE-1];
reg [6:0] todo_window_addr_fifo_rdpt[0:WINDOW_SIZE-1];
reg [16-1:0] min_todo_addr;

reg [2:0] state;
reg [3:0] wait_cnt;
assign ready_for_new_event = (state == 3'b000);
integer i,j;

reg EventFIFO_write_enable;
reg [16-1:0] EventFIFO_read_window_addr;
reg EventFIFO_read_req;
wire EventFIFO_write_done;
wire EventFIFO_read_window_valid;
EventFIFO5_3_hash #(
    .DATA_WIDTH(DATA_WIDTH),
    .MEM_DEPTH(HASH_MEM_DEPTH),
    .HALF_WINDOW_SIZE(HALF_WINDOW_SIZE)
) EventFIFO5_3_hash_inst (
    .clk(clk),
    .rst_n(rst_n),
    .in_event_value_xx(last_event_value_xx),
    .in_event_value_xy(last_event_value_xy),
    .in_event_value_yy(last_event_value_yy),
    .in_event_addr(last_event_addr),
    .in_event_valid(EventFIFO_write_enable),
    .out_window_addr(EventFIFO_read_window_addr),
    .read_req(EventFIFO_read_req),
    .write_done(EventFIFO_write_done),
    .out_window_value_xx(out_window_value_xx),
    .out_window_value_xy(out_window_value_xy),
    .out_window_value_yy(out_window_value_yy),
    .out_window_valid(EventFIFO_read_window_valid)
);

initial begin   // todo
    out_window_valid <= 0;
    out_window_addr <= 0;
    last_event_addr <= 0;
    min_todo_addr <= 16'hffff;
    last_available_window_addr <= 0;
    for (j=0; j<WINDOW_SIZE; j=j+1) begin
        todo_window_addr_fifo_wrpt[j] <= 0;
        todo_window_addr_fifo_rdpt[j] <= 0;
    end
    state <= 3'b000;
    EventFIFO_write_enable <= 0;
    EventFIFO_read_window_addr <= 0;
    EventFIFO_read_req <= 0;
    for (i=0; i<TODO_WINDOW_FIFO_DEPTH; i=i+1) begin
        for (j=0; j<WINDOW_SIZE; j=j+1) begin
            todo_window_addr_fifo[i][j] <= 16'hffff;
        end
    end      
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // todo
        out_window_valid <= 0;
        out_window_addr <= 0;
        last_event_addr <= 0;
        min_todo_addr <= 16'hffff;
        last_available_window_addr <= 0;
        for (j=0; j<WINDOW_SIZE; j=j+1) begin
            todo_window_addr_fifo_wrpt[j] <= 0;
            todo_window_addr_fifo_rdpt[j] <= 0;
        end
        state <= 3'b000;
        EventFIFO_write_enable <= 0;
        EventFIFO_read_window_addr <= 0;
        EventFIFO_read_req <= 0;
        for (i=0; i<TODO_WINDOW_FIFO_DEPTH; i=i+1) begin
            for (j=0; j<WINDOW_SIZE; j=j+1) begin
                todo_window_addr_fifo[i][j] <= 16'hffff;
            end
        end        
    end
    else begin
        case (state)
            3'b000: begin   // Accepting New Event(ANE)
                if (in_event_valid) begin
                    if (in_event_addr>last_event_addr) begin
                        state <= 3'b001;
                        last_event_addr <= in_event_addr;
                        last_event_value_xx <= in_event_value_xx;
                        last_event_value_xy <= in_event_value_xy;
                        last_event_value_yy <= in_event_value_yy;
                        last_available_window_addr <= in_event_addr-256*HALF_WINDOW_SIZE-HALF_WINDOW_SIZE;
                        if (event_addr_diff >= WINDOW_SIZE) begin
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+0;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]+1][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+1;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]+2][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]+3][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]+4][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[0] <= todo_window_addr_fifo_wrpt[0] + 5;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+0;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]+1][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+1;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]+2][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]+3][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]+4][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[1] <= todo_window_addr_fifo_wrpt[1] + 5;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+0;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]+1][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+1;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]+2][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]+3][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]+4][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[2] <= todo_window_addr_fifo_wrpt[2] + 5;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+0;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]+1][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+1;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]+2][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]+3][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]+4][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[3] <= todo_window_addr_fifo_wrpt[3] + 5;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+0;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]+1][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+1;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]+2][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]+3][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]+4][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[4] <= todo_window_addr_fifo_wrpt[4] + 5;
                        end
                        else if (event_addr_diff == WINDOW_SIZE-1) begin
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+1;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]+1][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]+2][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]+3][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[0] <= todo_window_addr_fifo_wrpt[0] + 4;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+1;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]+1][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]+2][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]+3][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[1] <= todo_window_addr_fifo_wrpt[1] + 4;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+1;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]+1][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]+2][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]+3][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[2] <= todo_window_addr_fifo_wrpt[2] + 4;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+1;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]+1][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]+2][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]+3][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[3] <= todo_window_addr_fifo_wrpt[3] + 4;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+1;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]+1][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]+2][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]+3][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[4] <= todo_window_addr_fifo_wrpt[4] + 4;
                        end
                        else if (event_addr_diff == WINDOW_SIZE-2) begin
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]+1][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]+2][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[0] <= todo_window_addr_fifo_wrpt[0] + 3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]+1][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]+2][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[1] <= todo_window_addr_fifo_wrpt[1] + 3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]+1][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]+2][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[2] <= todo_window_addr_fifo_wrpt[2] + 3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]+1][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]+2][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[3] <= todo_window_addr_fifo_wrpt[3] + 3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]+1][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]+2][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[4] <= todo_window_addr_fifo_wrpt[4] + 3;
                        end
                        else if (event_addr_diff == WINDOW_SIZE-3) begin
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]+1][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[0] <= todo_window_addr_fifo_wrpt[0] + 2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]+1][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[1] <= todo_window_addr_fifo_wrpt[1] + 2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]+1][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[2] <= todo_window_addr_fifo_wrpt[2] + 2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]+1][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[3] <= todo_window_addr_fifo_wrpt[3] + 2;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+3;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]+1][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[4] <= todo_window_addr_fifo_wrpt[4] + 2;
                        end
                        else if (event_addr_diff == WINDOW_SIZE-4) begin
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]][0] <= in_event_addr-256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[0] <= todo_window_addr_fifo_wrpt[0] + 1;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]][1] <= in_event_addr-256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[1] <= todo_window_addr_fifo_wrpt[1] + 1;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]][2] <= in_event_addr-256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[2] <= todo_window_addr_fifo_wrpt[2] + 1;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[3]][3] <= in_event_addr-256*(HALF_WINDOW_SIZE-3)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[3] <= todo_window_addr_fifo_wrpt[3] + 1;
                            todo_window_addr_fifo[todo_window_addr_fifo_wrpt[4]][4] <= in_event_addr-256*(HALF_WINDOW_SIZE-4)-HALF_WINDOW_SIZE+4;
                            todo_window_addr_fifo_wrpt[4] <= todo_window_addr_fifo_wrpt[4] + 1;
                        end
                    end
                    else begin
                        state <= 3'b000;
                    end
                end
                else begin
                    state <= 3'b000;
                end
            end
            3'b001: begin   // Get Window Addr(GWA)
                out_window_valid <= 0;
                if (diff10[15] == 0 && diff20[15] == 0 && diff30[15] == 0 && diff40[15] == 0 && diff0[15] == 1) begin
                    state <= 3'b010;
                    min_todo_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[0]][0];
                    EventFIFO_read_window_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[0]][0];
                    EventFIFO_read_req <= 1;
                end
                else if (diff21[15] == 0 && diff31[15] == 0 && diff41[15] == 0 && diff1[15] == 1) begin
                    state <= 3'b010;
                    min_todo_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[1]][1];
                    EventFIFO_read_window_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[1]][1];
                    EventFIFO_read_req <= 1;
                end
                else if (diff32[15] == 0 && diff42[15] == 0 && diff2[15] == 1) begin
                    state <= 3'b010;
                    min_todo_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[2]][2];
                    EventFIFO_read_window_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[2]][2];
                    EventFIFO_read_req <= 1;
                end
                else if (diff43[15] == 0 && diff3[15] == 1) begin
                    state <= 3'b010;
                    min_todo_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[3]][3];
                    EventFIFO_read_window_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[3]][3];
                    EventFIFO_read_req <= 1;
                end
                else if (diff4[15] == 1) begin
                    state <= 3'b010;
                    min_todo_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[4]][4];
                    EventFIFO_read_window_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[4]][4];
                    EventFIFO_read_req <= 1;
                end
                else begin
                    state <= 3'b011;
                    EventFIFO_read_req <= 0;
                    min_todo_addr <= 16'hffff;
                    EventFIFO_write_enable <= 1;
                    state <= 3'b100;
                end
            end
            3'b010: begin   // Output Window and Update Todo(OWUT)
                EventFIFO_read_req <= 0;
                if(window_req) begin
                    out_window_valid <= 1;
                    out_window_addr <= min_todo_addr;
                    if (sel0[15] == 1) begin
                        todo_window_addr_fifo_rdpt[0] <= todo_window_addr_fifo_rdpt[0] + 1;
                    end
                    if (sel1[15] == 1) begin
                        todo_window_addr_fifo_rdpt[1] <= todo_window_addr_fifo_rdpt[1] + 1;
                    end
                    if (sel2[15] == 1) begin
                        todo_window_addr_fifo_rdpt[2] <= todo_window_addr_fifo_rdpt[2] + 1;
                    end
                    if (sel3[15] == 1) begin
                        todo_window_addr_fifo_rdpt[3] <= todo_window_addr_fifo_rdpt[3] + 1;
                    end
                    if (sel4[15] == 1) begin
                        todo_window_addr_fifo_rdpt[4] <= todo_window_addr_fifo_rdpt[4] + 1;
                    end
                    state <= 3'b101;
                    wait_cnt <= 0;
                    // state <= 3'b001;
                end
                else begin
                    state <= 3'b010;
                end
            end
            3'b100: begin   // Waiting for Write Done(WWD)
                EventFIFO_write_enable <= 0;
                if (EventFIFO_write_done) begin
                    state <= 3'b000;
                end
                else begin
                    state <= 3'b100;
                end
            end
            3'b101: begin
                out_window_valid <= 0;
                if (wait_cnt == 2) begin
                    state <= 3'b001;
                end
                else begin
                    wait_cnt <= wait_cnt + 1;
                    state <= 3'b101;
                end
            end
            default: begin
                state <= 3'b000;
            end
        endcase
    end
end
endmodule
