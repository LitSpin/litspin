`default_nettype none

module led_band_FC_setter
(   
    rst,
    clk,
    SCLK,
    en,
    SOUT,
    LAT,

    w_addr,
    w_data,
    w_enable
);

localparam FC_WIDTH = 48;

input wire  rst;
input wire  clk;
input wire  SCLK;
input wire  LAT;

// Avalon slave
input wire  w_addr;
input wire  [FC_WIDTH-1:0] w_data;
input wire  w_enable;

// Ouput
output wire SOUT;
output logic en;

/* Initialization: writing the settings in the driver.
 * This module detects the FCWRTEN signal and initiates
 * an output of the FC data on SOUT.
 * It starts one clk cycle after LAT falls and lasts for 48 SCLK posedge.
 * Thefore, the sync module MUST wait EXACTLY for 48 cycles between FCWRTEN and FCWRT.
 *
 * LAT  __---------------______________-------_
 *        (   FCWRTEN   )              (WRTFC)
 * SOUT ~~~~~~~~~~~~~~~~~[ FC with MSB first ]~
 *       <  15 cycles  ><     48 cycles     >
 */

logic [FC_WIDTH-1:0] FC;

always_ff@(posedge clk)
    if(w_enable)
        FC <= w_data;


logic prev_SCLK;
wire posedge_SCLK = SCLK & ~prev_SCLK;
always_ff@(posedge clk)
    prev_SCLK <= SCLK;


// Counts the number of SCLK rising edge while lat is high.
// WRTFC and FCWRTEN are high for one clk cycle after LAT falls. 
logic [3:0] lat_high_sclk_counter;
wire FCWRTEN = ~LAT & (lat_high_sclk_counter == 4'd15);
wire WRTFC = ~LAT & (lat_high_sclk_counter == 4'd5);
always_ff@(posedge clk)
    if(rst)
        lat_high_sclk_counter <= 0;
    else
    begin
        if(LAT & posedge_SCLK)
            lat_high_sclk_counter <= lat_high_sclk_counter + 1;
        if(~LAT) 
            lat_high_sclk_counter <= 0;
    end


// en is low while the FC setter is writing
always_ff@(posedge clk)
    if(rst)
        en <= 1;
    else
    begin
        if(FCWRTEN)
            en <= 0;
        if(WRTFC)
            en <= 1;
    end

// Counter goes from 47 to 0 while the FC is being written 
localparam COUNTER_WIDTH = $clog2(FC_WIDTH);
logic [COUNTER_WIDTH-1:0] counter;
assign SOUT = FC[counter];
always_ff@(posedge clk)
    if(rst)
        counter <= FC_WIDTH-1;
    else
        if(posedge_SCLK && ~en)
            counter <= counter - 1;

endmodule
