`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2024 05:59:49 PM
// Design Name: 
// Module Name: icicle_ctrl_logic
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


module icicle_ctrl_logic(
    input btnC,
    input cyan_hi, magenta_hi,
    input touch_water,
    input hit,
    input time_up,
    input T4,
    input [4:0] pres_state,
    
    output [4:0] next_state,
    output spawn,
    output init_timer,
    output drop,
    output flash,
    output increment,
    output decrement
    );
    
        // states
    // chill  
    assign next_state[0] = (pres_state[0] & ~btnC);
    // loc_pause
    assign next_state[1] = (pres_state[1] & ~time_up) | (pres_state[0] & btnC) | (pres_state[3] & touch_water) | (pres_state[4] & T4);
    // ice_fade
    assign next_state[2] = (pres_state[2] & ~(cyan_hi | magenta_hi)) | (pres_state[1] & time_up);
    // fall
    assign next_state[3] = (pres_state[3] & ~(touch_water | hit)) | (pres_state[2] & (cyan_hi | magenta_hi));
    // touch_ice
    assign next_state[4] = (pres_state[4] & ~T4) | (pres_state[3] & hit);
    
        // outputs
    assign spawn = (pres_state[1] & time_up) | (pres_state[2] & ~(cyan_hi | magenta_hi));
    assign init_timer = (pres_state[1] & ~time_up) | (pres_state[0] & btnC) | (pres_state[3] & touch_water) | (pres_state[4] & T4);
    assign drop = (pres_state[2] & (cyan_hi | magenta_hi)) | (pres_state[3] & ~(touch_water | hit));
    assign flash = (pres_state[4] & ~T4) | (pres_state[3] & hit);
    assign increment = (pres_state[3] & hit & cyan_hi); // (pres_state[3] & flash & cyan_hi); 
    assign decrement = (pres_state[3] & hit & magenta_hi);
    
endmodule
