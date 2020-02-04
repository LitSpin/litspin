module tb_led_band_FC_setter;

logic rst;
logic clk;
logic SCLK;
wire  en;
wire  SIN;
logic spi_clk;
logic spi_data;
logic  LAT;
wire [47:0] FC = 48'hec020100804e;

led_band_FC_setter FC_setter
(
    .clk(clk),
    .rst(rst),
    .SCLK(SCLK),
    .en(en),
    .SOUT(SIN),
    .LAT(LAT),
    .spi_clk(spi_clk),
    .spi_data(spi_data)
);

tlc5957 driver(
                .rst(rst),
                .SCLK(SCLK),
                .SIN(SIN),
                .SOUT(SOUT),
                .LAT(LAT)
              );

always #1ns  clk  = ~clk;
always #10ns SCLK = ~SCLK;

initial begin: TESTBENCH

    clk = 0;
    SCLK = 0;
    rst = 1;
    spi_clk = 0;
    
    repeat(2)
    begin
        @(negedge SCLK);
    end
    rst = 0;

    for (int i = 47; i>=0; i--) begin
        spi_data = FC[i];
        @(posedge SCLK);
        spi_clk = 1;
        @(posedge SCLK);
        spi_clk = 0;
    end

    @(negedge SCLK);

    LAT = 1;
    repeat(15)
    begin
        @(negedge SCLK);
    end

    LAT = 0;

    repeat(43)
    begin
        @(negedge SCLK);
    end

    LAT = 1;
    repeat(5)
    begin
        @(negedge SCLK);
    end

    LAT = 0;

    repeat(5)
    begin
        @(negedge SCLK);
    end

    $display("%h\n",FC_setter.FC);

    assert(FC == driver.FC_data_latch_wire) $display("FC writing test passed");
    else $error("FC writing test failed.\nexpected: %h\nvalue  : %h", FC, driver.FC_data_latch_wire);


end

endmodule
