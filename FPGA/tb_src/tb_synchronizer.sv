module tb_synchronizer ();

localparam SCLK_FACTOR = 4;
localparam GCLK_FACTOR = 2;
localparam ANGLE_COUNTER_WIDTH = 128;
localparam NB_ANGLES = 128;
localparam NB_LEDS_PER_GROUP = 16;
localparam NB_LED_ROWS = 32;

logic clk;
logic rst;
logic turn_tick;
logic force_fc;
logic hps_override;
logic hps_SCLK;
logic hps_LAT;
wire GCLK;
wire SCLK;
wire LAT;
wire [3:0] row_en;
localparam LED_ROW_WIDTH = $clog2(NB_LED_ROWS);
wire [LED_ROW_WIDTH - 1 : 0] led_row;
wire [1:0] color;
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
    .row_en(row_en),
    .led_row(led_row),
    .color(color),
    .bit_sel(bit_sel),
    .hps_override(hps_override),
    .hps_SCLK(hps_SCLK),
    .hps_LAT(hps_LAT)
);

initial begin: TESTBENCH

    hps_override = 0;
    hps_SCLK = 0;
    hps_LAT = 0;
    turn_tick = 0;
    force_fc = 0;
    clk = 0;
    rst = 1;
    @(posedge clk)
    rst = 0;

end

endmodule
