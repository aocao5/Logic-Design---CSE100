`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2024 02:24:55 AM
// Design Name: 
// Module Name: stop_counting
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


module stop_counting(
    input [15:0] Q_in,
    input btnC,
    
    output out
    );
    
    wire q_equals;
    
    /*wire [15:0] FFF_C, FFF_D, FFF_E, FFF_F;
    wire q_equals;
    
    assign FFF_C = 16'b1111111111111100;
    assign FFF_D = 16'b1111111111111101;
    assign FFF_E = 16'b1111111111111110;
    assign FFF_F = 16'b1111111111111111;
    
    assign q_equals = Q_in & FFF_C | Q_in & FFF_D | Q_in & FFF_E | Q_in & FFF_F;
    */
    
    assign q_equals = ~(&Q_in[15:2]);
    assign out = q_equals & btnC;
    
    
    
endmodule
