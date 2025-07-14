`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amos Cao
// 
// Create Date: 04/15/2024 11:09:08 PM
// Design Name: 
// Module Name: top_level_BC
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


module top_level_BC(
    input clkin,
    input btnR,
    input btnU,
    input btnC,
    input btnL,
    input [15:0] sw,
    
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output [15:0] led
    );
    
    wire clk, digsel, no_btnC, edge_out, or_stop_edge, or_CE;
    wire [15:0] Q_16;
    wire [3:0] ring_out;
    wire [3:0] sel_H;
    
    assign led[14:1] = btnL & sw[14:1];
    assign an = ~ring_out;
    assign dp = 1'b1;

    labCnt_clks labCnt_inst_1(.clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel));
    
    stop_counting q_check_equal(.Q_in(Q_16), .btnC(btnC), .out(or_stop_edge));
    edge_detector edge_1(.clk(clk), .x(btnU), .y(edge_out));
    assign or_CE = edge_out | or_stop_edge;// or statement with stop_counting
    // output of or statement is ce input for count16
    
    ring_counter ring_counter_top(.Advance(digsel), .clk(clk), .Q_r(ring_out));
    selector selector_top(.N(Q_16), .sel(ring_out), .H(sel_H));
    hex7seg an_display(.n(sel_H), .seg(seg));
    
    counterUD16L count16_top(.clk(clk), .UD(sw[0]), .CE(or_CE), .LD(btnL), .Din(sw[15:0]), .Q(Q_16), .UTC(led[15]), .DTC(led[0]));
    
endmodule
