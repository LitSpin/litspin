`default_nettype none
/*
* Memory module containing the data of a full 2D cylinder.
* It has to be inferred as a double channel double clock RAM.
* This is a 110592 bits memory.
*/ 

module led_band_memory
#(
    parameter W_ADDR_WIDTH = 11,
    parameter W_DATA_WIDTH = 128,
    parameter R_ADDR_WIDTH = 15,
    parameter R_DATA_WIDTH = 8
)
(
    clk,

    r_addr,
    r_data ,
    r_enable,
    w_addr ,
    w_data ,
    w_enable
);

input wire                         clk;

input  wire                        r_enable;
input  wire  [R_ADDR_WIDTH-1:0]    r_addr;
output logic [R_DATA_WIDTH-1:0]    r_data;

input wire w_enable;
input wire [W_ADDR_WIDTH-1:0] w_addr;
input wire [W_DATA_WIDTH-1:0] w_data;

localparam RATIO_WIDTH = W_DATA_WIDTH / R_DATA_WIDTH;
localparam W_WORDS_NB = 2**W_ADDR_WIDTH;

logic [RATIO_WIDTH-1 : 0][R_DATA_WIDTH -1 : 0] mem [0:W_WORDS_NB-1];

always@(posedge clk)
begin
    if(r_enable)
        r_data <= mem[r_addr/16][r_addr%16];
    if(w_enable)
        mem[w_addr] <= w_data;
end

endmodule
