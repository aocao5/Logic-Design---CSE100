`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amos Cao
// 
// Create Date: 04/07/2024 12:08:53 AM
// Design Name: 
// Module Name: top_level1
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


module top_level(
    input [15:0] sw,
    input btnU,
    input btnR,
    input clkin,
    
    //output CA, CB, CC, CD, CE, CF, CG,
    output [6:0] seg,
    output dp, 
    output [3:0] an,
    output [15:0] led
    );
    
    wire [7:0] hex_dig;
    wire dig_sel;
    wire [6:0] seg_top;
    wire [6:0] seg_bot;
    //wire an_on;
    wire oflow_v;
    
    assign led[15:0] = sw[15:0];
    
    //assign an_on = 0;
    
    SignChanger main_output (.a(sw), .sign(btnU), .d(hex_dig), .ovfl(oflow_v));
    
    hex7seg top (.n(hex_dig[3:0]), .seg(seg_top));
    hex7seg bottom (.n(hex_dig[7:4]), .seg(seg_bot));
    //hex7seg top (.n(sw[3:0]), .seg(seg_top));
    //hex7seg bottom (.n(sw[7:4]), .seg(seg_bot));
    
    //testing displays
    //assign seg = seg_top;
    
    lab2_digsel dig_instance1 (.clkin(clkin), .greset(btnR), .digsel(dig_sel));

    mux2to1_8out mux_dig (.s(dig_sel), .i0(seg_top), .i1(seg_bot), .y(seg));

    assign an[3] = 1;
    assign an[2] = 1;
    assign an[0] = dig_sel;
    assign an[1] = ~dig_sel;
    assign dp = ~oflow_v;
    //assign an[0] = 0;
    //assign an[1] = 1;
    
    
endmodule



