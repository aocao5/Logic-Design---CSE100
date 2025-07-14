`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amos Cao
// 
// Create Date: 04/07/2024 05:06:56 PM
// Design Name: 
// Module Name: SignChanger
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


module SignChanger(
	input [7:0] a,
	input sign,
    
	output [7:0] d,
	output ovfl
	//output a_twos_comp
	);
	
	//wire val_1 = 1'b1;
	wire [7:0] a_minus;
	wire [7:0] a_twos;
	wire carry;
	
	
    //assign a_minus = ~a;
    Add8 twos_complement (.A(~a), .B(8'b1), .Cin(1'b0), .S(a_twos), .Cout(carry));
    
    //mux2to1_8out mux_bit_total (.s(sign), .i0(a), .i1(a_twos), .y(d));
    
    mux2to1 mux_bit0 (.s(sign), .i0(a[0]), .i1(a_twos[0]), .y(d[0]));
    mux2to1 mux_bit1 (.s(sign), .i0(a[1]), .i1(a_twos[1]), .y(d[1]));
    mux2to1 mux_bit2 (.s(sign), .i0(a[2]), .i1(a_twos[2]), .y(d[2]));
    mux2to1 mux_bit3 (.s(sign), .i0(a[3]), .i1(a_twos[3]), .y(d[3]));
    mux2to1 mux_bit4 (.s(sign), .i0(a[4]), .i1(a_twos[4]), .y(d[4]));
    mux2to1 mux_bit5 (.s(sign), .i0(a[5]), .i1(a_twos[5]), .y(d[5]));
    mux2to1 mux_bit6 (.s(sign), .i0(a[6]), .i1(a_twos[6]), .y(d[6]));
    mux2to1 mux_bit7 (.s(sign), .i0(a[7]), .i1(a_twos[7]), .y(d[7]));
    
    assign ovfl = a[7]&~|a[6:0]&sign;
    
endmodule
