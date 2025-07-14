`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 01:46:20 PM
// Design Name: 
// Module Name: vga_controller
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


module vga_controller(
    input clk,
    input [15:0] h_pix,
    input [15:0] v_pix,
    input btnL, btnR,
    input btnU, btnD, btnC,
    input sw1,
    
    output [3:0] vgaBlue, vgaRed, vgaGreen,
    output [9:0] led,
    output increment, decrement, increment1, decrement1, increment2, decrement2, increment3, decrement3, increment4, decrement4, increment5, decrement5,
    output increment6, decrement6, increment7, decrement7, increment8, decrement8, increment9, decrement9
    );
    
    wire [3:0] blue, red, green;
    
    // active region
    wire a_region;
    assign a_region = (h_pix < 16'd640) & (v_pix < 16'd480);
    
    // the slug gets moved using a counter by changing the ud and counts to change its position by incrementing and decrementing its pixels
    // btnL constantly decrements and btnR constantly increments (updating the UD)
    
    // red border
    wire [3:0] r_border;
    assign r_border[3] = (v_pix < 16'd8); // top
    assign r_border[2] = (v_pix > 16'd472) & (v_pix < 16'd480); // bot
    assign r_border[1] = (h_pix < 16'd8); // left
    assign r_border[0] = (h_pix > 16'd632) & (h_pix < 16'd640); // right 
    
    // water
    wire b_water;
    assign b_water = (v_pix >= 16'd360) & (v_pix <= 16'd472) & (h_pix >= 16'd8) & (h_pix <= 16'd632); // vert down | left right
    
    // podium
    wire gb_podium;
    wire gb_podium_under;
    assign gb_podium =  (h_pix < 16'd352) & (h_pix > 16'd288) & (v_pix > 16'd288) & (v_pix <= 16'd472); // green blue horizontal and vertical
    
    // slug 
    wire ice_flash, ice_flash1, ice_flash2, ice_flash3, ice_flash4, ice_flash5, ice_flash6, ice_flash7, ice_flash8, ice_flash9;
    
    wire slug_rg; // red and greens combined
    wire [15:0] slug_pixX_L, slug_pixX_R, slug_pixY_T, slug_pixY_B;
    wire slug_flash;
    slug_xy vga_slug( .clk(clk), .reset(btnD), .s_left(btnL), .s_right(btnR), .s_up(btnU), .speed_sw(sw1), .ice_flash(ice_flash | ice_flash1 | ice_flash2 | ice_flash3 | ice_flash4 | ice_flash5 | ice_flash6 | ice_flash7 | ice_flash8 | ice_flash9), .slug_pixX_L(slug_pixX_L), .slug_pixX_R(slug_pixX_R), .slug_pixY_T(slug_pixY_T), .slug_pixY_B(slug_pixY_B), .slug_flash(slug_flash));
    assign slug_rg = (h_pix < slug_pixX_R) & (h_pix > slug_pixX_L) & (v_pix >= slug_pixY_T) & (v_pix <= slug_pixY_B) & ((slug_pixY_B < 16'd472) | slug_flash); // h1 = 331 h2 = 311 v1 = 272 v2 = 288
    
    //assign led[1] = slug_flash;
    
    //------------------------------------------------------------------------------------------------------------
    // icicles + iterations
    wire ice_melt;
    wire [7:0] rnd_ice;
    wire [3:0] main_fade_bits;
    wire icicle;
    wire [15:0] ice_borderT, ice_borderB;
    assign icicle = ((h_pix > 16'd30) & (h_pix < 16'd36) & (v_pix >= ice_borderT) & (v_pix < ice_borderB)) & (~ice_flash | slug_flash); //ice_melt & 
    icicle_manipulate ice_main_iteration0( .clk(clk), .btnC(btnC), .reset(btnD), .slug_pixY_B(slug_pixY_B), .slug_pixY_T(slug_pixY_T), .slug_pixX_L(slug_pixX_L), .slug_pixX_R(slug_pixX_R), .slug_flash(slug_flash), .in_rnd({rnd_ice[0], rnd_ice[5], rnd_ice[4]}), .fade_bits(main_fade_bits), .ice_sidesL(16'd30), .ice_sidesR(16'd36), .ice_T(ice_borderT), .ice_B(ice_borderB), .ice_flash(ice_flash), .ice_melt(ice_melt), .rnd_ice(rnd_ice), .increment(increment), .decrement(decrement));
    
    wire ice_melt1;
    wire [7:0] rnd_ice1;
    wire [3:0] main_fade_bits1;
    wire icicle1; 
    wire [15:0] ice_borderT1, ice_borderB1;
    assign icicle1 = ((h_pix > 16'd94) & (h_pix < 16'd100) & (v_pix >= ice_borderT1) & (v_pix < ice_borderB1)) & (~ice_flash1 | slug_flash); //ice_melt & 
    icicle_manipulate ice_main_iteration1( .clk(clk), .btnC(btnC), .reset(btnD), .slug_pixY_B(slug_pixY_B), .slug_pixY_T(slug_pixY_T), .slug_pixX_L(slug_pixX_L), .slug_pixX_R(slug_pixX_R), .slug_flash(slug_flash), .in_rnd({rnd_ice1[2], rnd_ice1[5], rnd_ice1[7]}), .fade_bits(main_fade_bits1), .ice_sidesL(16'd94), .ice_sidesR(16'd100), .ice_T(ice_borderT1), .ice_B(ice_borderB1), .ice_flash(ice_flash1), .ice_melt(ice_melt1), .rnd_ice(rnd_ice1), .increment(increment1), .decrement(decrement1));
    
    wire ice_melt2;
    wire [7:0] rnd_ice2;
    wire [3:0] main_fade_bits2;
    wire icicle2; 
    wire [15:0] ice_borderT2, ice_borderB2;
    assign icicle2 = ((h_pix > 16'd158) & (h_pix < 16'd164) & (v_pix >= ice_borderT2) & (v_pix < ice_borderB2)) & (~ice_flash2 | slug_flash); //ice_melt & 
    icicle_manipulate ice_main_iteration2( .clk(clk), .btnC(btnC), .reset(btnD), .slug_pixY_B(slug_pixY_B), .slug_pixY_T(slug_pixY_T), .slug_pixX_L(slug_pixX_L), .slug_pixX_R(slug_pixX_R), .slug_flash(slug_flash), .in_rnd({rnd_ice2[3], rnd_ice2[4], rnd_ice2[1]}), .fade_bits(main_fade_bits2), .ice_sidesL(16'd158), .ice_sidesR(16'd164), .ice_T(ice_borderT2), .ice_B(ice_borderB2), .ice_flash(ice_flash2), .ice_melt(ice_melt2), .rnd_ice(rnd_ice2), .increment(increment2), .decrement(decrement2));
    
    wire ice_melt3;
    wire [7:0] rnd_ice3;
    wire [3:0] main_fade_bits3;
    wire icicle3; 
    wire [15:0] ice_borderT3, ice_borderB3;
    assign icicle3 = ((h_pix > 16'd222) & (h_pix < 16'd228) & (v_pix >= ice_borderT3) & (v_pix < ice_borderB3)) & (~ice_flash3 | slug_flash); //ice_melt & 
    icicle_manipulate ice_main_iteration3( .clk(clk), .btnC(btnC), .reset(btnD), .slug_pixY_B(slug_pixY_B), .slug_pixY_T(slug_pixY_T), .slug_pixX_L(slug_pixX_L), .slug_pixX_R(slug_pixX_R), .slug_flash(slug_flash), .in_rnd({rnd_ice3[5], rnd_ice3[0], rnd_ice3[6]}), .fade_bits(main_fade_bits3), .ice_sidesL(16'd222), .ice_sidesR(16'd228), .ice_T(ice_borderT3), .ice_B(ice_borderB3), .ice_flash(ice_flash3), .ice_melt(ice_melt3), .rnd_ice(rnd_ice3), .increment(increment3), .decrement(decrement3));
    
    wire ice_melt4;
    wire [7:0] rnd_ice4;
    wire [3:0] main_fade_bits4;
    wire icicle4; 
    wire [15:0] ice_borderT4, ice_borderB4;
    assign icicle4 = ((h_pix > 16'd286) & (h_pix < 16'd292) & (v_pix >= ice_borderT4) & (v_pix < ice_borderB4)) & (~ice_flash4 | slug_flash); //ice_melt & 
    icicle_manipulate ice_main_iteration4( .clk(clk), .btnC(btnC), .reset(btnD), .slug_pixY_B(slug_pixY_B), .slug_pixY_T(slug_pixY_T), .slug_pixX_L(slug_pixX_L), .slug_pixX_R(slug_pixX_R), .slug_flash(slug_flash), .in_rnd({rnd_ice4[0], rnd_ice4[1], rnd_ice4[2]}), .fade_bits(main_fade_bits4), .ice_sidesL(16'd286), .ice_sidesR(16'd292), .ice_T(ice_borderT4), .ice_B(ice_borderB4), .ice_flash(ice_flash4), .ice_melt(ice_melt4), .rnd_ice(rnd_ice4), .increment(increment4), .decrement(decrement4));
    
    wire ice_melt5;
    wire [7:0] rnd_ice5;
    wire [3:0] main_fade_bits5;
    wire icicle5; 
    wire [15:0] ice_borderT5, ice_borderB5;
    assign icicle5 = ((h_pix > 16'd350) & (h_pix < 16'd356) & (v_pix >= ice_borderT5) & (v_pix < ice_borderB5)) & (~ice_flash5 | slug_flash); //ice_melt & 
    icicle_manipulate ice_main_iteration5( .clk(clk), .btnC(btnC), .reset(btnD), .slug_pixY_B(slug_pixY_B), .slug_pixY_T(slug_pixY_T), .slug_pixX_L(slug_pixX_L), .slug_pixX_R(slug_pixX_R), .slug_flash(slug_flash), .in_rnd({rnd_ice5[1], rnd_ice5[6], rnd_ice5[7]}), .fade_bits(main_fade_bits5), .ice_sidesL(16'd350), .ice_sidesR(16'd356), .ice_T(ice_borderT5), .ice_B(ice_borderB5), .ice_flash(ice_flash5), .ice_melt(ice_melt5), .rnd_ice(rnd_ice5), .increment(increment5), .decrement(decrement5));
    
    wire ice_melt6;
    wire [7:0] rnd_ice6;
    wire [3:0] main_fade_bits6;
    wire icicle6;
    wire [15:0] ice_borderT6, ice_borderB6;
    assign icicle6 = ((h_pix > 16'd414) & (h_pix < 16'd420) & (v_pix >= ice_borderT6) & (v_pix < ice_borderB6)) & (~ice_flash6 | slug_flash); //ice_melt & 
    icicle_manipulate ice_main_iteration6( .clk(clk), .btnC(btnC), .reset(btnD), .slug_pixY_B(slug_pixY_B), .slug_pixY_T(slug_pixY_T), .slug_pixX_L(slug_pixX_L), .slug_pixX_R(slug_pixX_R), .slug_flash(slug_flash), .in_rnd({rnd_ice6[7], rnd_ice6[3], rnd_ice6[4]}), .fade_bits(main_fade_bits6), .ice_sidesL(16'd414), .ice_sidesR(16'd420), .ice_T(ice_borderT6), .ice_B(ice_borderB6), .ice_flash(ice_flash6), .ice_melt(ice_melt6), .rnd_ice(rnd_ice6), .increment(increment6), .decrement(decrement6));
    
    wire ice_melt7;
    wire [7:0] rnd_ice7;
    wire [3:0] main_fade_bits7;
    wire icicle7;
    wire [15:0] ice_borderT7, ice_borderB7;
    assign icicle7 = ((h_pix > 16'd478) & (h_pix < 16'd484) & (v_pix >= ice_borderT7) & (v_pix < ice_borderB7)) & (~ice_flash7 | slug_flash); //ice_melt & 
    icicle_manipulate ice_main_iteration7( .clk(clk), .btnC(btnC), .reset(btnD), .slug_pixY_B(slug_pixY_B), .slug_pixY_T(slug_pixY_T), .slug_pixX_L(slug_pixX_L), .slug_pixX_R(slug_pixX_R), .slug_flash(slug_flash), .in_rnd({rnd_ice7[3], rnd_ice7[1], rnd_ice7[2]}), .fade_bits(main_fade_bits7), .ice_sidesL(16'd478), .ice_sidesR(16'd484), .ice_T(ice_borderT7), .ice_B(ice_borderB7), .ice_flash(ice_flash7), .ice_melt(ice_melt7), .rnd_ice(rnd_ice7), .increment(increment7), .decrement(decrement7));
    
    wire ice_melt8;
    wire [7:0] rnd_ice8;
    wire [3:0] main_fade_bits8;
    wire icicle8;
    wire [15:0] ice_borderT8, ice_borderB8;
    assign icicle8 = ((h_pix > 16'd542) & (h_pix < 16'd548) & (v_pix >= ice_borderT8) & (v_pix < ice_borderB8)) & (~ice_flash8 | slug_flash); //ice_melt & 
    icicle_manipulate ice_main_iteration8( .clk(clk), .btnC(btnC), .reset(btnD), .slug_pixY_B(slug_pixY_B), .slug_pixY_T(slug_pixY_T), .slug_pixX_L(slug_pixX_L), .slug_pixX_R(slug_pixX_R), .slug_flash(slug_flash), .in_rnd({rnd_ice8[4], rnd_ice8[3], rnd_ice8[1]}), .fade_bits(main_fade_bits8), .ice_sidesL(16'd542), .ice_sidesR(16'd548), .ice_T(ice_borderT8), .ice_B(ice_borderB8), .ice_flash(ice_flash8), .ice_melt(ice_melt8), .rnd_ice(rnd_ice8), .increment(increment8), .decrement(decrement8));
    
    wire ice_melt9;
    wire [7:0] rnd_ice9;
    wire [3:0] main_fade_bits9;
    wire icicle9;
    wire [15:0] ice_borderT9, ice_borderB9;
    assign icicle9 = ((h_pix > 16'd606) & (h_pix < 16'd612) & (v_pix >= ice_borderT9) & (v_pix < ice_borderB9)) & (~ice_flash9 | slug_flash); //ice_melt & 
    icicle_manipulate ice_main_iteration9( .clk(clk), .btnC(btnC), .reset(btnD), .slug_pixY_B(slug_pixY_B), .slug_pixY_T(slug_pixY_T), .slug_pixX_L(slug_pixX_L), .slug_pixX_R(slug_pixX_R), .slug_flash(slug_flash), .in_rnd({rnd_ice9[5], rnd_ice9[6], rnd_ice9[7]}), .fade_bits(main_fade_bits9), .ice_sidesL(16'd606), .ice_sidesR(16'd612), .ice_T(ice_borderT9), .ice_B(ice_borderB9), .ice_flash(ice_flash9), .ice_melt(ice_melt9), .rnd_ice(rnd_ice9), .increment(increment9), .decrement(decrement9));
    //------------------------------------------------------------------------------------------------------------
    
    assign led = {ice_flash, ice_flash1, ice_flash2, ice_flash3, ice_flash4, ice_flash5, ice_flash6, ice_flash7, ice_flash8, ice_flash9};
    
    //------------------------------------------------------------------------------------------------------------
    // vga assignments
    assign red[0] = {4{a_region}} & ({4{r_border[3]}} | {4{r_border[2]}} | {4{r_border[1]}} | {4{r_border[0]}}) | {4{slug_rg}} | ((({4{icicle}} & main_fade_bits[0] & rnd_ice[0]) | ({4{icicle1}} & main_fade_bits1[0] & rnd_ice1[0]) | ({4{icicle2}} & main_fade_bits2[0] & rnd_ice2[0]) | ({4{icicle3}} & main_fade_bits3[0] & rnd_ice3[0]) | ({4{icicle4}} & main_fade_bits4[0] & rnd_ice4[0]) | ({4{icicle5}} & main_fade_bits5[0] & rnd_ice5[0]) | ({4{icicle6}} & main_fade_bits6[0] & rnd_ice6[0]) | ({4{icicle7}} & main_fade_bits7[0] & rnd_ice7[0]) | ({4{icicle8}} & main_fade_bits8[0] & rnd_ice8[0]) | ({4{icicle9}} & main_fade_bits9[0] & rnd_ice9[0])) & ~b_water);
    assign red[1] = {4{a_region}} & ({4{r_border[3]}} | {4{r_border[2]}} | {4{r_border[1]}} | {4{r_border[0]}}) | {4{slug_rg}} | ((({4{icicle}} & main_fade_bits[1] & rnd_ice[0]) | ({4{icicle1}} & main_fade_bits1[1] & rnd_ice1[0]) | ({4{icicle2}} & main_fade_bits2[1] & rnd_ice2[0]) | ({4{icicle3}} & main_fade_bits3[1] & rnd_ice3[0]) | ({4{icicle4}} & main_fade_bits4[1] & rnd_ice4[0]) | ({4{icicle5}} & main_fade_bits5[1] & rnd_ice5[0]) | ({4{icicle6}} & main_fade_bits6[1] & rnd_ice6[0]) | ({4{icicle7}} & main_fade_bits7[1] & rnd_ice7[0]) | ({4{icicle8}} & main_fade_bits8[1] & rnd_ice8[0]) | ({4{icicle9}} & main_fade_bits9[1] & rnd_ice9[0])) & ~b_water);
    assign red[2] = {4{a_region}} & ({4{r_border[3]}} | {4{r_border[2]}} | {4{r_border[1]}} | {4{r_border[0]}}) | {4{slug_rg}} | ((({4{icicle}} & main_fade_bits[2] & rnd_ice[0]) | ({4{icicle1}} & main_fade_bits1[2] & rnd_ice1[0]) | ({4{icicle2}} & main_fade_bits2[2] & rnd_ice2[0]) | ({4{icicle3}} & main_fade_bits3[2] & rnd_ice3[0]) | ({4{icicle4}} & main_fade_bits4[2] & rnd_ice4[0]) | ({4{icicle5}} & main_fade_bits5[2] & rnd_ice5[0]) | ({4{icicle6}} & main_fade_bits6[2] & rnd_ice6[0]) | ({4{icicle7}} & main_fade_bits7[2] & rnd_ice7[0]) | ({4{icicle8}} & main_fade_bits8[2] & rnd_ice8[0]) | ({4{icicle9}} & main_fade_bits9[2] & rnd_ice9[0])) & ~b_water);
    assign red[3] = {4{a_region}} & ({4{r_border[3]}} | {4{r_border[2]}} | {4{r_border[1]}} | {4{r_border[0]}}) | {4{slug_rg}} | ((({4{icicle}} & main_fade_bits[3] & rnd_ice[0]) | ({4{icicle1}} & main_fade_bits1[3] & rnd_ice1[0]) | ({4{icicle2}} & main_fade_bits2[3] & rnd_ice2[0]) | ({4{icicle3}} & main_fade_bits3[3] & rnd_ice3[0]) | ({4{icicle4}} & main_fade_bits4[3] & rnd_ice4[0]) | ({4{icicle5}} & main_fade_bits5[3] & rnd_ice5[0]) | ({4{icicle6}} & main_fade_bits6[3] & rnd_ice6[0]) | ({4{icicle7}} & main_fade_bits7[3] & rnd_ice7[0]) | ({4{icicle8}} & main_fade_bits8[3] & rnd_ice8[0]) | ({4{icicle9}} & main_fade_bits9[3] & rnd_ice9[0])) & ~b_water);

    assign green[0] = {4{a_region}} & {4{gb_podium}} | {4{slug_rg}} | ((({4{icicle}} & main_fade_bits[0] & ~rnd_ice[0]) | ({4{icicle1}} & main_fade_bits1[0] & ~rnd_ice1[0]) | ({4{icicle2}} & main_fade_bits2[0] & ~rnd_ice2[0]) | ({4{icicle3}} & main_fade_bits3[0] & ~rnd_ice3[0]) | ({4{icicle4}} & main_fade_bits4[0] & ~rnd_ice4[0]) | ({4{icicle5}} & main_fade_bits5[0] & ~rnd_ice5[0]) | ({4{icicle6}} & main_fade_bits6[0] & ~rnd_ice6[0]) | ({4{icicle7}} & main_fade_bits7[0] & ~rnd_ice7[0]) | ({4{icicle8}} & main_fade_bits8[0] & ~rnd_ice8[0]) | ({4{icicle9}} & main_fade_bits9[0] & ~rnd_ice9[0])) & ~b_water); // {4{icicle[0]}}
    assign green[1] = {4{a_region}} & {4{gb_podium}} | {4{slug_rg}} | ((({4{icicle}} & main_fade_bits[1] & ~rnd_ice[0]) | ({4{icicle1}} & main_fade_bits1[1] & ~rnd_ice1[0]) | ({4{icicle2}} & main_fade_bits2[1] & ~rnd_ice2[0]) | ({4{icicle3}} & main_fade_bits3[1] & ~rnd_ice3[0]) | ({4{icicle4}} & main_fade_bits4[1] & ~rnd_ice4[0]) | ({4{icicle5}} & main_fade_bits5[1] & ~rnd_ice5[0]) | ({4{icicle6}} & main_fade_bits6[1] & ~rnd_ice6[0]) | ({4{icicle7}} & main_fade_bits7[1] & ~rnd_ice7[0]) | ({4{icicle8}} & main_fade_bits8[1] & ~rnd_ice8[0]) | ({4{icicle9}} & main_fade_bits9[1] & ~rnd_ice9[0])) & ~b_water);
    assign green[2] = {4{a_region}} & {4{gb_podium}} | {4{slug_rg}} | ((({4{icicle}} & main_fade_bits[2] & ~rnd_ice[0]) | ({4{icicle1}} & main_fade_bits1[2] & ~rnd_ice1[0]) | ({4{icicle2}} & main_fade_bits2[2] & ~rnd_ice2[0]) | ({4{icicle3}} & main_fade_bits3[2] & ~rnd_ice3[0]) | ({4{icicle4}} & main_fade_bits4[2] & ~rnd_ice4[0]) | ({4{icicle5}} & main_fade_bits5[2] & ~rnd_ice5[0]) | ({4{icicle6}} & main_fade_bits6[2] & ~rnd_ice6[0]) | ({4{icicle7}} & main_fade_bits7[2] & ~rnd_ice7[0]) | ({4{icicle8}} & main_fade_bits8[2] & ~rnd_ice8[0]) | ({4{icicle9}} & main_fade_bits9[2] & ~rnd_ice9[0])) & ~b_water); 
    assign green[3] = {4{a_region}} & {4{slug_rg}} | ((({4{icicle}} & main_fade_bits[3] & ~rnd_ice[0]) | ({4{icicle1}} & main_fade_bits1[3] & ~rnd_ice1[0]) | ({4{icicle2}} & main_fade_bits2[3] & ~rnd_ice2[0]) | ({4{icicle3}} & main_fade_bits3[3] & ~rnd_ice3[0]) | ({4{icicle4}} & main_fade_bits4[3] & ~rnd_ice4[0]) | ({4{icicle5}} & main_fade_bits5[3] & ~rnd_ice5[0]) | ({4{icicle6}} & main_fade_bits6[3] & ~rnd_ice6[0]) | ({4{icicle7}} & main_fade_bits7[3] & ~rnd_ice7[0]) | ({4{icicle8}} & main_fade_bits8[3] & ~rnd_ice8[0]) | ({4{icicle9}} & main_fade_bits9[3] & ~rnd_ice9[0])) & ~b_water); 
    
    assign blue[0] = {4{a_region}} & {4{gb_podium}} | ((({4{icicle}} & main_fade_bits[0]) | ({4{icicle1}} & main_fade_bits1[0]) | ({4{icicle2}} & main_fade_bits2[0]) | ({4{icicle3}} & main_fade_bits3[0]) | ({4{icicle4}} & main_fade_bits4[0]) | ({4{icicle5}} & main_fade_bits5[0]) | ({4{icicle6}} & main_fade_bits6[0]) | ({4{icicle7}} & main_fade_bits7[0]) | ({4{icicle8}} & main_fade_bits8[0]) | ({4{icicle9}} & main_fade_bits9[0])) & ~b_water);
    assign blue[1] = {4{a_region}} & {4{b_water}} | {4{gb_podium}} | ((({4{icicle}} & main_fade_bits[1]) | ({4{icicle1}} & main_fade_bits1[1]) | ({4{icicle2}} & main_fade_bits2[1]) | ({4{icicle3}} & main_fade_bits3[1]) | ({4{icicle4}} & main_fade_bits4[1]) | ({4{icicle5}} & main_fade_bits5[1]) | ({4{icicle6}} & main_fade_bits6[1]) | ({4{icicle7}} & main_fade_bits7[1]) | ({4{icicle8}} & main_fade_bits8[1]) | ({4{icicle9}} & main_fade_bits9[1])) & ~b_water);
    assign blue[2] = {4{a_region}} & {4{b_water}} | ((({4{icicle}} & main_fade_bits[2]) | ({4{icicle1}} & main_fade_bits1[2]) | ({4{icicle2}} & main_fade_bits2[2]) | ({4{icicle3}} & main_fade_bits3[2]) | ({4{icicle4}} & main_fade_bits4[2]) | ({4{icicle5}} & main_fade_bits5[2]) | ({4{icicle6}} & main_fade_bits6[2]) | ({4{icicle7}} & main_fade_bits7[2]) | ({4{icicle8}} & main_fade_bits8[2]) | ({4{icicle9}} & main_fade_bits9[2])) & ~b_water);
    assign blue[3] = {4{a_region}} & {4{b_water}} | ((({4{icicle}} & main_fade_bits[3]) | ({4{icicle1}} & main_fade_bits1[3]) | ({4{icicle2}} & main_fade_bits2[3]) | ({4{icicle3}} & main_fade_bits3[3]) | ({4{icicle4}} & main_fade_bits4[3]) | ({4{icicle5}} & main_fade_bits5[3]) | ({4{icicle6}} & main_fade_bits6[3]) | ({4{icicle7}} & main_fade_bits7[3]) | ({4{icicle8}} & main_fade_bits8[3]) | ({4{icicle9}} & main_fade_bits9[3])) & ~b_water);
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
    // red
    FDRE #(.INIT(1'b0) ) vgaRed_ff0 (.C(clk), .R(1'b0), .CE(1'b1), .D(red[0]), .Q(vgaRed[0]));
    FDRE #(.INIT(1'b0) ) vgaRed_ff1 (.C(clk), .R(1'b0), .CE(1'b1), .D(red[1]), .Q(vgaRed[1]));
    FDRE #(.INIT(1'b0) ) vgaRed_ff2 (.C(clk), .R(1'b0), .CE(1'b1), .D(red[2]), .Q(vgaRed[2]));
    FDRE #(.INIT(1'b0) ) vgaRed_ff3 (.C(clk), .R(1'b0), .CE(1'b1), .D(red[3]), .Q(vgaRed[3]));
    
    // green
    FDRE #(.INIT(1'b0) ) vgaGreen_ff0 (.C(clk), .R(1'b0), .CE(1'b1), .D(green[0]), .Q(vgaGreen[0]));
    FDRE #(.INIT(1'b0) ) vgaGreen_ff1 (.C(clk), .R(1'b0), .CE(1'b1), .D(green[1]), .Q(vgaGreen[1]));
    FDRE #(.INIT(1'b0) ) vgaGreen_ff2 (.C(clk), .R(1'b0), .CE(1'b1), .D(green[2]), .Q(vgaGreen[2]));
    FDRE #(.INIT(1'b0) ) vgaGreen_ff3 (.C(clk), .R(1'b0), .CE(1'b1), .D(green[3]), .Q(vgaGreen[3]));
    
    // blue
    FDRE #(.INIT(1'b0) ) vgaBlue_ff0 (.C(clk), .R(1'b0), .CE(1'b1), .D(blue[0]), .Q(vgaBlue[0]));
    FDRE #(.INIT(1'b0) ) vgaBlue_ff1 (.C(clk), .R(1'b0), .CE(1'b1), .D(blue[1]), .Q(vgaBlue[1]));
    FDRE #(.INIT(1'b0) ) vgaBlue_ff2 (.C(clk), .R(1'b0), .CE(1'b1), .D(blue[2]), .Q(vgaBlue[2]));
    FDRE #(.INIT(1'b0) ) vgaBlue_ff3 (.C(clk), .R(1'b0), .CE(1'b1), .D(blue[3]), .Q(vgaBlue[3]));
    
endmodule
