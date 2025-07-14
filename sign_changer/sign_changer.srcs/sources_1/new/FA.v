`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amos Cao
// 
// Create Date: 04/07/2024 03:43:46 PM
// Design Name: 
// Module Name: FA_HA
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


module FA(
    input x,
    input y,
    input Cin,
    
    output Cout,
    output Sum
    );
    
    wire d, e, f;
    
    HA HA_1 (.a(x), .b(y), .c(d), .s(e));
    HA HA_2 (.a(e), .b(Cin), .c(f), .s(Sum));
    
    assign Cout = d | f;
    
endmodule



