`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 05:16:25 PM
// Design Name: 
// Module Name: syncs
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


module syncs(
    input clk,
    input [15:0] Vsync_in,
    input [15:0] Hsync_in,
    
    output V_low,
    output H_low
    );
    
    wire v_transfer, h_transfer;
    
    assign v_transfer = (Vsync_in < 16'd489) | (Vsync_in > 16'd490);
    assign h_transfer = (Hsync_in < 16'd655) | (Hsync_in > 16'd750);
    
    FDRE #(.INIT(1'b1)) v_sync_ff (.C(clk), .R(1'b0), .CE(1'b1), .D(v_transfer), .Q(V_low));
    FDRE #(.INIT(1'b1)) h_sync_ff (.C(clk), .R(1'b0), .CE(1'b1), .D(h_transfer), .Q(H_low));
    
endmodule
