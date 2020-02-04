module GS_state_machine
#(
    parameter NB_ANGLES = 128,
    parameter NB_LEDS_PER_GROUP = 16 //number of leds per multiplexing group.
                                     //must be a power of 2.
)
(
    clk     ,
    rst     ,
    SCLK    ,
    angle   ,
    row_en  ,
    led     ,
    color   ,
    bit_sel ,
    LAT,
    FC_en
);

input clk;
input rst;
input FC_en;

input SCLK;
logic prev_SCLK;
wire  posedge_SCLK = SCLK & ~prev_SCLK;
always_ff@(posedge clk)
    prev_SCLK <= SCLK;

// New angle detection
localparam ANGLE_WIDTH = $clog2(NB_ANGLES);
input [ANGLE_WIDTH - 1 : 0] angle;
logic [ANGLE_WIDTH - 1 : 0] prev_angle;
wire new_angle = angle != prev_angle;
always_ff@(posedge clk)
    prev_angle <= angle;

// color goes B, G, R at every posedge of SCLK. 
output enum logic [1:0] {R, G, B} color;
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
                R: color <= B;
            endcase

// Led goes from 0 to 15 each time color has completed a B,G,R cycle
localparam LED_WIDTH = $clog2(NB_LEDS_PER_GROUP);
output logic [LED_WIDTH - 1 : 0] led;
wire end_led = led == {LED_WIDTH{1'b1}};
always@(posedge clk)
    if(rst)
        led <= 0;
    else
        if(FC_en | new_angle)
            led <= 0;
        else if(posedge_SCLK & end_color)
            led <= led + 1;


output logic [3:0] bit_sel; 
wire end_bit_sel = bit_sel == 0;
always@(posedge clk)
    if(rst)
        bit_sel <= 4'h9;
    else
        if(FC_en | new_angle)
            bit_sel <= 4'h9;
        else 
            if(posedge_SCLK & end_led & end_color)
            begin
                bit_sel <= bit_sel - 1;
                if(bit_sel == 0)
                    bit_sel <= 4'h9;
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
                    display3: multiplex_state <= finish;
                    finish  : multiplex_state <= finish;
                endcase

output logic [3:0] row_en;
always_comb
begin
    case(multiplex_state)
        display0: row_en <= 4'b0001;
        display1: row_en <= 4'b0010;
        display2: row_en <= 4'b0100;
        display3: row_en <= 4'b1000;
        default : row_en <= 4'b0000;
    endcase
end

output LAT;
wire LAT_WRTGS = end_led & end_color;
wire LAT_LATGS = end_led & end_bit_sel;
assign LAT = LAT_WRTGS | LAT_LATGS;

endmodule
