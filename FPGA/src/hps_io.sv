module hps_io
#(
    parameter W_ADDR_WIDTH = 2,
    parameter W_DATA_WIDTH = 32,
    parameter NB_LED_BAND = 20
)
(
    clk,
    rst_in,

    w_addr,
    w_data,
    write,

    rst_out,
    new_frame,
    force_fc,
    hps_override,
    hps_SOUT,
    hps_LAT,
    hps_SCLK,
    hps_turn_tick
);

input wire clk, rst_in;
// Unused address
input wire [W_ADDR_WIDTH - 1 : 0] w_addr;
input wire [W_DATA_WIDTH - 1 : 0] w_data;
input wire write;

output wire rst_out;
output wire new_frame;
output wire force_fc;
output wire hps_override;
output wire [NB_LED_BAND - 1 : 0] hps_SOUT;
output wire hps_LAT;
output wire hps_SCLK;
output wire hps_turn_tick;

logic [W_DATA_WIDTH - 1 : 0] register;

localparam [W_DATA_WIDTH - 1 : 0] default_register = {W_DATA_WIDTH{1'b0}};

always@(posedge clk)
    if(rst_in)
        register <= default_register;
    else
        if(write)
            register <= w_data;

assign rst_out = register[0];
assign force_fc = register[1];
assign new_frame = register[2];
assign hps_override = register[3];
assign hps_LAT = register[4];
assign hps_SCLK = register[5];
assign hps_turn_tick = register[6];
assign hps_SOUT = register[7 + NB_LED_BAND - 1 : 7];

endmodule
