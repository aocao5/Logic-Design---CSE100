`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Martine
// 
// Create Date: 04/25/2024 06:50:04 PM
// Design Name: 
// Module Name: msgchk
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

module msgchk(
    input clk, s, d,
    output e, p
    );
    
    wire [3:0] Q;
    wire [3:0] D;
        
    FDRE #(.INIT(1'b1)) Q0FF (.C(clk), .R(1'b0), .CE(1'b1), .D(D[0]), .Q(Q[0]));
    FDRE #(.INIT(1'b0)) Q123FF[3:1] (.C({3{clk}}), .R(3'b0), .CE({3{1'b1}}), .D(D[3:1]), .Q(Q[3:1]));
    
    assign D[3] = ~s&d&Q[2] | ~s&~d&Q[3];
    assign D[2] = ~s&d&Q[1] | ~s&~d&Q[2] | s&d&Q[0];
    assign D[1] = ~s&d&Q[3] | ~s&~d&Q[1] | s&~d&Q[0];
    assign D[0] = ~s&Q[0] | s&(Q[3]|Q[2]|Q[1]);
    assign e = s & (Q[3]|Q[2]|Q[1]);
    assign p = s&d&Q[2] | s&~d&Q[3];    
   
endmodule
