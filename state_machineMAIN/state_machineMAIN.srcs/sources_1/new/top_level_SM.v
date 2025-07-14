`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2024 01:15:02 AM
// Design Name: 
// Module Name: top_level_SM
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


module top_level_SM(
    input btnU,
    input btnC,
    input btnR,
    input clkin,
    input [15:0] sw,
    
    output [15:0] led,
    output [3:0] an,
    output [6:0] seg,
    output dp
    );
    
    wire clk, digsel, qsec;
    
    wire [15:0] Q_LED;
    wire [3:0] Q_timer_out;
    wire [3:0] Q_score;
    wire [3:0] select_in;
    wire [3:0] hex_in;
    wire [7:0] Q_rand;
    wire [7:0] Q_gameTime;
    wire [15:0] main_values;
    
    wire Go, Now, TZ, Leq4, LastLED, T4, T2, cheat_sw;
    wire CntDwn, LDTgt, IncSc, RLED, ShowGT, FlashScore, ShLED, RTimer;
    wire [7:0] TimeTgt;
    
    assign Go = btnC;
    assign Now = btnU;
    assign dp = 1'b1;
    assign cheat_sw = sw[2];
    
    // clk adjustment to quarter seconds
    qsec_clks quarter_seconds( .clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel), .qsec(qsec));
    
    // lfsr
    LFSR number_generator(.clk(clk), .rnd(Q_rand));
    
    // game time
    assign TimeTgt = {10'b0, (({4|{Q_rand[7:4]}} & Q_rand[7:4]) | (4'b0100)), 2'b0};
    game_time sm_game_timer(.CntDwn(CntDwn), .qsec(qsec), .LDTgt(LDTgt), .TimeTgt(TimeTgt), .clk(clk), .Q_gt(Q_gameTime), .TZ(TZ));
    
    // led shifter
    assign Q_LED = led[15:0];
    assign LastLED = led[15];
    led_shifter1 led_tOn(.R(RLED), .Shift(ShLED & qsec), .clk(clk), .Q_leds(Q_LED)); // removed ShLED
    
    // score counter
    score_counter1 display1_score(.IncSc(IncSc), .clk(clk), .score(Q_score));
    
    // timer
    assign Leq4 = (~|Q_gameTime[7:3]) & (~Q_gameTime[2] | (Q_gameTime[2] & ~Q_gameTime[1] & ~Q_gameTime[0]));
    assign T4 = &Q_timer_out;
    assign T2 = &Q_timer_out[2:0];
    timer sm_Leq4_timer(.qsec(qsec), .RTimer(RTimer), .clk(clk), .Q_timer(Q_timer_out));
    
    // state machine
    ac_state_machine game_brain(.Go(Go), .Now(Now), .TZ(TZ), .Leq4(Leq4), .LastLED(LastLED), .T4(T4), .T2(T2), .cheat_sw(cheat_sw), .clk(clk),
                                .CntDwn(CntDwn), .LDTgt(LDTgt), .IncSc(IncSc), .RLED(RLED), .ShowGT(ShowGT), .FlashScore(FlashScore), .ShLED(ShLED), .RTimer(RTimer));
    
    // ring counter
    ring_counter displays_on(.Advance(digsel), .clk(clk), .Q_r(select_in));
    
    // selector
    //wire all_zero;
    //assign all_zero = ~|{3'b000, Q_gameTime[2]};
    assign main_values = {Q_score, 4'b0, Q_gameTime[5:2], 2'b0, Q_gameTime[1:0]}; 
    
    selector pick_value(.N(main_values), .sel(select_in), .H(hex_in));
    
    // hex7seg
    hex7seg hex_4_displays(.n(hex_in), .seg(seg));
    
    assign an[3] = ~(select_in[3] & (~FlashScore | Q_timer_out[0])); // ring counter output
    assign an[2] = 1'b1;
    assign an[1] = ~(select_in[1] & (cheat_sw | ShowGT));
    assign an[0] = ~(select_in[0] & (cheat_sw | ShowGT));

endmodule
