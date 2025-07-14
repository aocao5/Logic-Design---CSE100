`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2024 12:26:50 AM
// Design Name: 
// Module Name: ac_state_machine
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


module ac_state_machine(
    input Go,
    input Now,
    input TZ,
    input Leq4,
    input LastLED,
    input T4,
    input T2,
    input cheat_sw,
    input clk,
    
    output CntDwn,
    output LDTgt,
    output IncSc,
    output RLED,
    output ShowGT,
    output FlashScore,
    output ShLED,
    output RTimer
    );
    
    wire [7:0] prev_state;
    wire [7:0] next_state;
    
    ac_sm_control procrastination( .Go(Go), .Now(Now), .TZ(TZ), .Leq4(Leq4), .LastLED(LastLED), .T4(T4), .T2(T2), .cheat_sw(cheat_sw), .prev_state(prev_state),
                                   .next_state(next_state), .CntDwn(CntDwn), .LDTgt(LDTgt), .IncSc(IncSc), .RLED(RLED), .ShowGT(ShowGT), .FlashScore(FlashScore), .ShLED(ShLED), .RTimer(RTimer));
    
    FDRE #(.INIT(1'b1) ) ac_sm_int0 (.C(clk), .R(1'b0), .CE(1'b1), .D(next_state[0]), .Q(prev_state[0]));
    FDRE #(.INIT(1'b0) )ac_sm_int123456[7:1] (.C({7{clk}}), .R(7'b0), .CE(7'b1111111), .D(next_state[7:1]), .Q(prev_state[7:1]));
    
    //game_time sm_game_time(.CntDwn(CntDwn), .qsec
    // Score Counter
    // Timer
    // LED shifter
    // LFSR
    
endmodule
