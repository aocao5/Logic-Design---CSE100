`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 03:27:24 PM
// Design Name: 
// Module Name: ring_counter
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


module ring_counter(
    input Advance,
    input clk,
    output [3:0] Q_r
    );
    
    FDRE #(.INIT(1'b1)) ring_ff0 (.C(clk), .R(1'b0), .CE(Advance), .D(Q_r[3]), .Q(Q_r[0]));
    FDRE #(.INIT(1'b0)) ring_ff1 (.C(clk), .R(1'b0), .CE(Advance), .D(Q_r[0]), .Q(Q_r[1]));
    FDRE #(.INIT(1'b0)) ring_ff2 (.C(clk), .R(1'b0), .CE(Advance), .D(Q_r[1]), .Q(Q_r[2]));
    FDRE #(.INIT(1'b0)) ring_ff3 (.C(clk), .R(1'b0), .CE(Advance), .D(Q_r[2]), .Q(Q_r[3]));
    
endmodule
