module leds
(
    input clk,
    input rst,

    input [3:0] addr,
    input [7:0] data,
    input we,

    output logic [9:0] led
);

always@(posedge clk)
    if(rst)
        led <= '0;
    else
        if(we)
            led[addr] <= data[0];

endmodule
