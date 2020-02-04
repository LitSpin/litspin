// Clock divider
// Generates a clock of period o_clk = i_clk / PARAMETER.
// PARAMETER can only be a multiple of 2.

module clk_divider
#(
    parameter FACTOR = 2 // division factor.
)
(
    input clk,
    input rst,
    output logic o_clk
);

// The state of o_clk is reversed every FACTOR/2 cycles of clk

// Counter
localparam H_FACTOR = FACTOR / 2;
localparam COUNTER_WIDTH = $clog2(H_FACTOR);
logic [COUNTER_WIDTH - 1 : 0] counter;
always_ff@(posedge clk)
    if(rst)
        counter <= 0;
    else
        if(counter < H_FACTOR - 1)
            counter <= counter + 1;
        else
            counter <= 0;

// o_clk assignment
always_ff@(posedge clk)
    if(rst)
        o_clk <= 0;
    else
        if(counter == H_FACTOR - 1)
            o_clk <= ~o_clk;


endmodule
