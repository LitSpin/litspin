module FC_state_machine
(
    clk,
    rst,
    SCLK,
    force_fc,
    LAT,
    en
);

/*
 * The FC state machine generates the signals FCWRTEN and WRTFC
 * with the correct timing for the FC setters in the LED band controllers.
 *
 * It is triggered by rst or force_fc.
 *
 * While the FC setter outputs, en is high. The writing cycle lasts for 65
 * SCLK cycles.
 *
 * rst _-____________________________________ 
 * en  _------------------------------------_
 * LAT __---------------____________-------__
 *      ^<   FCWRTEN   >            <WRTFC>^
 *      |               <   48 cycles     >|
 *    One low LAT cycle at the end and beginning
 */   

input clk;
input rst;

// Posedge SCLK detector
input SCLK;
logic prev_SCLK;
wire posedge_SCLK = SCLK & ~prev_SCLK;
always@(posedge clk)
    prev_SCLK <= SCLK;

// The counter counts from 0 to 64 (relevant values)
// Increases at each posedge of SCLK
// Is reset on force_fc and rst
input force_fc;
logic [6:0] counter;
always@(posedge clk)
    if(rst)
        counter <= 0;
    else
    if(force_fc)
        counter <= 0;
    else if(posedge_SCLK)
        counter <= counter + 1;

// en is set high on reset and force_fc
//           low on 65th SCLK cycle
output logic en;
always@(posedge clk)
    if(rst)
        en <= 1;
    else
        if(force_fc)
            en <= 1;
        else if(posedge_SCLK && counter == 7'd64)
            en <= 0;

// LAT is the conjonction of WRTFC (5 cycles) and FCWRTEN (15 cycles)
output LAT;
wire LAT_FCWRTEN = (1 <= counter) & (counter <= 15);
wire LAT_WRTFC   = (59 <= counter) & (counter <= 63);
assign LAT = LAT_FCWRTEN | LAT_WRTFC;

endmodule
