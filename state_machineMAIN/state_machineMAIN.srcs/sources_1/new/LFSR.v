`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2024 12:05:41 AM
// Design Name: Amos Cao
// Module Name: LFSR
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


module LFSR(
    input clk,
    output [7:0] rnd
    );
    
    wire bit_in;
    wire [3:0] reg_in_bits;
    wire [7:0] copyrnd;
    
    assign reg_in_bits = {rnd[0], rnd[5], rnd[6], rnd[7]}; // these register bits represent a random seed for the LFSR to generate a value based off of

    assign bit_in = ^reg_in_bits;
    
    FDRE #(.INIT(1'b1)) rnd_numbit_init (.C(clk), .R(1'b0), .CE(1'b1), .D(bit_in), .Q(copyrnd[0]));
    FDRE #(.INIT(1'b0)) rnd_numbit[7:1] (.C({7{clk}}), .R(7'b0), .CE({7{1'b1}}), .D(copyrnd[6:0]), .Q(copyrnd[7:1]));

    assign rnd = copyrnd;
    
endmodule
