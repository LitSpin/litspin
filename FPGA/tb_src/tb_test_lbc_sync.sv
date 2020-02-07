`default_nettype none

module tb_test_lbc_sync;

logic CLOCK_50;
logic [3:0] KEY;
wire  [35:0] OutGPIO;

always #10ns CLOCK_50 = ~CLOCK_50;

initial begin: TESTBENCH
    CLOCK_50 = 0;
    KEY = 4'b0011;
    @(posedge CLOCK_50);

    KEY[1] = 0;

    repeat(3)
    begin
        @(posedge CLOCK_50);
    end

    KEY[1] = 1;
    KEY[0] = 0;

    repeat(3)
    begin
        @(posedge CLOCK_50);
    end

    KEY[0] = 1;

end

Test_LBC_Sync tls(
    .CLOCK_50(CLOCK_50),
    .KEY(KEY),
    .OutGPIO(OutGPIO)
);

endmodule