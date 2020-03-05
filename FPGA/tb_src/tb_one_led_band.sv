`default_nettype none

module tb_one_led_band ();

localparam SCLK_FACTOR = 4;
localparam GCLK_FACTOR = 2;
localparam ANGLE_COUNTER_WIDTH = 128;
localparam BIT_PER_COLOR = 8;
localparam NB_ANGLES = 128;
localparam NB_LEDS_PER_GROUP = 16;
localparam NB_LED_ROWS = 32;
localparam W_DATA_WIDTH = 128;
localparam default_FC = 48'h5c0201008048;

logic clk;
logic rst;
logic turn_tick;
logic write_fc;
logic hps_override;
logic hps_SCLK;
logic hps_LAT;
logic hps_SOUT;
logic [47:0] fc_w_data;
logic fc_w_addr;
logic fc_w_enable;

localparam W_WORDS_NB = 2*3*BIT_PER_COLOR*NB_LED_ROWS*NB_ANGLES/W_DATA_WIDTH;
parameter W_ADDR_WIDTH = $clog2(W_WORDS_NB);
logic [W_ADDR_WIDTH - 2 : 0] color_w_addr;
logic [W_DATA_WIDTH - 1 : 0] color_w_data; 
logic color_w_enable;
logic new_frame;
logic hps_sout;
wire SOUT;
wire GCLK;
wire SCLK;
wire LAT;
wire [3:0] mux_en;
localparam LED_ROW_WIDTH = $clog2(NB_LED_ROWS);
wire [LED_ROW_WIDTH - 1 : 0] led_row;
wire [1:0] color;
localparam ANGLE_WIDTH = $clog2(NB_ANGLES);
wire [ANGLE_WIDTH - 1 : 0] angle; 
wire [3:0] bit_sel;

always #10ns
    clk = ~clk;

always #50ms
begin
    turn_tick = 1;
    #1ms;
    turn_tick = 0;
end

synchronizer
#(
    .SCLK_FACTOR(SCLK_FACTOR),
    .GCLK_FACTOR(GCLK_FACTOR),
    .ANGLE_COUNTER_WIDTH(ANGLE_COUNTER_WIDTH),
    .NB_ANGLES(NB_ANGLES),
    .NB_LEDS_PER_GROUP(NB_LEDS_PER_GROUP),
    .NB_LED_ROWS(NB_LED_ROWS)
)
sync
(
    .clk(clk),
    .rst(rst),
    .turn_tick(turn_tick),
    .GCLK(GCLK),
    .SCLK(SCLK),
    .LAT(LAT),
    .mux_en(mux_en),
    .led_row(led_row),
    .color(color),
    .angle(angle),
    .bit_sel(bit_sel),
    .hps_override(hps_override),
    .hps_SCLK(hps_SCLK),
    .hps_LAT(hps_LAT),
    .write_fc(write_fc)
);

led_band_controller
#(
    .NB_LED_ROWS(NB_LED_ROWS),
    .NB_ANGLES(NB_ANGLES),
    .PCB_ANGLE(0),
    .COLOR_W_DATA_WIDTH(W_DATA_WIDTH)
)
lbc
(
    .rst(rst),
    .clk(clk),
    .SCLK(SCLK),
    .LAT(LAT),
    .angle(angle),
    .led_row(led_row),
    .color(color),
    .bit_sel(bit_sel),
    .color_w_addr(color_w_addr),
    .color_w_data(color_w_data),
    .color_w_enable(color_w_enable),
    .SOUT(SOUT),
    .new_frame(new_frame),
    .hps_override(hps_override),
    .hps_SOUT(hps_sout),
    .fc_w_addr(fc_w_addr),
    .fc_w_data(fc_w_data),
    .fc_w_enable(fc_w_enable)
);

tlc5957 driver
(
    .clk(clk),
    .rst(rst),
    .SCLK(SCLK),
    .SIN(SOUT),
    .LAT(LAT)
);

logic [W_WORDS_NB - 1:0][W_DATA_WIDTH - 1:0] memory;
wire  [31:0][127:0][2:0][7:0] memory_alias = memory;

static int i;

initial begin: TESTBENCH
    turn_tick = 0;
    write_fc = 0;
    clk = 0;
    rst = 1;
    hps_override = 0;
    hps_SCLK = 0;
    hps_LAT = 0;
    hps_SOUT = 0;
    fc_w_data = default_FC;
    fc_w_addr = 0;
    fc_w_enable = 1;
    color_w_addr = 0;
    color_w_data = 0;
    color_w_enable = 0;
    new_frame = 0;
    hps_sout = 0;

    @(posedge clk);
    rst = 0;
    write_fc = 1;
    fc_w_enable = 0;

    @(posedge clk);
    write_fc = 0;

    repeat(100) @(posedge clk);

    std::randomize(memory);

    i = 0;
    repeat(W_WORDS_NB/2)
    begin
        color_w_addr = i;
        color_w_data = memory[i];
        color_w_enable = 1;
        @(posedge clk);
        color_w_enable = 0;
        @(posedge clk);
        i = i+1;
    end

    for(int w = 0; w < W_WORDS_NB/2; w++)
    begin
        assert(memory[w] == lbc.memory.mem[w])
        else $display("Memory content is incorrect");
    end

    new_frame = 1;
    @(posedge clk)
    new_frame = 0;
    
    @(posedge mux_en[0]);
    //need to wait for a while for the value to be put in the second data latch
    repeat(3)
        @(posedge SCLK);
    for(int led = 0; led < 16; led++)
        for(int c = 0; c < 3; c++)
        begin
            assert(driver.GS_data_latch[1][led][c][8:1] == 
                memory_alias[sync.multiplexing_LUT.mux_table[0][led]][angle][c])
            else $error("Bad value on driver : \n
                color %d of led %d on mux row 0, led row %d\n
                %h instead of %h", c, led, sync.multiplexing_LUT.mux_table[0][led], 
                driver.GS_data_latch[1][led][c][8:1], 
                memory_alias[sync.multiplexing_LUT.mux_table[0][led]][angle][c]);
        end

    @(posedge mux_en[1]);
    //need to wait for a while for the value to be put in the second data latch
    repeat(3)
        @(posedge SCLK);
    for(int led = 0; led < 16; led++)
        for(int c = 0; c < 3; c++)
        begin
            assert(driver.GS_data_latch[1][led][c][8:1] == 
                memory_alias[sync.multiplexing_LUT.mux_table[1][led]][angle][c])
            else $error("Bad value on driver : \n
                color %d of led %d on mux row 0, led row %d\n
                %h instead of %h", c, led, sync.multiplexing_LUT.mux_table[1][led], 
                driver.GS_data_latch[1][led][c][8:1], 
                memory_alias[sync.multiplexing_LUT.mux_table[1][led]][angle][c]);
        end

    @(posedge mux_en[2]);
    //need to wait for a while for the value to be put in the second data latch
    repeat(3)
        @(posedge SCLK);
    for(int led = 0; led < 16; led++)
        for(int c = 0; c < 3; c++)
        begin
            assert(driver.GS_data_latch[1][led][c][8:1] == 
                memory_alias[sync.multiplexing_LUT.mux_table[2][led]][angle][c])
            else $error("Bad value on driver : \n
                color %d of led %d on mux row 0, led row %d\n
                %h instead of %h", c, led, sync.multiplexing_LUT.mux_table[2][led], 
                driver.GS_data_latch[1][led][c][8:1], 
                memory_alias[sync.multiplexing_LUT.mux_table[2][led]][angle][c]);
        end


    @(posedge mux_en[3]);
    //need to wait for a while for the value to be put in the second data latch
    repeat(3)
        @(posedge SCLK);
    for(int led = 0; led < 16; led++)
        for(int c = 0; c < 3; c++)
        begin
            assert(driver.GS_data_latch[1][led][c][8:1] == 
                memory_alias[sync.multiplexing_LUT.mux_table[3][led]][angle][c])
            else $error("Bad value on driver : \n
                color %d of led %d on mux row 0, led row %d\n
                %h instead of %h", c, led, sync.multiplexing_LUT.mux_table[3][led], 
                driver.GS_data_latch[1][led][c][8:1], 
                memory_alias[sync.multiplexing_LUT.mux_table[3][led]][angle][c]);
        end

    $display("All tests done");



end

endmodule
