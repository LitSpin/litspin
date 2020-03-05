`default_nettype none

module sync_GS_state_machine
#(
    parameter NB_ANGLES = 128,
    parameter NB_LEDS_PER_GROUP = 16, //number of leds per multiplexing group.
                                     //must be a power of 2.
    parameter COLOR_DATA_WIDTH = 8,      // Number of bits per color in memory
    parameter NB_ADDED_LSB_BITS = 1      // Number of supplementary bits
                                         //  sent to the driver with value 0
)
(
    clk     ,
    rst     ,
    SCLK    ,
    angle   ,
    mux_en  ,
    led     ,
    color   ,
    bit_sel ,
    LAT     ,
    FC_en
);

input wire clk;
input wire rst;

// Inputs
localparam ANGLE_WIDTH = $clog2(NB_ANGLES);
input wire FC_en;
input wire [ANGLE_WIDTH - 1 : 0] angle;
input wire SCLK;

// Outputs
localparam LED_WIDTH = $clog2(NB_LEDS_PER_GROUP);
localparam BIT_SEL_NB = COLOR_DATA_WIDTH + NB_ADDED_LSB_BITS;
localparam BIT_SEL_WIDTH = $clog2(BIT_SEL_NB);
output enum logic [1:0] {R, G, B} color;
output logic [LED_WIDTH-1:0] led;
output logic [BIT_SEL_WIDTH-1:0] bit_sel; 
output logic [3:0] mux_en;
output wire LAT;

// SCLK posedge detection
logic prev_SCLK;
wire  posedge_SCLK = SCLK & ~prev_SCLK;
always_ff@(posedge clk)
    prev_SCLK <= SCLK;

// New angle detection
logic [ANGLE_WIDTH - 1 : 0] prev_angle;
wire new_angle = angle != prev_angle;
always_ff@(posedge clk)
    prev_angle <= angle;

// color goes B, G, R at every posedge of SCLK. 
wire end_color = color == R;
always@(posedge clk)
    if(rst)
        color <= B;
    else
        if(FC_en | new_angle)
            color <= B;
        else if(posedge_SCLK)
            case(color)
                B: color <= G;
                G: color <= R;
                default: color <= B;
            endcase

// Led goes from 15 to 0 each time color has completed a B,G,R cycle
wire end_led = led == '0;
always@(posedge clk)
    if(rst)
        led <= {LED_WIDTH{1'b1}};
    else
        if(FC_en | new_angle)
            led <= {LED_WIDTH{1'b1}};
        else if(posedge_SCLK & end_color)
            led <= led - 1;


wire end_bit_sel = bit_sel == 0;
always@(posedge clk)
    if(rst)
        bit_sel <= BIT_SEL_NB - 1;
    else
        if(FC_en | new_angle)
            bit_sel <= 4'h8;
        else 
            if(posedge_SCLK & end_led & end_color)
            begin
                bit_sel <= bit_sel - 1;
                if(bit_sel == 0)
                    bit_sel <= 4'h8;
            end


enum logic [3:0] {init, display0, display1, display2, display3, finish} multiplex_state;
always@(posedge clk)
    if(rst)
        multiplex_state <= init;
    else
        if(FC_en | new_angle)
            multiplex_state <= init;
        else
            if(posedge_SCLK & end_led & end_color & end_bit_sel)
                case(multiplex_state)
                    init    : multiplex_state <= display0;
                    display0: multiplex_state <= display1;
                    display1: multiplex_state <= display2;
                    display2: multiplex_state <= display3;
                    default : multiplex_state <= finish;
                endcase

always_comb
begin
    case(multiplex_state)
        display0: mux_en <= 4'b0001;
        display1: mux_en <= 4'b0010;
        display2: mux_en <= 4'b0100;
        display3: mux_en <= 4'b1000;
        default : mux_en <= 4'b0000;
    endcase
end

wire LAT_WRTGS = end_led & end_color;
wire LAT_LATGS = end_led & end_bit_sel;
assign LAT = LAT_WRTGS | LAT_LATGS;

endmodule
