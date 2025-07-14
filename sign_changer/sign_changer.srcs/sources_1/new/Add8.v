`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amos Cao
// 
// Create Date: 04/07/2024 05:06:10 PM
// Design Name: 
// Module Name: Add8
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


module Add8(
	input [7:0] A,
	input [7:0] B,
	input Cin,
    
	output [7:0] S,
	output Cout
	);
    
    wire [6:0] c;
    
    FA FA_0 (.x(A[0]), .y(B[0]), .Cin(Cin), .Cout(c[0]), .Sum(S[0]));
    FA FA_1 (.x(A[1]), .y(B[1]), .Cin(c[0]), .Cout(c[1]), .Sum(S[1]));
    FA FA_2 (.x(A[2]), .y(B[2]), .Cin(c[1]), .Cout(c[2]), .Sum(S[2]));
    FA FA_3 (.x(A[3]), .y(B[3]), .Cin(c[2]), .Cout(c[3]), .Sum(S[3]));
    FA FA_4 (.x(A[4]), .y(B[4]), .Cin(c[3]), .Cout(c[4]), .Sum(S[4]));
    FA FA_5 (.x(A[5]), .y(B[5]), .Cin(c[4]), .Cout(c[5]), .Sum(S[5]));
    FA FA_6 (.x(A[6]), .y(B[6]), .Cin(c[5]), .Cout(c[6]), .Sum(S[6]));
    FA FA_7 (.x(A[7]), .y(B[7]), .Cin(c[6]), .Cout(Cout), .Sum(S[7]));

endmodule

