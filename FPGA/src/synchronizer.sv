module synchronizer
#(
    parameter SCLK_FACTOR = 4,            //SCLK clock division factor (must be even)
    parameter GCLK_FACTOR = 2,            //GCLK clock division factor (must be even)
    parameter ANGLE_COUNTER_WIDTH = 128,  //Gives the angle computer its max counter value
    parameter NB_ANGLES = 128,            //Angular precision (must be a power of 2)
    parameter NB_LEDS_PER_GROUP = 16,     //Number of leds per multiplexing group
    parameter NB_LED_ROWS = 32            //Number of leds in the vertical dimension
)
(
    clk,
    rst,
    turn_tick,
    force_fc,
    GCLK,
    SCLK,
    LAT,
    row_en,
    led_row,
    color,
    bit_sel
);

input clk;
input rst;

// Clock generator
output logic SCLK, GCLK;
clkgen
#(
    .SCLK_FACTOR(SCLK_FACTOR),
    .GCLK_FACTOR(GCLK_FACTOR)
)
clkgen_i
(
    .clk(clk),
    .rst(rst),
    .SCLK(SCLK),
    .GCLK(GCLK)
);

// Angle computer
localparam ANGLE_WIDTH = $clog2(NB_ANGLES);
input turn_tick;
wire [ANGLE_WIDTH - 1 : 0] angle;
angle_computer
#(
    .COUNTER_WIDTH(ANGLE_COUNTER_WIDTH),
    .NB_ANGLES(NB_ANGLES)
)
angle_computer_i
(
    .clk(clk),
    .rst(rst),
    .turn_tick(turn_tick),
    .angle(angle)
);

// Function control state machine
input force_fc;
wire FC_LAT;
wire FC_en;
FC_state_machine FC_state_machine_i
(
    .clk(clk),
    .rst(rst),
    .SCLK(SCLK),
    .force_fc(force_fc),
    .LAT(FC_LAT),
    .en(FC_en)
);

// GrayScale state machine
localparam LED_WIDTH = $clog2(NB_LEDS_PER_GROUP);
output wire [3:0] row_en;
output wire [1:0] color;
output wire [3:0] bit_sel;
wire [LED_WIDTH - 1:0] led;
wire GS_LAT;
GS_state_machine
#(
    .NB_ANGLES(NB_ANGLES),
    .NB_LEDS_PER_GROUP(NB_LEDS_PER_GROUP)
)
GS_state_machine_i
(
    .clk(clk),
    .rst(rst),
    .SCLK(SCLK),
    .angle(angle),
    .row_en(row_en),
    .led(led),
    .color(color),
    .bit_sel(bit_sel),
    .LAT(GS_LAT),
    .FC_en(FC_en)
);

// Multiplexing LookUp Table
localparam LED_ROW_WIDTH = $clog2(NB_LED_ROWS);
output [LED_ROW_WIDTH - 1 : 0] led_row;
multiplexing_LUT
#(
    .NB_LEDS_PER_GROUP(NB_LEDS_PER_GROUP),
    .NB_LED_ROWS(NB_LED_ROWS)
)
multiplexing_LUT_i
(
    .row_en(row_en),
    .led(led),
    .led_row(led_row)
);

// LAT multiplexer
output LAT;
assign LAT = FC_en ? FC_LAT : GS_LAT;

endmodule
