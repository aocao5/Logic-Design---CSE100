`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 05:16:25 PM
// Design Name: 
// Module Name: pixel_address
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


module pixel_address(
    input clk,
    
    output [15:0] V,
    output [15:0] H
    );
    
    //wire [15:0] h_col;
    //wire [15:0] v_row;
    //assign H = h_col;
    //assign V = v_row;   
    
    counterUD16L col_count( .clk(clk), .UD(1'b1), .CE(1'b1), .LD(H==16'd799), .Din(16'b0), .Q(H));
    counterUD16L row_count( .clk(clk), .UD(1'b1), .CE(H==16'd799), .LD(H==16'd799 & V==16'd524), .Din(16'b0), .Q(V));
    
    
endmodule
