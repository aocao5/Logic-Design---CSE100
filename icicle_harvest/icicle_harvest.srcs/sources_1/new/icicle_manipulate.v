`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2024 07:18:07 PM
// Design Name: 
// Module Name: icicle_manipulate
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


module icicle_manipulate(
    input clk,
    input btnC,
    input reset, // btnD
    input [15:0] ice_sidesL, ice_sidesR,
    input [15:0] slug_pixY_B, slug_pixY_T, slug_pixX_L, slug_pixX_R,
    input slug_flash,
    input [2:0] in_rnd,
    
    output [3:0] fade_bits,
    output [15:0] ice_T, ice_B,
    output [7:0] rnd_ice,
    output ice_flash,
    output ice_melt,
    output [3:0] led,
    output increment,
    output decrement
    );

    wire cyan_hi, magenta_hi, touch_water, hit, time_up, T4; // inputs for sm
    wire spawn, init_timer, drop, flash; // outputs for sm
    
    icicle_sm ice_states( .clk(clk), .btnC(btnC), .cyan_hi(cyan_hi), .magenta_hi(magenta_hi), .touch_water(touch_water), .hit(hit), .time_up(time_up), .T4(T4),
                          .spawn(spawn), .init_timer(init_timer), .drop(drop), .flash(flash), .increment(increment), .decrement(decrement)); 
    
    //------------------------------------------------------------------------
    // icicle init
    wire ice_still;
    wire [3:0] ice_still_adj;
    assign ice_still = (ice_still_adj == 4'd5); // changed 4'd1 to 5
    countUD4L ice_intial_still( .clk(clk), .UD(1'b1), .CE(time_up), .LD(touch_water | T4 | ice_still), .Din(4'd0), .Q(ice_still_adj)); // touch_water | T4 //.CE(ice_still & spawn) .CE(ice_still | time_up)
    
    //------------------------------------------------------------------------
    // fade in
    wire fade_count, fade_db;
    wire [15:0] fade_adj, fade_adj_db;
    assign fade_count = (fade_adj == 16'd10000); // og 5000
    assign fade_db = (fade_adj_db == 16'd250);
    counterUD16L fade_down( .clk(clk), .UD(1'b1), .CE(spawn), .LD(fade_count), .Din(16'd0), .Q(fade_adj)); // changed ce from time_up to spawn
    counterUD16L fade_downdouble( .clk(clk), .UD(1'b1), .CE(fade_count), .LD(fade_db), .Din(16'd0), .Q(fade_adj_db));
    
    wire stop_fade;
    assign stop_fade = ~(fade_bits == 4'hf);
    countUD4L fade_vga(.clk(clk), .UD(1'b1), .CE(fade_db & spawn & stop_fade), .LD(touch_water | T4), .Din(4'd0), .Q(fade_bits)); // took out time_up // took hit out from ld
    //------------------------------------------------------------------------
    // timer start
    LFSR random_time2to3_5( .clk(clk & ice_still), .rnd(rnd_ice)); // outputting rnd[0] and rnd[2:1]
    wire [3:0] generate_time, actual_time;
    assign generate_time = {1'b1, in_rnd[2], in_rnd[1], in_rnd[0]};
    //assign generate_time = {1'b1, rnd_ice[4], rnd_ice[0], rnd_ice[7]};
    
    assign time_up = generate_time == actual_time;
    
    //assign led = {hit, cyan_hi, 1'b0, magenta_hi}; // c and m swapped
    
    // assign led = {1'b0, flash, drop, hit};
    // assign led = fade_bits;
    // assign led = {3'b0, touch_water};
    // assign led = actual_time;
    // assign led = {rnd_ice[0], rnd_ice[3], rnd_ice[4], rnd_ice[7]};
    
    wire time_count, time_db;
    wire [15:0] time_adj, time_adj_db;
    assign time_count = (time_adj == 16'd40000); // og 5000
    assign time_db = (time_adj_db == 16'd100);
    counterUD16L time_down( .clk(clk), .UD(1'b1), .CE(init_timer), .LD(time_count), .Din(16'd0), .Q(time_adj)); 
    counterUD16L time_downdouble( .clk(clk), .UD(1'b1), .CE(time_count), .LD(time_db), .Din(16'd0), .Q(time_adj_db));
    
    countUD4L timer( .clk(clk), .UD(1'b1), .CE(~time_up & time_db), .LD(touch_water | T4), .Din(4'b0), .Q(actual_time)); // took hit out from ld
    
    //------------------------------------------------------------------------
    // fall
    //assign cyan_hi = (~rnd_ice[0] == 1'b1);
    //assign magenta_hi = (rnd_ice[0] == 1'b1);
    assign cyan_hi = (fade_bits == 4'hf) & (~rnd_ice[0] == 1'b1);
    assign magenta_hi = (fade_bits == 4'hf) & (rnd_ice[0] == 1'b1);
    //assign cyan_hi = stop_fade & rnd_ice[0];
    //assign magenta_hi = stop_fade & ~rnd_ice[0];
    //assign increment = hit;
    //assign decrement = hit;
    
    wire fall_count, fall_db;
    wire [15:0] fall_adj, fall_adj_db;
    assign fall_count = (fall_adj == 16'd3000); // og 5000
    assign fall_db = (fall_adj_db == 16'd70);
    counterUD16L fall_down( .clk(clk), .UD(1'b1), .CE(drop), .LD(fall_count), .Din(16'd0), .Q(fall_adj)); 
    counterUD16L fall_downdouble( .clk(clk), .UD(1'b1), .CE(fall_count), .LD(fall_db), .Din(16'd0), .Q(fall_adj_db));
    
    counterUD16L ice_Y_coords( .clk(clk), .UD(1'b1), .CE(fall_db & ~touch_water & ~flash), .LD(ice_still | reset | init_timer), .Din(16'd8), .Q(ice_T)); // & ~hit taken from ce // LD | touch_water | T4
    assign ice_B = ice_T + 16'd40;
    
    assign touch_water = (ice_T >= 16'd360);
    //------------------------------------------------------------------------
    // hit
    assign ice_flash = flash;
    assign hit = (((ice_B == slug_pixY_T) & (ice_sidesL + 16'd1 <= slug_pixX_R) & (ice_sidesR - 16'd1 >= slug_pixX_L)) | ((ice_sidesL + 16'd1 == slug_pixX_R) & (ice_T <= slug_pixY_B) & (ice_B >= slug_pixY_T)) | ((ice_sidesR - 16'd1 == slug_pixX_L) & (ice_T <= slug_pixY_B) & (ice_B >= slug_pixY_T)) | ((ice_T == slug_pixY_B) & (ice_sidesL + 16'd1 <= slug_pixX_R) & (ice_sidesR - 16'd1 >= slug_pixX_L)));
    // commenting out fixed drop?
    
    // flashing
    
    wire melt_count, melt_db;
    wire [15:0] melt_adj, melt_adj_db;
    assign melt_count = (melt_adj == 16'd5000); // og 5000
    assign melt_db = (melt_adj_db == 16'd1650);
    counterUD16L melt_down( .clk(clk), .UD(1'b1), .CE(flash), .LD(melt_count), .Din(16'd0), .Q(melt_adj)); 
    counterUD16L melt_downdouble( .clk(clk), .UD(1'b1), .CE(melt_count), .LD(melt_db), .Din(16'd0), .Q(melt_adj_db));
    
    wire [3:0] melt_length;
    countUD4L melt_length_time( .clk(clk), .UD(1'b1), .CE(slug_flash & ~T4 & flash & melt_db), .LD(ice_still | ~flash), .Din(4'b0), .Q(melt_length)); //.LD(hit | ice_still)
    
    assign T4 = (melt_length == 4'd4);
    assign ice_melt = ~(melt_length == 4'd4);
    
    //assign led[0] = T4;
    
    
    //------------------------------------------------------------------------
    
endmodule
