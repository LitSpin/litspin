module tb_GS_state_machine ();

parameter NB_ANGLES = 128;
parameter NB_LEDS_PER_GROUP = 16; //number of leds per multiplexing group.
                                  //must be a power of 2.

logic clk;
logic rst;
logic SCLK;
localparam ANGLE_WIDTH = $clog2(NB_ANGLES);
logic [ANGLE_WIDTH - 1 : 0] angle;
wire  [3:0] row_en;
localparam LED_WIDTH = $clog2(NB_LEDS_PER_GROUP);
wire  [LED_WIDTH - 1 : 0] led;
wire [1:0] color;
wire  [3:0] bit_sel;
wire  LAT;

GS_state_machine
#(
    .NB_ANGLES(NB_ANGLES),
    .NB_LEDS_PER_GROUP(NB_LEDS_PER_GROUP)
)
state_machine
(
    .clk(clk),
    .rst(rst),
    .SCLK(SCLK),
    .angle(angle),
    .row_en(row_en),
    .led(led),
    .color(color),
    .bit_sel(bit_sel),
    .LAT(LAT)
);


always #10ns
    clk = ~clk;

always #100ns
    SCLK = ~SCLK;

initial begin: TESTBENCH
    clk = 0;
    SCLK = 0;
    rst = 1;
    angle = 0;

    @(posedge clk)
    rst = 0;

    @(posedge clk)
    angle = 1;

end

endmodule
