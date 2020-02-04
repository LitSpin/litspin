/*
 * Memory module containing the data of a full 2D cylinder.
 * It has to be inferred as a double channel double clock RAM.
 * This is a 110592 bits memory.
 */ 

module led_band_memory#(
                        parameter W_ADDR_WIDTH=11,
                        parameter W_DATA_WIDTH=128,

                        parameter R_ADDR_WIDTH=15,
                        parameter R_DATA_WIDTH=8
                      )
                      (
                        r_clk,
                        read,
                        r_addr,
                        r_data ,
                        w_addr ,
                        w_data ,
                        w_clk  ,
                        write
                      );


input         r_clk, read;
input        [R_ADDR_WIDTH-1:0] r_addr;
output logic [R_DATA_WIDTH-1:0] r_data;

input w_clk, write;
input [W_ADDR_WIDTH-1:0] w_addr;
input [W_DATA_WIDTH-1:0] w_data;

localparam RATIO_WIDTH = W_DATA_WIDTH / R_DATA_WIDTH;
localparam W_WORDS_NB = 2**W_ADDR_WIDTH;

logic [RATIO_WIDTH-1 : 0][R_DATA_WIDTH -1 : 0] mem [0:W_WORDS_NB-1];

always@(posedge r_clk)
    if(read)
    r_data <= mem[r_addr/16][r_addr%16];

always@(posedge w_clk)
    if(write)
        mem[w_addr] <= w_data;

endmodule
