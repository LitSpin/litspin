module tb_tlc5957;

    logic rst;
    logic SCLK;
    logic SIN;
    wire  SOUT;
    logic LAT;

    tlc5957 driver(.rst(rst),
                   .SCLK(SCLK),
                   .SIN(SIN),
                   .SOUT(SOUT),
                   .LAT(LAT));

always #10ns SCLK = ~SCLK;
 
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
let FC = {LODVTH,
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

logic [ 15:0 ][ 2:0 ][8:0] DATA;
/*    [output][R/G/B][bit]*/ 

initial begin: TESTBENCH

    SCLK = 1'b0;

    LODVTH           = 2'b01;
    SEL_TD0          = 2'b01;
    SEL_GDLY         = 1'b1;
    XREFRESH         = 1'b1;
    SEL_GCK_EDGE     = 1'b0;
    SEL_PCHG         = 1'b0;
    ESPWM            = 1'b0;
    LGSE3            = 1'b0;
    SEL_SCK_EDGE     = 1'b0;
    LGSE1            = 3'b000;
    CCB              = 9'b100000000;
    CCG              = 9'b100000000;
    CCR              = 9'b100000000;
    BC               = 3'b100;
    POKER_TRANS_MODE = 1'b1;
    LGSE2            = 3'b000;
  
    DATA = {{9'h001, 9'h002, 9'h003},
            {9'h011, 9'h012, 9'h013},
            {9'h021, 9'h022, 9'h023},
            {9'h031, 9'h032, 9'h033},
            {9'h041, 9'h042, 9'h043},
            {9'h051, 9'h052, 9'h053},
            {9'h061, 9'h062, 9'h063},
            {9'h071, 9'h072, 9'h073},
            {9'h081, 9'h082, 9'h083},
            {9'h091, 9'h092, 9'h093},
            {9'h101, 9'h102, 9'h103},
            {9'h111, 9'h112, 9'h113},
            {9'h121, 9'h122, 9'h123},
            {9'h131, 9'h132, 9'h133},
            {9'h141, 9'h142, 9'h143},
            {9'h151, 9'h152, 9'h153}};

    rst <= 1'b1;
    repeat(10)
    begin
        @(posedge SCLK);
    end
    rst <= 1'b0;
    repeat(10)
    begin
        @(posedge SCLK);
    end

    for(integer i = 0; i < 48; i++)
    begin
        if(i < 15 | i >= 48 - 5)
            LAT = 1;
        else
            LAT = 0;
        SIN = FC[47 - i];
        @(posedge SCLK);
    end

    LAT = 0;
    repeat(10)
    begin
        @(posedge SCLK);
    end

    assert(FC == driver.FC_data_latch_wire) $display("FC writing test passed");
    else $error("FC writing test failed.\nexpected: %h\nvalue  : %h", FC, driver.FC_data_latch_wire);

    for(integer b = 8; b >= 0; b--) // MSB first
        for(integer led = 15; led >= 0; led--) // Highest LED first
            for(integer color = 2; color >= 0; color --) // B/G/R
                begin
                    automatic integer channel = 3 * led + color;
                    if(channel < 1 | ((b == 0) & (channel < 3)))
                        LAT = 1;
                    else
                        LAT = 0;
                SIN = DATA[led][color][b];
                @(posedge SCLK);
            end

    LAT = 0;
    repeat(10)
    begin
        @(posedge SCLK);
    end


    for(integer led = 0; led < 16; led ++)
        for(integer color = 0; color < 2; color ++)
            assert(DATA[led][color] == driver.GS_data_latch[1][led][color][15:7])
            else $error("Error in written data for led %d, color %d:\nexpected: %h\nvalue   : %h", led, color, DATA[led][color], driver.GS_data_latch[1][led][color][15:7]);

    $display("All tests passed.");

end

endmodule
