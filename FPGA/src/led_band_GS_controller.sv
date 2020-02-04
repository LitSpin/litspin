module led_band_GS_controller#(
    parameter BIT_PER_COLOR = 8
    )
    (
        bit_sel,
        r_data,
        SOUT
    );

input  [3:0]              bit_sel;
input  [BIT_PER_COLOR - 1:0] r_data;
output                       SOUT;

// The 8 MSB sent are from rdata while the LSB is set to 0
assign SOUT = bit_sel == 0 ? 0
                           : r_data[bit_sel - 1];

endmodule
