`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/13 21:46:20
// Design Name: 
// Module Name: EventScheduler3_end
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


module EventScheduler3_end #(
    parameter DATA_WIDTH = 4,
    parameter HALF_WINDOW_SIZE = 1,
    parameter WINDOW_SIZE = 2*HALF_WINDOW_SIZE+1,
    parameter TODO_WINDOW_FIFO_DEPTH = 64,
    parameter HASH_MEM_DEPTH = 256
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH-1:0] in_event_value,
    input wire [16-1:0] in_event_addr,
    input wire in_event_valid,
    input wire window_req,                  // the next computing block needing a new event from EventScheduler
    output wire [WINDOW_SIZE*WINDOW_SIZE*DATA_WIDTH-1:0] out_window_value,
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
reg [DATA_WIDTH-1:0] last_event_value;
reg [16-1:0] last_available_window_addr;
reg [16-1:0] todo_window_addr_fifo [0:TODO_WINDOW_FIFO_DEPTH-1][0:WINDOW_SIZE-1];
wire [15:0] diff10 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[1]][1] - todo_window_addr_fifo[todo_window_addr_fifo_rdpt[0]][0];
wire [15:0] diff21 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[2]][2] - todo_window_addr_fifo[todo_window_addr_fifo_rdpt[1]][1];
wire [15:0] diff20 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[2]][2] - todo_window_addr_fifo[todo_window_addr_fifo_rdpt[0]][0];
wire [15:0] diff0 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[0]][0] - last_available_window_addr;
wire [15:0] diff1 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[1]][1] - last_available_window_addr;
wire [15:0] diff2 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[2]][2] - last_available_window_addr;
wire [15:0] sel0 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[0]][0] - min_todo_addr - 1;
wire [15:0] sel1 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[1]][1] - min_todo_addr - 1;
wire [15:0] sel2 = todo_window_addr_fifo[todo_window_addr_fifo_rdpt[2]][2] - min_todo_addr - 1;
reg [6:0] todo_window_addr_fifo_wrpt[0:WINDOW_SIZE-1];
reg [6:0] todo_window_addr_fifo_rdpt[0:WINDOW_SIZE-1];
reg [16-1:0] min_todo_addr;

reg [2:0] state;
assign ready_for_new_event = (state == 3'b000);
integer i,j;

reg EventFIFO_write_enable;
reg [16-1:0] EventFIFO_read_window_addr;
reg EventFIFO_read_req;
wire EventFIFO_write_done;
wire EventFIFO_read_window_valid;
EventFIFO3_hash #(
    .DATA_WIDTH(DATA_WIDTH),
    .MEM_DEPTH(HASH_MEM_DEPTH),
    .HALF_WINDOW_SIZE(HALF_WINDOW_SIZE)
) EventFIFO3_hash_inst (
    .clk(clk),
    .rst_n(rst_n),
    .in_event_value(last_event_value),
    .in_event_addr(last_event_addr),
    .in_event_valid(EventFIFO_write_enable),
    .out_window_addr(EventFIFO_read_window_addr),
    .read_req(EventFIFO_read_req),
    .write_done(EventFIFO_write_done),
    .out_window_value(out_window_value),
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
                    state <= 3'b001;
                    last_event_addr <= in_event_addr;
                    last_event_value <= in_event_value;
                    last_available_window_addr <= in_event_addr-{{2'b01}, {8'b00000001}};                                   //256*HALF_WINDOW_SIZE-HALF_WINDOW_SIZE;
                    if (event_addr_diff >= 3) begin
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]][0] <= in_event_addr-{{2'b01}, {8'b00000001}};   //256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+0;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]+1][0] <= in_event_addr-{{2'b01}, {8'b00000000}}; //256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+1;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]+2][0] <= in_event_addr-{{2'b00}, {8'b11111111}}; //256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+2;
                        todo_window_addr_fifo_wrpt[0] <= todo_window_addr_fifo_wrpt[0] + 3;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]][1] <= in_event_addr-{1'b1};        //256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+0;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]+1][1] <= in_event_addr;             //256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+1;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]+2][1] <= in_event_addr+{{1'b1}};    //256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+2;
                        todo_window_addr_fifo_wrpt[1] <= todo_window_addr_fifo_wrpt[1] + 3;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]][2] <= in_event_addr+{{2'b00}, {8'b11111111}};   //256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+0;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]+1][2] <= in_event_addr+{{2'b01}, {8'b00000000}}; //256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+1;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]+2][2] <= in_event_addr+{{2'b01}, {8'b00000001}}; //256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+2;
                        todo_window_addr_fifo_wrpt[2] <= todo_window_addr_fifo_wrpt[2] + 3;
                    end
                    else if (event_addr_diff == 2) begin
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]][0] <= in_event_addr-{{2'b01}, {8'b00000000}};   //256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+1;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]+1][0] <= in_event_addr-{{2'b00}, {8'b11111111}}; //256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+2;
                        todo_window_addr_fifo_wrpt[0] <= todo_window_addr_fifo_wrpt[0] + 2;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]][1] <= in_event_addr;   //256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+1;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]+1][1] <= in_event_addr+1'b1; //256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+2;
                        todo_window_addr_fifo_wrpt[1] <= todo_window_addr_fifo_wrpt[1] + 2;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]][2] <= in_event_addr+8'b11111111;   //256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+1;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]+1][2] <= in_event_addr+{9'b100000000}; //256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+2;
                        todo_window_addr_fifo_wrpt[2] <= todo_window_addr_fifo_wrpt[2] + 2;
                    end
                    else if (event_addr_diff == 1) begin
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[0]][0] <= in_event_addr-8'b11111111;   //256*(HALF_WINDOW_SIZE-0)-HALF_WINDOW_SIZE+2;
                        todo_window_addr_fifo_wrpt[0] <= todo_window_addr_fifo_wrpt[0] + 1;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[1]][1] <= in_event_addr+1'b1;   //256*(HALF_WINDOW_SIZE-1)-HALF_WINDOW_SIZE+2;
                        todo_window_addr_fifo_wrpt[1] <= todo_window_addr_fifo_wrpt[1] + 1;
                        todo_window_addr_fifo[todo_window_addr_fifo_wrpt[2]][2] <= in_event_addr+9'b100000000;   //256*(HALF_WINDOW_SIZE-2)-HALF_WINDOW_SIZE+2;
                        todo_window_addr_fifo_wrpt[2] <= todo_window_addr_fifo_wrpt[2] + 1;
                    end
                end
                else begin
                    state <= 3'b000;
                end
            end
            3'b001: begin   // Get Window Addr(GWA)
                out_window_valid <= 0;
                if (diff10[15] == 0 && diff20[15] == 0 && diff0[15] == 1) begin
                    state <= 3'b010;
                    min_todo_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[0]][0];
                    EventFIFO_read_window_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[0]][0];
                    EventFIFO_read_req <= 1;
                end
                else if (diff21[15] == 0 && diff1[15] == 1) begin
                    state <= 3'b010;
                    min_todo_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[1]][1];
                    EventFIFO_read_window_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[1]][1];
                    EventFIFO_read_req <= 1;
                end
                else if (diff2[15] == 1) begin
                    state <= 3'b010;
                    min_todo_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[2]][2];
                    EventFIFO_read_window_addr <= todo_window_addr_fifo[todo_window_addr_fifo_rdpt[2]][2];
                    EventFIFO_read_req <= 1;
                end
                else begin
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
                    state <= 3'b001;
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
            default: begin
                state <= 3'b000;
            end
        endcase
    end
end
endmodule
