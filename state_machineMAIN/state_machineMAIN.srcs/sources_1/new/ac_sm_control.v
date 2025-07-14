`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amos Cao
// 
// Create Date: 04/29/2024 01:49:49 AM
// Design Name: 
// Module Name: ac_sm_control
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


module ac_sm_control(
    input Go,
    input Now,
    input TZ,
    input Leq4,
    input LastLED,
    input T4,
    input T2,
    input cheat_sw,
    input [7:0] prev_state,
    
    output [7:0] next_state,
    output CntDwn,
    output LDTgt,
    output IncSc,
    output RLED,
    output ShowGT,
    output FlashScore,
    output ShLED,
    output RTimer
    );
   

    /////////// input states /////////////
    // chill -> prev_state[0]
    assign next_state[0] = (prev_state[0] & ~cheat_sw & ~Go) | (prev_state[1] & ~cheat_sw & ~Go)| (prev_state[5] & ~cheat_sw & T4) | (prev_state[7] & ~cheat_sw & T2); // for chill and chill cheat i switched them from not to regular
        
    // chill cheat -> prev_state[1]
    assign next_state[1] = (prev_state[1] & cheat_sw & ~Go) | (prev_state[0] & cheat_sw & ~Go) | (prev_state[5] & cheat_sw & T4) | (prev_state[7] & cheat_sw & T2 );
    
    // game start -> prev_state[2]
    assign next_state[2] = (prev_state[0] & Go) | (prev_state[1] & Go) | (prev_state[2] & ~LastLED);
    
    // expectation -> prev_state[3]
    assign next_state[3] = (prev_state[3] & ~Now & ~TZ) | (prev_state[2] & ~cheat_sw & LastLED);
     
    // cheat expectation -> prev_state[4]
    assign next_state[4] = (prev_state[4] & ~Now & ~TZ) | (prev_state[2] & cheat_sw & LastLED);
    
    // game over -> prev_state[5]
    assign next_state[5] = (prev_state[3] & Now & ~Leq4) | (prev_state[4] & Now & ~Leq4) | (prev_state[3] & TZ) | (prev_state[4] & TZ) | (prev_state[5] & ~T4); 
    
    // game win -> prev_state[6]
    assign next_state[6] = (prev_state[3] & Now & Leq4) | (prev_state[4] & Now & Leq4) | (prev_state[6] & ~T2);
    
    // reflash -> prev_state[7]
    assign next_state[7] = (prev_state[6] & T2) | (prev_state[7] & ~T2);
    
    /////////// outputs /////////////
    assign CntDwn = (prev_state[3] & ~TZ & ~Now) | (prev_state[4] & ~TZ & ~Now);
    //assign LDTgt = (prev_state[0] & Go) & (prev_state[1] & Go) | (prev_state[2] & LastLED);
    assign LDTgt = (prev_state[0] & Go) | (prev_state[1] & Go);
    assign IncSc = prev_state[6] & T2;
    assign RLED = prev_state[2] & LastLED;
    assign ShowGT = (prev_state[1] & cheat_sw & ~Go) | (prev_state[0] & Go) | (prev_state[1] & Go) | (prev_state[2] & ~LastLED) | next_state[4];
    assign FlashScore = (prev_state[5] & ~T4) | (prev_state[6] & ~T2) | (prev_state[7] & ~T2);
    assign ShLED = (prev_state[2] & ~LastLED);
    //assign RTimer = next_state[1] | next_state[2] | next_state[4];
    assign RTimer = (prev_state[3] & Now & Leq4) | (prev_state[4] & Now & Leq4) | (prev_state[3] & Now & ~Leq4) | (prev_state[4] & Now & ~Leq4) | (prev_state[6] & T2);
  
  /*
     /////////// input states /////////////
    // chill -> prev_state[0]
    assign next_state[0] = ((prev_state[0] | prev_state[1]) & ~cheat_sw & ~Go) | (prev_state[5] & ~cheat_sw & ~T4) | (prev_state[5] & ~cheat_sw & ~T2); // for chill and chill cheat i switched them from not to regular
    // cases: 1. in chill and go isn't pressed 2. from chill or chill cheat and cheat_sw is off 3. from game over, cheat_sw is off, T4 stops flashing 4. from game win, cheat_sw is off, T2 stops flashing
    
    // chill cheat -> prev_state[1]
    assign next_state[1] = ((prev_state[0] | prev_state[1]) & cheat_sw & ~Go) | (prev_state[5] & cheat_sw & ~T4) | (prev_state[6] & cheat_sw & ~T2 );
    // cases: 1. in chill cheat and go isn't pressed 2. from chill or chill cheat and cheat_sw is on 3. from game over, cheat_sw is on, T4 stops flashing 4. from game win, cheat_sw is on , T2 stops flashing
    
    // game start -> prev_state[2]
    assign next_state[2] = (((prev_state[0] & ~cheat_sw) | (prev_state[1] & cheat_sw)) & Go) | (prev_state[2] & ~LastLED);
    // cases: 1. if in chill or chill cheat and go is on 2. stays here until LastLED is on
    
    // expectation -> prev_state[3]
    assign next_state[3] = (prev_state[3] & ~Now & ~cheat_sw & ~TZ) | (prev_state[2] & ~cheat_sw & LastLED);
    // cases: 1. stays if Now and cheat_sw are off 2. from game start, cheat_sw is off and LastLED is on/up
     
    // cheat expectation -> prev_state[4]
    assign next_state[4] = (prev_state[4] & ~Now & cheat_sw & ~TZ) | (prev_state[2] & cheat_sw & LastLED);
    // cases: 1. stays if Now is off and cheat_sw is on 2. from game start, cheat_sw is off and LastLED is on/up
    
    // game over -> prev_state[5]
    assign next_state[5] = ((((prev_state[3] & ~cheat_sw) | (prev_state[4] & cheat_sw)) & ((Now & ~Leq4) | (~Now & Leq4)) & T4) | (((prev_state[3] & ~cheat_sw) | (prev_state[4] & cheat_sw)) & ~Now & TZ)) | (prev_state[6] & T2) | (prev_state[5] & T4); // added ~Now to 2.
    // cases: 1. from expectation or cheat expectation anded with: 2. Now as on and Leq4 as off or Now as off and Leq4 on
    
    // game win -> prev_state[6]
    assign next_state[6] = (((prev_state[3] & ~cheat_sw) | (prev_state[4] & cheat_sw)) & (Now & Leq4) & T2);
    // cases: 1. from expectation or cheat expectation anded with: 2. Now and Leq4 both on.
    
    /////////// outputs /////////////
    assign CntDwn = (((prev_state[0] & ~cheat_sw) | (prev_state[1] & cheat_sw)) & Go) | (prev_state[2] & ~LastLED);
    assign LDTgt = (((prev_state[0] & ~cheat_sw) | (prev_state[1] & cheat_sw)) & Go) | (prev_state[2] & ~LastLED);
    assign IncSc = (((prev_state[3] & ~cheat_sw) | (prev_state[4] & cheat_sw)) & (Now & Leq4));
    assign RLED = (prev_state[2] & ~cheat_sw & LastLED) | (prev_state[2] & cheat_sw & LastLED);
    assign ShowGT = (prev_state[1] & cheat_sw) | (((prev_state[0] & ~cheat_sw) | (prev_state[1] & cheat_sw)) & Go) | (prev_state[2] & ~LastLED) | (prev_state[4] & ~Now & cheat_sw) | (prev_state[2] & cheat_sw & LastLED);
    assign FlashScore = (((prev_state[3] & ~cheat_sw) | (prev_state[4] & cheat_sw)) & ((Now & ~Leq4) | (~Now & Leq4))) | (((prev_state[3] & ~cheat_sw) | (prev_state[4] & cheat_sw)) & (Now & Leq4)) | (prev_state[6] & T2) | (prev_state[5] & T4);
    assign ShLED = ((prev_state[0] | prev_state[1]) & Go ) | (prev_state[2] & ~LastLED);  //(((prev_state[2] & ~cheat_sw ) | (prev_state[2] & cheat_sw)) & ~LastLED & CntDwn);
    assign RTimer = (((prev_state[0] & ~cheat_sw) | (prev_state[1] & cheat_sw)) & Go);
 */
 
endmodule
