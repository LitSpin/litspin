module tb_FC_state_machine ();

logic clk;
logic rst;
logic SCLK;
logic force_fc;
wire LAT;
wire en;

FC_state_machine state_machine
(
    .clk(clk),
    .rst(rst),
    .SCLK(SCLK),
    .force_fc(force_fc),
    .LAT(LAT),
    .en(en)
);

always #10ns
    clk = ~clk;

always #100ns
    SCLK = ~SCLK;

initial begin: TESTBENCH
    clk = 0;
    SCLK = 0;
    force_fc = 0;
    rst = 1;

    
    @(posedge SCLK);
    rst = 0;
    assert(en == 1)
    else $error("Error : invalid en value");
    assert(LAT == 0)
    else $error("Error : invalid LAT value");

    repeat(15)
    begin
        @(posedge SCLK);
        assert(en == 1)
        else $error("Error : invalid en value");
        assert(LAT == 1)
        else $error("Error : invalid LAT value");
    end

    repeat(48 - 5)
    begin
        @(posedge SCLK);
        assert(en == 1)
        else $error("Error : invalid en value");
        assert(LAT == 0)
        else $error("Error : invalid LAT value");
    end

    repeat(5)
    begin
        @(posedge SCLK);
        assert(en == 1)
        else $error("Error : invalid en value");
        assert(LAT == 1)
        else $error("Error : invalid LAT value");
    end

    @(posedge SCLK);
    assert(en == 1)
    else $error("Error : invalid en value");
    assert(LAT == 0)
    else $error("Error : invalid LAT value");

    @(posedge SCLK);
    assert(en == 0)
    else $error("Error : invalid en value");
    assert(LAT == 0)
    else $error("Error : invalid LAT value");

    $display("All tests passed.");
end
endmodule
