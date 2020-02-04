module clkgen
#(
    parameter SCLK_FACTOR = 8, // SCLK division factor TODO choose value
    parameter GCLK_FACTOR = 4  // GCLK division factor  TODO choose value
)
(
    input clk,
    input rst,
    output SCLK,
    output GCLK
);

clk_divider
#(
    .FACTOR(SCLK_FACTOR)
)
SCLK_divider
(
    .clk(clk),
    .rst(rst),
    .o_clk(SCLK)
);

clk_divider 
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
