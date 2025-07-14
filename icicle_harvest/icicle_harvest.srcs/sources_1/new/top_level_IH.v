`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amos Cao
// 
// Create Date: 05/16/2024 05:08:09 PM
// Design Name: 
// Module Name: top_level_IH
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


module top_level_IH(
    input btnU, btnC,
    input btnL, btnR,
    input btnD,
    input clkin,
    input [15:0] sw,
    
    output [15:0] led,
    output dp,
    output Hsync,
    output Vsync,
    output [3:0] an,
    output [6:0] seg,
    output [3:0] vgaBlue, vgaRed, vgaGreen
    //output oops,
    //output rgb_oops
    
    );
    
    wire clk, digsel;
    wire [15:0] h_pix, v_pix; // inputs to vga controller
    wire [15:0] sel_N;
    wire increment, decrement, increment1, decrement1, increment2, decrement2, increment3, decrement3, increment4, decrement4, increment5, decrement5;
    wire increment6, decrement6, increment7, decrement7, increment8, decrement8, increment9, decrement9;
    //wire increment_copy, decrement_copy;
    wire [3:0] select_in;
    
    assign led[15] = sw[15];
    assign dp = 1'b1;
    //assign an[3:0] = 1'b1;
    //assign seg[6:0] = 1'b0;
    
    labVGA_clks labVGA_clks_ctrl( .clkin(clkin), .greset(btnD), .clk(clk), .digsel(digsel)); // each cycle runs for 17 ms
    
    pixel_address pix_add_top( .clk(clk), .V(v_pix), .H(h_pix));
    
    syncs syncs_top( .clk(clk), .Vsync_in(v_pix), .Hsync_in(h_pix), .V_low(Vsync), .H_low(Hsync)); // in order for v and hsync to work - oops and rgb_oops should be low and h_sync and v_sync should be high
    
    vga_controller vga_displayed( .clk(clk), .h_pix(h_pix), .v_pix(v_pix), .btnL(btnL), .btnR(btnR), .btnU(btnU), .btnD(btnD), .btnC(btnC), .sw1(sw[15]), .vgaRed(vgaRed), .vgaBlue(vgaBlue), .vgaGreen(vgaGreen), .led(led[9:0]), .increment(increment), .decrement(decrement), .increment1(increment1), .decrement1(decrement1),
                                   .increment2(increment2), .decrement2(decrement2), .increment3(increment3), .decrement3(decrement3), .increment4(increment4), .decrement4(decrement4), .increment5(increment5), .decrement5(decrement5), .increment6(increment6), .decrement6(decrement6), .increment7(increment7), .decrement7(decrement7), .increment8(increment8), .decrement8(decrement8), .increment9(increment9), .decrement9(decrement9));
    
    //wire [15:0] ice_transfer;
    wire [7:0] ice_score;
    //counterUD16L score_change( .clk(clk), .UD(increment), .CE(increment | decrement), .Din(16'd0), .Q(ice_transfer));
    //assign ice_score = ice_transfer[7:0];
    turkey_score score_change( .IncSc(increment | increment1 | increment2 | increment3 | increment4 | increment5 | increment6 | increment7 | increment8 | increment9), .DecSc(decrement | decrement1 | decrement2 | decrement3 | decrement4 | decrement5 | decrement6 | decrement7 | decrement8 | decrement9), .clk(clk), .Q_turkeys(ice_score));
    
    wire [7:0] ice_negative;
    SignChanger negative_detect( .a(ice_score), .sign(ice_score[7]), .d(ice_negative));
    
    ring_counter displays_on(.Advance(digsel), .clk(clk), .Q_r(select_in));
    
    assign sel_N = {4'b0, 4'b0, ice_negative};
    wire [3:0] hex_choose;
    selector display_val(.N(sel_N), .sel(select_in), .H(hex_choose));
    
    wire [6:0] hex_seg;
    hex7seg hex_display( .n(hex_choose), .seg(hex_seg));
    assign seg = {7{select_in[2]}} & ({7{ice_score[7]}} & 7'b0111111 | {7{~ice_score[7]}} & hex_seg) | (~{7{select_in[2]}} & hex_seg);
    
    assign an[3] = 1'b1;
    assign an[2] = ~(select_in[2] & ice_score[7]);
    assign an[1] = ~select_in[1];
    assign an[0] = ~select_in[0];
    
    
endmodule
