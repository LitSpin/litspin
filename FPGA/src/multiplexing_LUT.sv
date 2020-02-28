`default_nettype none

module multiplexing_LUT
#(
    parameter NB_LEDS_PER_GROUP = 16,
    parameter NB_LED_ROWS = 32
)
(
    row_en,
    led,
    led_row
);

// mux_table contains the height (led row) of each led in function of the multiplexing row and the number of the output
// of the driver on which the LED is connected.
localparam LED_ROW_WIDTH = $clog2(NB_LED_ROWS);
parameter [0 : 3][0 : NB_LEDS_PER_GROUP - 1][LED_ROW_WIDTH - 1 : 0] mux_table =
{
    {5'd0, 5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8, 5'd9, 5'd10, 5'd11, 5'd12, 5'd13, 5'd14, 5'd15},            //mux row 0
    {5'd16, 5'd17, 5'd18, 5'd19, 5'd20, 5'd21, 5'd22, 5'd23, 5'd24, 5'd25, 5'd26, 5'd27, 5'd28, 5'd29, 5'd30, 5'd31},  //mux row 1
    {5'd0, 5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8, 5'd9, 5'd10, 5'd11, 5'd12, 5'd13, 5'd14, 5'd15},            //mux row 2
    {5'd16, 5'd17, 5'd18, 5'd19, 5'd20, 5'd21, 5'd22, 5'd23, 5'd24, 5'd25, 5'd26, 5'd27, 5'd28, 5'd29, 5'd30, 5'd31}   //mux row 3
};

// mux_row_nb is the number of the next active multiplexing row.
// 0 is the default value
input wire [3:0] row_en;
logic [1:0] mux_row_nb;
always_comb
    case(row_en)
        4'b0001: mux_row_nb <= 1;
        4'b0010: mux_row_nb <= 2;
        4'b0100: mux_row_nb <= 3;
        default: mux_row_nb <= 0;
    endcase

localparam LED_WIDTH = $clog2(NB_LEDS_PER_GROUP);
input  wire [LED_WIDTH - 1 : 0] led;
output wire [LED_ROW_WIDTH - 1 : 0] led_row;
assign led_row = mux_table[mux_row_nb][led];

endmodule
