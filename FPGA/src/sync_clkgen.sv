`default_nettype none

module sync_clkgen
#(
    parameter SCLK_FACTOR = 8, // SCLK division factor TODO choose value
    parameter GCLK_FACTOR = 4  // GCLK division factor  TODO choose value
)
(
    input wire  clk,
    input wire  rst,
    output wire SCLK,
    output wire GCLK
);

sync_clk_divider
#(
    .FACTOR(SCLK_FACTOR)
)
SCLK_divider
(
    .clk(clk),
    .rst(rst),
    .o_clk(SCLK)
);

sync_clk_divider 
#(
    .FACTOR(GCLK_FACTOR)
)
GCLK_divider
(
    .clk(clk),
    .rst(rst),
    .o_clk(GCLK)
);

endmodule
