`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amos Cao
// 
// Create Date: 04/10/2024 12:06:14 AM
// Design Name: 
// Module Name: mux2to1_8out
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


module mux2to1_8out(
	input s,
	input [7:0] i0, 
	input [7:0] i1,
    
	output [7:0] y
	);
    
	assign y = ~{8{s}} & i0 | {8{s}} & i1;
endmodule
