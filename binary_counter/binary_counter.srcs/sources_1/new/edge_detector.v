`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2024 12:04:23 AM
// Design Name: 
// Module Name: edge_detector
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


module edge_detector(
    input clk,
    input x,
    
    output y
    );
    
    wire d1, q_out0, q_out1;
    
    assign d1 = x;
    FDRE #(.INIT(1'b0) ) ff_edge0 (.C(clk), .R(1'b0), .CE(1'b1), .D(d1), .Q(q_out0));
    
    //assign d2 = d1;
    FDRE #(.INIT(1'b0) ) ff_edge1 (.C(clk), .R(1'b0), .CE(1'b1), .D(q_out0), .Q(q_out1));
    
    assign y = ~q_out1 & q_out0;

endmodule
