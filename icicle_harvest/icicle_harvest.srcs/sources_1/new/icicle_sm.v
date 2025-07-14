`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2024 05:59:49 PM
// Design Name: 
// Module Name: icicle_sm
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


module icicle_sm(
    input clk,
    input btnC,
    input cyan_hi, magenta_hi,
    input touch_water,
    input hit,
    input time_up,
    input T4,

    output spawn,
    output init_timer,
    output drop,
    output flash,
    output increment,
    output decrement
    );
    
    wire [4:0] pres_state, next_state;
    icicle_ctrl_logic icicle_brain( .btnC(btnC), .cyan_hi(cyan_hi), .magenta_hi(magenta_hi), .touch_water(touch_water), .hit(hit), .time_up(time_up), .T4(T4), .pres_state(pres_state),
                                    .next_state(next_state), .spawn(spawn), .init_timer(init_timer), .drop(drop), .flash(flash), .increment(increment), .decrement(decrement));
    
    FDRE #(.INIT(1'b1) ) icicle_sm_ff0 (.C(clk), .R(1'b0), .CE(1'b1), .D(next_state[0]), .Q(pres_state[0]));
    FDRE #(.INIT(1'b0) ) icicle_sm_ff1 (.C(clk), .R(1'b0), .CE(1'b1), .D(next_state[1]), .Q(pres_state[1]));
    FDRE #(.INIT(1'b0) ) icicle_sm_ff2 (.C(clk), .R(1'b0), .CE(1'b1), .D(next_state[2]), .Q(pres_state[2]));
    FDRE #(.INIT(1'b0) ) icicle_sm_ff3 (.C(clk), .R(1'b0), .CE(1'b1), .D(next_state[3]), .Q(pres_state[3]));
    FDRE #(.INIT(1'b0) ) icicle_sm_ff4 (.C(clk), .R(1'b0), .CE(1'b1), .D(next_state[4]), .Q(pres_state[4]));
    
endmodule
