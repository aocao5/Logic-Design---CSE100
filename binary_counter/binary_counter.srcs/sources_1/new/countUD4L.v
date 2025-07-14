`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2024 11:20:02 PM
// Design Name: 
// Module Name: countUD4L
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


module countUD4L(
    input clk,
    input UD,
    input CE,
    input LD,
    input [3:0] Din,
    
    output [3:0] Q,
    output UTC,
    output DTC
    );
    
    wire [3:0] inc;
    wire [3:0] inc_eq;
    wire [3:0] dec;
    wire [3:0] dec_eq;
    wire [3:0] m_out;
    wire [3:0] m_out_main;

    
    //assign UD = 1'b0; // when UD is 0, output Q will be 1 so flip flop will flip to 1, vice versa
    //assign CE = 1'b1;
    
    //assign inc = Q;
    //assign dec = Q;
    
    assign inc[0] = UD; // inc logic
    assign inc_eq[0] = inc[0] ^ Q[0];
    assign dec[0] = ~UD; //dec logic
    assign dec_eq[0] = dec[0] ^ Q[0];
    
    
    assign inc[1] = inc[0] & Q[0]; // inc logic
    assign inc_eq[1] = inc[1] ^ Q[1];
    assign dec[1] = dec[0] & ~Q[0]; // dec logic
    assign dec_eq[1] = dec[1] ^ Q[1];

    assign inc[2] = inc[1] & Q[1]; // inc logic
    assign inc_eq[2] = inc[2] ^ Q[2];
    assign dec[2] = dec[1] & ~Q[1]; //dec logic
    assign dec_eq[2] = dec[2] ^ Q[2]; 
   
    assign inc[3] = inc[2] & Q[2]; //in logic
    assign inc_eq[3] = inc[3] ^ Q[3];
    assign dec[3] = dec[2] & ~Q[2]; //dec logic
    assign dec_eq[3] = dec[3] ^ Q[3];


    mux2to1 mux3to1_UD (.s(UD), .i0(dec_eq), .i1(inc_eq), .y(m_out));
    mux2to1 mux3to1_LD (.s(LD), .i0(m_out), .i1(Din), .y(m_out_main));

    FDRE #(.INIT(1'b0) ) ff_int1 (.C(clk), .R(1'b0), .CE(CE | LD), .D(m_out_main[0]), .Q(Q[0]));
    FDRE #(.INIT(1'b0) ) ff_int2 (.C(clk), .R(1'b0), .CE(CE | LD), .D(m_out_main[1]), .Q(Q[1]));
    FDRE #(.INIT(1'b0) ) ff_int3 (.C(clk), .R(1'b0), .CE(CE | LD), .D(m_out_main[2]), .Q(Q[2]));    
    FDRE #(.INIT(1'b0) ) ff_int4 (.C(clk), .R(1'b0), .CE(CE | LD), .D(m_out_main[3]), .Q(Q[3]));

    assign UTC = &Q;
    assign DTC = ~Q[0] & ~Q[1] & ~Q[2] & ~Q[3];

endmodule
