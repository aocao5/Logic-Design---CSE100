`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amos Cao
// 
// Create Date: 04/07/2024 05:05:14 PM
// Design Name: 
// Module Name: mux2to1
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


module mux2to1(
	input s,
	input i0,
	input i1,
    
	output y
	);
    
	assign y = ~s & i0 | s & i1;
endmodule
    
