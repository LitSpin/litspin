`default_nettype none

module led_band_FC_setter#(
                            parameter [47:0] default_FC = 48'h5c0201008048
                          )
                          (   rst,
                              clk,
                              SCLK,
                              en,
                              SOUT,
                              LAT,

                              hps_fc_addr,
                              hps_fc_data,
                              hps_fc_write
                          );

input wire  rst;
input wire  clk;
input wire  SCLK;
output wire SOUT;
input wire  LAT;
input wire  hps_fc_addr, hps_fc_write;
input wire  [47:0] hps_fc_data;

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

 logic [47:0] FC;


always_ff@(posedge clk)
    if(hps_fc_write)
        FC <= hps_fc_data;


logic prev_SCLK;
wire posedge_SCLK = SCLK & ~prev_SCLK;
wire negedge_SCLK = ~SCLK & prev_SCLK;
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


// en is high while the FC setter is writing
output logic en;
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
// It is updated on SCLK negedge to present new data on SCLK posedge
logic [5:0] counter;
assign SOUT = FC[counter];
always_ff@(posedge clk)
    if(rst)
        counter <= 6'h2f;
    else
        if(negedge_SCLK && ~en)
            counter <= counter - 1;


endmodule
