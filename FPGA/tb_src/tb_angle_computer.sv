module tb_angle_computer ();

localparam COUNTER_WIDTH = 128;
localparam NB_ANGLES     = 128; //has to be a power of 2
localparam ANGLE_WIDTH   = $clog2(NB_ANGLES);

logic clk;
logic rst;
logic turn_tick;
wire angle;

always #10ns
    clk = ~clk;

always #20ms
begin
    turn_tick = 1;
    #1ms;
    turn_tick = 0;
end

angle_computer
#(
    .COUNTER_WIDTH(COUNTER_WIDTH),
    .NB_ANGLES(NB_ANGLES)
)
angle_computer_inst
(
    .clk(clk),
    .rst(rst),
    .turn_tick(turn_tick),
    .angle(angle)
);

initial begin: TESTBENCH

clk = 0;
rst = 1;
@(posedge clk)
rst = 0;

end

endmodule
