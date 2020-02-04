`default_nettype none

module angle_computer
#(
    parameter COUNTER_WIDTH = 128, // sets the turn_turn_counter max value
    parameter NB_ANGLES     = 128  // number of angle, MUST be a power of 2
)
(
    clk,
    rst,
    turn_tick,
    angle
);

input wire clk;
input wire rst;
input wire turn_tick;

logic previous_turn_tick;
wire negedge_turn_tick = ~turn_tick && previous_turn_tick;
always_ff@(posedge clk)
    previous_turn_tick <= turn_tick;

// turn_counter counts up from zero during a turn and resets at negedge_turn_tick
logic [COUNTER_WIDTH - 1 : 0] turn_counter;
always_ff@(posedge clk)
    if(rst)
        turn_counter <= 0;
    else
        if(negedge_turn_tick)
            turn_counter <= 0;
        else
            turn_counter <= turn_counter + 1;

/*
 * angle_length contains the length in number if cycles of each
 * angle portion in the previous turn.
 * angle_length = prev_turn_length / NB_ANGLES
 * It is reset on negedge turn_tick.
 */ 
localparam ANGLE_WIDTH = $clog2(NB_ANGLES);
logic [COUNTER_WIDTH - ANGLE_WIDTH - 1 : 0] angle_length;
always_ff@(posedge clk)
    if(rst)
        angle_length <= 0; //TODO choose more relevant default value
    else
        if(negedge_turn_tick)
            angle_length <= turn_counter[COUNTER_WIDTH - 1: ANGLE_WIDTH];

/*
 * angle_counter counts the length of every angle division and resets when it reaches the
 * value angle_length, computed from the previous turn.
 * A negedge of turn_tick also resets the counter (new turn).
 */
logic [COUNTER_WIDTH - ANGLE_WIDTH - 1 : 0] angle_counter;
always@(posedge clk)
    if(rst)
        angle_counter <= 0;
    else
        if(angle_counter == angle_length | negedge_turn_tick)
            angle_counter <= 0;
        else
            angle_counter <= angle_counter + 1;

/* 
 * angle contains the current angle inferred from the previous turn length. 
 * angle is increased by each time angle_counter reaches angle_length
 * It is reset on negedge turn_tick.
 */ 
output logic [ANGLE_WIDTH - 1 : 0] angle;
always@(posedge clk)
    if(rst)
        angle <= 0;
    else
    begin
        if(angle_counter == angle_length)
            angle <= angle + 1;
        if(negedge_turn_tick)
            angle <= 0;
    end

endmodule
