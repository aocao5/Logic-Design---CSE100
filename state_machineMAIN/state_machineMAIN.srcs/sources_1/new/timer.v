`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2024 07:33:36 PM
// Design Name: 
// Module Name: timer
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


module timer(
    
    input qsec,
    input RTimer, // reset timer: resets the timer by loading 4'b0 into Q_timer
    input clk,
    // input 1 for UD (increment),
    // input [3:0] == 0000 for reset
    
    output [3:0] Q_timer
    );
    
    countUD4L timer_count4_int1(.clk(clk), .UD(1'b1), .CE(qsec), .LD(RTimer), .Din(4'b0), .Q(Q_timer));
       
endmodule
