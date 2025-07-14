`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amos Cao
// 
// Create Date: 04/18/2024 02:31:04 PM
// Design Name: 
// Module Name: selector
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


module selector(
    input [15:0] N,
    input [3:0] sel,
    
    output [3:0] H
    );
    
    assign H = (N[3:0] & {4{sel[0]}}) | (N[7:4] & {4{sel[1]}}) | (N[11:8] & {4{sel[2]}}) | (N[15:12] & {4{sel[3]}});

endmodule
