module tb_clk_divider ();

localparam FACTOR = 10; //must be even

logic clk;
logic rst;
logic o_clk;

clk_divider
#(
    .FACTOR(FACTOR)
)
clkdiv
(
    .clk(clk),
    .rst(rst),
    .o_clk(o_clk)
);

always #10ns
    clk = ~clk;

initial begin: TESTBENCH
    
    clk = 0;

    rst = 1;
    @(posedge clk)
    rst = 0;

    for(int i = 0; i < FACTOR / 2; i++)
    begin
         @(posedge clk)
         assert(~o_clk)
         else $error("Incorrect output clock value");
    end

    for(int i = 0; i < FACTOR / 2; i++)
    begin
         @(posedge clk)
         assert(o_clk)
         else $error("Incorrect output clock value");
    end

    $display("All tests passed");

end

endmodule
