module hps_io
#(
    parameter W_ADDR_WIDTH = 1,
    parameter W_DATA_WIDTH = 32,
    parameter NB_LED_BAND = 20,
    parameter NB_MUX_ROWS = 4
)
(
    clk,
    rst_in,

    // avalon slave interface
    w_addr,
    w_data,
    write,

    // reset for all modules
    rst_out,

    // signals to the synchronizer
    new_frame,
    write_fc,
    hps_override_sync,
    hps_LAT,
    hps_SCLK,
    hps_turn_tick,

    // signals to the lbc
    hps_override_lbc,
    hps_SOUT,
    
    hps_row_en,
    PD,

    turn_tick_IRQ
);

input wire clk, rst_in;
// Unused address
input wire [W_ADDR_WIDTH - 1 : 0] w_addr;
input wire [W_DATA_WIDTH - 1 : 0] w_data;
input wire write;

output wire rst_out;
output wire new_frame;
localparam WRITE_FC_BIT = 2;
output wire write_fc;
localparam HPS_OVERRIDE_BIT = 3;
output wire hps_override_sync;
output wire hps_override_lbc = hps_override_sync;
localparam HPS_SOUT_BIT = 8;
output wire [NB_LED_BAND - 1 : 0] hps_SOUT;
output wire hps_LAT;
output wire hps_SCLK;
output wire hps_turn_tick;
localparam PD_BIT = 7;
output wire PD;
localparam HPS_ROW_EN_BIT = 28;
output wire [NB_MUX_ROWS - 1:0] hps_row_en;
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
assign write_fc = register[WRITE_FC_BIT];
assign new_frame = register[NEW_FRAME_BIT];
assign hps_override_sync = register[HPS_OVERRIDE_BIT];
assign hps_LAT = register[HPS_LAT_BIT];
assign hps_SCLK = register[HPS_SCLK_BIT];
assign hps_turn_tick = register[HPS_TURN_TICK_BIT];
assign hps_SOUT = register[HPS_SOUT_BIT + NB_LED_BAND - 1 : HPS_SOUT_BIT];
assign PD = ~register[PD_BIT];
assign hps_row_en = register[HPS_ROW_EN_BIT + NB_MUX_ROWS - 1 : HPS_ROW_EN_BIT];

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
