`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amos Cao
// 
// Create Date: 05/19/2024 10:26:09 PM
// Design Name: 
// Module Name: slug_xy
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


module slug_xy(
    input clk,
    input reset, // btnD
    input s_left, s_right,
    input s_up,
    input speed_sw,
    input ice_flash,

    output [15:0] slug_pixX_L, slug_pixX_R , slug_pixY_T, slug_pixY_B,
    output slug_flash
    );
    
    // collision detection
    
    // red border
    wire [3:0] r_border;
    assign r_border[3] = ~(slug_pixY_T < 16'd9); // top
    assign r_border[2] = ~(slug_pixY_B > 16'd471); // bot
    assign r_border[1] = ~(slug_pixX_L <= 16'd7); // left
    assign r_border[0] = ~(slug_pixX_R >= 16'd633); // right 
    
    // podium
    wire [2:0] gb_podium;
    assign gb_podium[2] = ~(slug_pixX_L <= 16'd351 & slug_pixX_R >= 16'd289 & slug_pixY_B == 16'd288); // top
    assign gb_podium[1] = ~(slug_pixX_R == 16'd289 & slug_pixY_B >= 16'd289); // left
    assign gb_podium[0] = ~(slug_pixX_L == 16'd351 & slug_pixY_B >= 16'd289); // right

    // water
    wire b_water;
    assign b_water = ~(slug_pixY_B >= 16'd360);
    
    // intial still
    wire still;
    wire [3:0] still_adj;
    assign still = ~(still_adj == 4'd1); // have a counter that when the very first value is equal to 1 stop, and AND it with an impossible case
    countUD4L intial_still( .clk(clk), .UD(1'b1), .CE(still), .LD(1'b0), .Din(4'd0), .Q(still_adj));
    
    // left and right cases
    wire L_choose, R_choose;
    assign L_choose = s_left & ~s_right;
    assign R_choose = ~s_left & s_right;
    
    // left and right ce's
    wire slow_countL, slow_countR, slow_rdb, slow_ldb;
    wire [15:0] slow_adjL, slow_adjR, slow_adj_rdb, slow_adj_ldb;
    wire [15:0] speedy, speed_up;
    
    // SPEED SWITCH RAAAAAAAAH
    mux2to1_16out speedchoose_1(.s(speed_sw), .i0(16'd5000), .i1(16'd900), .y(speedy));
    mux2to1_16out speedchoose_2(.s(speed_sw), .i0(16'd2500), .i1(16'd900), .y(speed_up));
    
    assign slow_countL = (slow_adjL == speedy); // og 5000
    assign slow_ldb = (slow_adj_ldb == 16'd70);
    counterUD16L slowed_downL( .clk(clk), .UD(1'b1), .CE((1'b1)), .LD(slow_countL), .Din(16'd0), .Q(slow_adjL)); // og l_choose ^ r_choose
    counterUD16L slowed_downLdouble( .clk(clk), .UD(1'b1), .CE(slow_countL), .LD(slow_ldb), .Din(16'd0), .Q(slow_adj_ldb));
    
    assign slow_countR = (slow_adjR == speedy); // og 5000
    assign slow_rdb = (slow_adj_rdb == 16'd70); // og 50
    counterUD16L slowed_downR( .clk(clk), .UD(1'b1), .CE((1'b1)), .LD(slow_countR), .Din(16'd0), .Q(slow_adjR));
    counterUD16L slowed_downRdouble( .clk(clk), .UD(1'b1), .CE(slow_countR), .LD(slow_rdb), .Din(16'd0), .Q(slow_adj_rdb));
    //-----------------------------
    counterUD16L slug_x_coords_L( .clk(clk), .UD(R_choose), .CE(((slow_ldb & L_choose & r_border[1] & gb_podium[0]) | (slow_rdb & R_choose & r_border[0] & gb_podium[1])) & b_water & ~ice_flash), .LD(still | reset), .Din(16'd311), .Q(slug_pixX_L));
    assign slug_pixX_R = slug_pixX_L + 16'd18;
    //-----------------------------
    
    // top and bottom cases
    wire T_choose;
    assign T_choose = s_up;
    
    // top  and bottom ce's
    wire slow_countU, slow_udb, slow_countD, slow_ddb;
    wire [15:0] slow_adjU, slow_adj_udb, slow_adjD, slow_adj_ddb;
    
    // up
    assign slow_countU = (slow_adjU == speed_up); // og 3500
    assign slow_udb = (slow_adj_udb == 16'd70);
    counterUD16L slowed_downU( .clk(clk), .UD(1'b1), .CE(1'b1), .LD(slow_countU), .Din(16'd0), .Q(slow_adjU));
    counterUD16L slowed_downUdouble( .clk(clk), .UD(1'b1), .CE(slow_countU), .LD(slow_udb), .Din(16'd0), .Q(slow_adj_udb));
    
    // fall
    assign slow_countD = (slow_adjD == 16'd7000); // og 5000
    assign slow_ddb = (slow_adj_ddb == 16'd70);
    counterUD16L slowed_downD( .clk(clk), .UD(1'b1), .CE(1'b1), .LD(slow_countD), .Din(16'd0), .Q(slow_adjD)); // changed ce to 1'b1 from ~T_choose
    counterUD16L slowed_downDdouble( .clk(clk), .UD(1'b1), .CE(slow_countD), .LD(slow_ddb), .Din(16'd0), .Q(slow_adj_ddb));
    
    //-----------------------------
    counterUD16L slug_y_coords_B( .clk(clk), .UD(~T_choose | ~b_water), .CE(((slow_udb & T_choose & r_border[3] & b_water) | (slow_ddb & ~T_choose & r_border[2] & gb_podium[2]) | (slow_ddb & r_border[2] & gb_podium[2] & ~b_water)) & ~ice_flash), .LD(still | reset), .Din(16'd288), .Q(slug_pixY_B));
    assign slug_pixY_T = slug_pixY_B - 16'd16;
    //-----------------------------
    
    // flashing
    wire down_flash, edge_out;
    countUD4L flash_1( .clk(clk), .UD(1'b1), .CE(slow_ddb), .LD(1'b0), .UTC(down_flash));
    edge_detector edge_flash( .clk(clk), .x(down_flash), .y(edge_out));
    FDRE #(.INIT(1'b0) ) flashing_FF1 (.C(clk), .R(1'b0), .CE(edge_out), .D(~slug_flash), .Q(slug_flash));
    
endmodule
