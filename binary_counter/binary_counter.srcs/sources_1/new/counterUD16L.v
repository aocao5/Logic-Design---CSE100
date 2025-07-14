`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2024 01:56:46 AM
// Design Name: 
// Module Name: counterUD16L
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


module counterUD16L(
    input clk,
    input UD,
    input CE,
    input LD,
    input [15:0] Din,
    
    output [15:0] Q,
    output UTC,
    output DTC
    );
    
    wire [3:0] check_inc;
    wire [3:0] check_dec; // check for increment and decrement before using the next flip flop
    wire [2:0] zero_inc;
    wire [2:0] zero_dec;
    wire [2:0] zeros_eq;

    assign zero_inc[0] = CE & (UD & check_inc[0]); //inc logic
    assign zero_dec[0] = CE & (~UD & check_dec[0]); // dec logic
    assign zeros_eq[0] = zero_inc[0] | zero_dec[0];
    
    assign zero_inc[1] = CE & (UD & check_inc[0] & check_inc[1]); // inc logic
    assign zero_dec[1] = CE & (~UD & check_dec[0] & check_dec[1]); // dec logic
    assign zeros_eq[1] = zero_inc[1] | zero_dec[1];
    
    assign zero_inc[2] = CE & (UD & check_inc[0] & check_inc[1] & check_inc[2]); // inc logic
    assign zero_dec[2] = CE & (~UD & check_dec[0] & check_dec[1] & check_dec[2]); // dec logic
    assign zeros_eq[2] = zero_inc[2] | zero_dec[2];
     
    countUD4L counterUD16_1(.clk(clk), .UD(UD), .CE(CE), .LD(LD), .Din(Din[3:0]), .Q(Q[3:0]), .UTC(check_inc[0]), .DTC(check_dec[0])); 
    countUD4L counterUD16_2(.clk(clk), .UD(UD), .CE(zeros_eq[0]), .LD(LD), .Din(Din[7:4]), .Q(Q[7:4]), .UTC(check_inc[1]), .DTC(check_dec[1]));
    countUD4L counterUD16_3(.clk(clk), .UD(UD), .CE(zeros_eq[1]), .LD(LD), .Din(Din[11:8]), .Q(Q[11:8]), .UTC(check_inc[2]), .DTC(check_dec[2]));
    countUD4L counterUD16_4(.clk(clk), .UD(UD), .CE(zeros_eq[2]), .LD(LD), .Din(Din[15:12]), .Q(Q[15:12]), .UTC(check_inc[3]), .DTC(check_dec[3]));
    
    assign UTC = &check_inc;
    assign DTC = &check_dec;
    
endmodule
