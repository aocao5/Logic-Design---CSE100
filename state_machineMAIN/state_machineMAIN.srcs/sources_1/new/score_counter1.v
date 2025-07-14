`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2024 03:40:54 PM
// Design Name: 
// Module Name: score_counter1
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


module score_counter1(
    input IncSc,
    input clk,
    
    output [3:0] score
    );
    
    countUD4L score_counter_out(.clk(clk), .UD(1'b1), .CE(IncSc), .Q(score));
    
endmodule
