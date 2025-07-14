`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2024 01:19:43 AM
// Design Name: 
// Module Name: game_time
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


module game_time(
    input CntDwn,
    input qsec,
    input LDTgt,
    input [7:0] TimeTgt,
    input clk,
    // input 0 == UD (decrementing naturally)
    
    output [7:0] Q_gt,
    output TZ
    );
    
    wire [15:0] Q_16gt;
    wire [15:0] extend_ttgt;
    wire adjust_clk;
    
    
    assign adjust_clk = CntDwn & qsec;
    //assign extend_ttgt = {8'b0, TimeTgt[7:4], 4'b0};
    
    assign Q_gt = Q_16gt[7:0];
    
    counterUD16L game_time_8bit( .clk(clk), .UD(1'b0), .CE(adjust_clk), .LD(LDTgt), .Din(TimeTgt), .Q(Q_16gt), .DTC(TZ));
     
endmodule
