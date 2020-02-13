`default_nettype none

module hps_io
#(
    parameter W_ADDR_WIDTH = 2,
    parameter W_DATA_WIDTH = 32,
    parameter NB_LED_BAND = 20
)
(
    clk,
    rst_in,
    turn_tick,

    w_addr,
    w_data,
    write,

    rst_out,
    new_frame,
    force_fc,
    hps_override,
    hps_SOUT,
    hps_LAT,
    hps_SCLK,
    hps_turn_tick,
    PD,
    turn_tick_IRQ
);

input wire clk, rst_in, turn_tick;
// Unused address
input wire [W_ADDR_WIDTH - 1 : 0] w_addr;
input wire [W_DATA_WIDTH - 1 : 0] w_data;
input wire write;

localparam RST_BIT = 0;
output wire rst_out;
localparam NEW_FRAME_BIT = 1;
output wire new_frame;
localparam FORCE_FC_BIT = 2;
output wire force_fc;
localparam HPS_OVERRIDE_BIT = 3;
output wire hps_override;
localparam HPS_SOUT_BIT = 4;
output wire [NB_LED_BAND - 1 : 0] hps_SOUT;
localparam HPS_LAT_BIT = 4;
output wire hps_LAT;
localparam HPS_SCLK_BIT = 5;
output wire hps_SCLK;
localparam HPS_TURN_TICK_BIT = 6;
output wire hps_turn_tick;
localparam PD_BIT = 7;
output wire PD;
// The output turn_tick_IRQ is high after the negedge of turn_tick
// until 1 is written to the CLEAR_TURN_TICK_IRQ_BIT
localparam CLEAR_TURN_TICK_IRQ_BIT = 28;
output logic turn_tick_IRQ;

logic [W_DATA_WIDTH - 1 : 0] register;

localparam [W_DATA_WIDTH - 1 : 0] default_register = {W_DATA_WIDTH{1'b0}};

always@(posedge clk)
    if(rst_in)
        register <= default_register;
    else
        if(write)
            register <= w_data;

assign rst_out = register[RST_BIT];
assign force_fc = register[NEW_FRAME_BIT];
assign new_frame = register[FORCE_FC_BIT];
assign hps_override = register[HPS_OVERRIDE_BIT];
assign hps_LAT = register[HPS_LAT_BIT];
assign hps_SCLK = register[HPS_SCLK_BIT];
assign hps_turn_tick = register[HPS_TURN_TICK_BIT];
assign hps_SOUT = register[HPS_SOUT_BIT + NB_LED_BAND - 1 : HPS_SOUT_BIT];
assign PD = ~register[PD_BIT];

logic prev_turn_tick;
wire negedge_turn_tick = prev_turn_tick & ~turn_tick;
always@(posedge clk)
    prev_turn_tick <= turn_tick;

always@(posedge clk)
    if(rst_in)
        turn_tick_IRQ <= 0;
    else
    begin
        if(register[CLEAR_TURN_TICK_IRQ_BIT])
            turn_tick_IRQ <= 0;
        else if(negedge_turn_tick)
            turn_tick_IRQ <= 1;
    end

endmodule
