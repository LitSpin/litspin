`default_nettype none

module synchronizer
#(
    parameter SCLK_FACTOR = 4,           // SCLK clock division factor (must be even)
    parameter GCLK_FACTOR = 2,           // GCLK clock division factor (must be even)
    parameter ANGLE_COUNTER_WIDTH = 128, // Gives the angle computer its max counter value
    parameter NB_ANGLES = 128,           // Angular precision (must be a power of 2)
    parameter NB_LEDS_PER_GROUP = 16,    // Number of leds per multiplexing group
    parameter NB_LED_ROWS = 32,          // Number of leds in the vertical dimension
    parameter COLOR_DATA_WIDTH = 8,      // Number of bits per color in memory
    parameter NB_ADDED_LSB_BITS = 1      // Number of supplementary bits
                                         //  sent to the driver with value 0
)
(
    clk,
    rst,
    turn_tick,
    write_fc,
    GCLK,
    SCLK,
    lbc_SCLK,
    LAT,
    lbc_LAT,
    mux_en,
    lbc_mux_en,
    led_row,
    color,
    bit_sel,
    angle,
    hps_override,
    hps_SCLK,
    hps_LAT
);

input wire clk;
input wire rst;

// from HPS
input wire hps_override;
input wire hps_SCLK;
input wire hps_LAT;
input wire write_fc;

// from sensor
input wire turn_tick;

// output to driver
output wire SCLK;
output wire GCLK;
output wire LAT;
output wire [3:0] mux_en;

// ouput to led band controller
localparam ANGLE_WIDTH = $clog2(NB_ANGLES);
localparam LED_WIDTH = $clog2(NB_LEDS_PER_GROUP);
localparam LED_ROW_WIDTH = $clog2(NB_LED_ROWS);
localparam BIT_SEL_WIDTH = $clog2(COLOR_DATA_WIDTH + NB_ADDED_LSB_BITS);
output wire [ANGLE_WIDTH-1:0] angle;
output wire [1:0] color;
output wire [BIT_SEL_WIDTH-1:0] bit_sel;
output wire [LED_ROW_WIDTH-1:0] led_row;
output wire lbc_LAT;
output wire lbc_SCLK;
output wire [3:0] lbc_mux_en;
assign lbc_LAT = LAT;
assign lbc_SCLK = SCLK;
assign lbc_mux_en = mux_en;

// Clock generator
wire gen_SCLK;
assign SCLK = hps_override ? hps_SCLK : gen_SCLK;
sync_clkgen
#(
    .SCLK_FACTOR(SCLK_FACTOR),
    .GCLK_FACTOR(GCLK_FACTOR)
)
clkgen
(
    .clk(clk),
    .rst(rst),
    .SCLK(gen_SCLK),
    .GCLK(GCLK)
);

// Angle computer

sync_angle_computer
#(
    .COUNTER_WIDTH(ANGLE_COUNTER_WIDTH),
    .NB_ANGLES(NB_ANGLES)
)
angle_computer
(
    .clk(clk),
    .rst(rst),
    .turn_tick(turn_tick),
    .angle(angle)
);

// Function control state machine
wire FC_LAT;
wire FC_en;
sync_FC_state_machine FC_state_machine
(
    .clk(clk),
    .rst(rst),
    .SCLK(SCLK),
    .write_fc(write_fc),
    .LAT(FC_LAT),
    .en(FC_en)
);

// GrayScale state machine
wire [LED_WIDTH - 1:0] led;
wire GS_LAT;
sync_GS_state_machine
#(
    .NB_ANGLES(NB_ANGLES),
    .NB_LEDS_PER_GROUP(NB_LEDS_PER_GROUP)
)
GS_state_machine
(
    .clk(clk),
    .rst(rst),
    .SCLK(SCLK),
    .angle(angle),
    .mux_en(mux_en),
    .led(led),
    .color(color),
    .bit_sel(bit_sel),
    .LAT(GS_LAT),
    .FC_en(FC_en)
);

// Multiplexing LookUp Table
sync_multiplexing_LUT
#(
    .NB_LEDS_PER_GROUP(NB_LEDS_PER_GROUP),
    .NB_LED_ROWS(NB_LED_ROWS)
)
multiplexing_LUT
(
    .mux_en(mux_en),
    .led(led),
    .led_row(led_row)
);

// LAT multiplexer
assign LAT = hps_override ? hps_LAT : (FC_en ? FC_LAT : GS_LAT);

endmodule
