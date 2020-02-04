`default_nettype none


module address_computer
#(
    parameter PCB_ANGLE   = 0,
    parameter ADDR_WIDTH  = 14,
    parameter ROW_WIDTH   = 5, 
    parameter NB_ANGLES   = 128
)
(
    row,
    angle,
    color,
    r_addr
);

localparam ANGLE_WIDTH = $clog2(NB_ANGLES);

input wire [ROW_WIDTH - 1:0] row;
input wire [ANGLE_WIDTH - 1:0] angle;
input wire [1:0] color;
wire  [13:0] color_extended = {12'h0 , color};

wire  [6:0] abs_angle = angle + PCB_ANGLE;

output wire [ADDR_WIDTH - 1:0] r_addr;
assign r_addr = color_extended + 3 * abs_angle + 3 * NB_ANGLES * row;

endmodule
