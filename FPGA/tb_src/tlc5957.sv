/*
 * This module is designed to simulate a
 * TLC5957 used in poker mode.
 * It does not include all functionnalities and
 * the function register is not asserted to be correct.
 */ 

module tlc5957(rst        ,
               SCLK       ,
               SIN        ,
               SOUT       ,
               LAT         );

input  rst        ; // Not an actual input on the chip.
                    // Simulates a powering on.
input  SCLK       ;
input  SIN        ;
output SOUT       ;
input  LAT        ;

// Common shift register
logic [47:0] shift_reg;
wire  [ 15:0 ][ 2:0 ]  shift_reg_poker = shift_reg;
/*    [output][B/G/R] */

assign SOUT = shift_reg[47];
always_ff@(posedge SCLK)
    if(rst)
        shift_reg = '0;
    else
    begin
        shift_reg[47:1] <= shift_reg[46:0];
        shift_reg[0] <= SIN;
    end

// Counts the number of SCLK rising edge while lat is high
logic [3:0] lat_high_sclk_counter;
always_ff@(posedge SCLK)
    if(rst)
        lat_high_sclk_counter <= 0;
    else
        if(LAT)
            lat_high_sclk_counter <= lat_high_sclk_counter + 1;
        else
            lat_high_sclk_counter <= 0;

// Function Control register
logic [1:0] LODVTH    ;       
logic [1:0] SEL_TD0   ;       
logic SEL_GDLY        ; 
logic XREFRESH        ; 
logic SEL_GCK_EDGE    ; 
logic SEL_PCHG        ; 
logic ESPWM           ; 
logic LGSE3           ; 
logic SEL_SCK_EDGE    ; 
logic [2:0] LGSE1     ; 
logic [8:0] CCB       ; 
logic [8:0] CCG       ; 
logic [8:0] CCR       ; 
logic [2:0] BC        ; 
logic POKER_TRANS_MODE; 
logic [2:0] LGSE2     ;       
let FC_data_latch = {LODVTH,
                     SEL_TD0,
                     SEL_GDLY,
                     XREFRESH,
                     SEL_GCK_EDGE,
                     SEL_PCHG,
                     ESPWM,
                     LGSE3,
                     SEL_SCK_EDGE,
                     LGSE1,
                     CCB,
                     CCG,
                     CCR,
                     BC,
                     POKER_TRANS_MODE,
                     LGSE2};

wire [47:0] FC_data_latch_wire;
assign FC_data_latch_wire = FC_data_latch;

// Function Control writing
wire WRTFC   = ~LAT & (lat_high_sclk_counter == 4'd5);
wire FCWRTEN = ~LAT & (lat_high_sclk_counter == 4'd15);

logic fc_write_enabled;
always_ff@(posedge SCLK)
    if(rst)
    begin
        fc_write_enabled <= 0;
        LODVTH           <= 2'b01;
        SEL_TD0          <= 2'b01;
        SEL_GDLY         <= 1'b1;
        XREFRESH         <= 1'b0;
        SEL_GCK_EDGE     <= 1'b0;
        SEL_PCHG         <= 1'b0;
        ESPWM            <= 1'b0;
        LGSE3            <= 1'b0;
        SEL_SCK_EDGE     <= 1'b0;
        LGSE1            <= 3'b000;
        CCB              <= 9'b100000000;
        CCG              <= 9'b100000000;
        CCR              <= 9'b100000000;
        BC               <= 3'b100;
        POKER_TRANS_MODE <= 1'b0;
        LGSE2            <= 3'b000;
    end
    else
    begin
        if(FCWRTEN)
            fc_write_enabled <= 1;
        if(fc_write_enabled && WRTFC)
        begin
            FC_data_latch <= shift_reg;
            fc_write_enabled <= 0;
        end
    end

 
// greyscale data latch
logic [ 15:0 ][ 2:0 ][15:0] GS_data_latch [0:1];
/*    [output][R/G/B][bit ] */

// GreyScale data latch writing
wire WRTGS = ~LAT & (lat_high_sclk_counter == 4'd1);
wire LATGS = ~LAT & (lat_high_sclk_counter == 4'd3);
wire LINERESET = ~LAT & (lat_high_sclk_counter == 4'd7);

logic [3:0] bit_counter;
logic [3:0] bit_length;


always_ff@(posedge SCLK)
    if(rst)
    begin
        bit_counter <= 4'd15;
        bit_length  <= '0;
    end
    else
    begin
        if(WRTGS | LATGS | LINERESET)
        begin
            for(int led = 0; led < 16; led ++)
                for(int color = 0; color < 3; color ++)
                    GS_data_latch[0][led][color][bit_counter] <= shift_reg_poker[led][color];
            bit_counter <= bit_counter - 1;
        end
        if(LATGS)
        begin
            bit_length  <= 4'd15 - bit_counter;
            bit_counter <= 4'd15;
        end
    end

// Second GS buffer and output

logic refresh;

always_ff@(posedge SCLK)
    if(rst)
        refresh <= 1'b0;
    else
    begin
        if(LATGS && XREFRESH)
            refresh <= 1;
        if(refresh)
        begin
            GS_data_latch[1] = GS_data_latch[0];
            $display("Led output\n");
            for(integer led = 0; led < 15; led ++)
            begin
                $display("LED %d : ", led);
                for(integer color = 0; color < 3; color ++)
                    $display(" %h ", GS_data_latch[1][led][color][15:7]);
            end
            refresh <= 0;
        end
    end

endmodule
