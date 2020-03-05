`default_nettype none


module led_band_address_computer
#(
    parameter PCB_ANGLE   = 0,
    parameter ADDR_WIDTH  = 14,
    parameter LED_ROW_WIDTH   = 5, 
    parameter NB_ANGLES   = 128
)
(
    led_row,
    angle,
    color,
    r_addr
);

localparam ANGLE_WIDTH = $clog2(NB_ANGLES);

input wire [LED_ROW_WIDTH-1:0] led_row;
input wire [ANGLE_WIDTH-1:0] angle;
input wire [1:0] color;
wire  [ADDR_WIDTH-1:0] color_extended = {{ADDR_WIDTH-2{1'b0}} , color};

wire  [ANGLE_WIDTH-1:0] abs_angle = angle + PCB_ANGLE;

output wire [ADDR_WIDTH-1:0] r_addr;
assign r_addr = color_extended + 3 * abs_angle + 3 * NB_ANGLES * led_row;

endmodule
