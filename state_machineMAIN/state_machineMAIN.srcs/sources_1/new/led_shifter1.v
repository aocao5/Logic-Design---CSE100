`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amos Cao
// 
// Create Date: 04/28/2024 03:40:54 PM
// Design Name: 
// Module Name: led_shifter1
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


module led_shifter1( // led shifter sets all the leds on a quarter second apart (assuming clock period is set that way
    input clk, // should have a period = 0.25 seconds
    input R, // input for flip flops to adopt
    input Shift,
    
    output [15:0] Q_leds
    );
    
    FDRE #(.INIT(1'b0) ) led_shiftflop_0 (.C(clk), .R(R), .CE(Shift), .D(1'b1), .Q(Q_leds[0]));
    FDRE #(.INIT(1'b0) ) led_shiftflop1_15[14:0] (.C({15{clk}}), .R({15{R}}), .CE({15{Shift}}), .D(Q_leds[14:0]), .Q(Q_leds[15:1]));
    
endmodule
