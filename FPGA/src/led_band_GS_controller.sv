`default_nettype none

module led_band_GS_controller
#(
    parameter COLOR_DATA_WIDTH = 8,
    parameter NB_ADDED_LSB_BITS = 1
)
(
    bit_sel,
    r_data,
    SOUT
);

localparam BIT_SEL_WIDTH = $clog2(COLOR_DATA_WIDTH + NB_ADDED_LSB_BITS);
input  wire [BIT_SEL_WIDTH-1:0]    bit_sel;
input  wire [COLOR_DATA_WIDTH-1:0] r_data;
output wire                        SOUT;

// The COLOR_DATA_WIDTH MSB sent are from rdata while the NB_ADDED_LSB_BITS are set to 0
assign SOUT = bit_sel < NB_ADDED_LSB_BITS ? 0
                                          : r_data[bit_sel - 1];

endmodule
