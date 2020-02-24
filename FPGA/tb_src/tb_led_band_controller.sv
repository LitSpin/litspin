`default_nettype none

module tb_led_band_controller;

logic clk, rst;
logic [15:0][7:0] data [0:1535];

logic [127:0] w_data;
wire [47:0] FC = $random;
logic [9:0] w_addr;
logic write;

logic hps_override;
logic hps_SOUT;
logic hps_fc_write;
logic hps_fc_addr;
logic [47:0] hps_fc_data;

logic [4:0] row;
logic [6:0] angle;
logic [1:0] color;
logic [3:0] bits;

logic SCLK;
logic LAT;
logic new_frame;

wire SOUT;

led_band_controller lbc(

    .rst(rst),
    .clk(clk),

    .SCLK(SCLK),
    .LAT(LAT),
    .angle(angle),
    .row(row),
    .color(color),
    .bit_sel(bits),

    .w_addr_input(w_addr),
    .w_data(w_data),
    .write(write),

    .SOUT(SOUT),
    .new_frame(new_frame),

    .hps_override(hps_override),
    .hps_SOUT(hps_SOUT),
    .hps_fc_write(hps_fc_write),
    .hps_fc_data(hps_fc_data),
    .hps_fc_addr(hps_fc_addr)


);

always #10ns clk = ~clk;


logic success = 1;

logic [1:0] colors_rand [0:999];
logic [3:0] bits_rand   [0:999];
logic [6:0] angle_rand  [0:999];
logic [4:0] row_rand    [0:999];

logic [31:0] hps_sout_data;


wire [13:0] r_addr = color + 3*angle + 3*128*row;

int i;

initial begin: TESTBENCH

    for (i = 0; i<1536; i++) begin
        data[i] = $urandom_range((2**128)-1,0);
    end

    rst = 1;
    clk = 0;
    write = 0;
    hps_override = 0;
    hps_SOUT = 0;
    hps_fc_data = 0;
    hps_fc_addr = 0;
    hps_fc_write = 0;
    row = 0;
    angle = 0;
    color = 0;
    bits = 0;

    SCLK = 0;
    LAT = 0;
    new_frame = 0;

    w_data = 0;
    w_addr = 0;

    hps_sout_data = 0;


    repeat(5) begin
        @(posedge clk);
    end

    rst = 0;

    //Test FC setting from HPS

    hps_fc_write = 1;
    hps_fc_data = FC;
    @(posedge clk);
    @(negedge clk);
    hps_fc_write = 0;


    assert (FC==lbc.f0.FC) $display("FC written from HPS passed");
    else   $error("FC writing test failed.\nexpected: %h\nvalue  : %h", FC, lbc.f0.FC);
    
    //Test writing alone

    write = 1;
    for (i = 0; i<768; i++)
    begin
        w_data=data[i];
        w_addr = i;
        @(posedge clk);
    end

    new_frame = 1;
    @(posedge clk);
    new_frame = 0;
    
    for (i = 0; i<768; i++)
    begin
        w_data=data[i+768];
        w_addr = i;
        @(posedge clk);
    end

    @(posedge clk);

    write = 0;


    for (i=0; i<768; i++)begin
        assert (data[i]==lbc.m0.mem[i])
        else   begin $error("Data writing test failed for index %d.\nexpected: %h\nvalue  : %h", i, data[i], lbc.m0.mem[i]); success = 0; end
        assert (data[i+768]==lbc.m0.mem[i+1024])
        else begin   $error("Data writing test failed for index %d.\nexpected: %h\nvalue  : %h", i, data[i], lbc.m0.mem[i]); success = 0; end
    end

    if (success)
    begin
        $display("Only written succesfully passed");
    end

    @(posedge clk);

    //Test reading alone

    for (i=0; i<1000; i++)
    begin
        colors_rand[i] = $urandom_range(2,0);
        angle_rand[i]  = $random;
        row_rand[i]    = $random;
        bits_rand[i]   = $urandom_range(8,0);
    end

    @(negedge clk);
    success = 1;

    //Read buffer is 0 because write buffer is 1
    for (i = 0; i<1000; i++) begin
        color = colors_rand[i];
        angle = angle_rand[i];
        row   = row_rand[i];
        bits  = bits_rand[i];

        @(posedge clk);
        @(negedge clk);

        assert ((bits==0 & SOUT == 0) | (SOUT == data[r_addr/16][r_addr%16][bits-1])) 
        else   begin 
                success = 0;
                if (bits == 0)
                    $error("Data reading test failed with index: %d, row: %d, angle: %d, color: %d and bit: %d.\nexpected: %h\nvalue  : %h", i, row, angle, color, bits, 0, SOUT);
                else
                    $error("Data reading test failed with index: %d, row: %d, angle: %d, color: %d and bit: %d.\nexpected: %h\nvalue  : %h", i, row, angle, color, bits, data[r_addr/16][r_addr%16][bits[2:0]], SOUT);
                end

    end

    // Reset buffer_choice value
    new_frame = 1;
    @(posedge clk);
    new_frame = 0;

    //Read buffer is 1 because write buffer is 0
    for (i = 0; i<1000; i++) begin
        color = colors_rand[i];
        angle = angle_rand[i];
        row   = row_rand[i];
        bits  = bits_rand[i];

        @(posedge clk);
        @(negedge clk);

        assert ((bits==0 & SOUT == 0) | (SOUT == data[768+r_addr/16][r_addr%16][bits-1])) 
        else   begin 
                success = 0;
                if (bits == 0)
                    $error("Data reading test failed with index: %d, row: %d, angle: %d, color: %d and bit: %d.\nexpected: %h\nvalue  : %h", i, row, angle, color, bits, 0, SOUT);
                else
                    $error("Data reading test failed with index: %d, row: %d, angle: %d, color: %d and bit: %d.\nexpected: %h\nvalue  : %h", i, row, angle, color, bits, data[768+r_addr/16][r_addr%16][bits[2:0]], SOUT);
                end

    end

    if (success)
    begin
        $display("Only reading succesfully passed");
    end


    //Test write and read together

    success = 1;



    for (i = 0; i<1536; i++) begin
        data[i] = $urandom_range((2**128)-1,0);
    end

    for (i=0; i<768; i++)
    begin
        colors_rand[i] = $urandom_range(2,0);
        angle_rand[i]  = $random;
        row_rand[i]    = $random;
        bits_rand[i]   = $urandom_range(8,0);
    end

    @(posedge clk);

    write = 1;
    for (i = 0; i<768; i++)
    begin
        w_data=data[i];
        w_addr = i;
        @(posedge clk);
        @(negedge clk);
        assert (data[i]==lbc.m0.mem[i])
            else   begin $error("Data writing test failed for index %d.\nexpected: %h\nvalue  : %h", i, data[i], lbc.m0.mem[i]); success = 0; end
    end

    //Set buffer_choice to 1: buffer_written = 1, buffer_read = 0
    new_frame = 1;
    @(posedge clk);
    new_frame = 0;

    
    for (i = 0; i<768; i++)
        begin
            w_data=data[i+768];
            w_addr = i;

            color = colors_rand[i];
            angle = angle_rand[i];
            row   = row_rand[i];
            bits  = bits_rand[i];

            @(posedge clk);
            @(negedge clk);

            assert (data[i]==lbc.m0.mem[i])
            else   begin $error("Data writing test failed for index %d.\nexpected: %h\nvalue  : %h", i, data[i], lbc.m0.mem[i]); success = 0; end

            assert ((bits==0 & SOUT == 0) | (SOUT == data[r_addr/16][r_addr%16][bits-1])) 
            else   begin 
                    success = 0;
                    if (bits == 0)
                        $error("Data reading test failed with index: %d, row: %d, angle: %d, color: %d and bit: %d.\nexpected: %h\nvalue  : %h", i, row, angle, color, bits, 0, SOUT);
                    else
                        $error("Data reading test failed with index: %d, row: %d, angle: %d, color: %d and bit: %d.\nexpected: %h\nvalue  : %h", i, row, angle, color, bits, data[r_addr/16][r_addr%16][bits-1], SOUT);
                    end

        end


    @(posedge clk);

    write = 0;

    //Set buffer_choice to 0: buffer_written = 0, buffer_read = 1
    new_frame = 1;
    @(posedge clk);
    new_frame = 0;


    for (i = 0; i<768; i++)
        begin
            color = colors_rand[i];
            angle = angle_rand[i];
            row   = row_rand[i];
            bits  = bits_rand[i];

            @(posedge clk);
            @(negedge clk);

        
            assert ((bits==0 & SOUT == 0) | (SOUT == data[768+r_addr/16][r_addr%16][bits-1])) 
            else   begin 
                    success = 0;
                    if (bits == 0)
                        $error("Data reading test failed with index: %d, row: %d, angle: %d, color: %d and bit: %d.\nexpected: %h\nvalue  : %h", i, row, angle, color, bits, 0, SOUT);
                    else
                        $error("Data reading test failed with index: %d, row: %d, angle: %d, color: %d and bit: %d.\nexpected: %h\nvalue  : %h", i, row, angle, color, bits, data[768+r_addr/16][r_addr%16][bits-1], SOUT);
                    end

        end


    if (success)
    begin
        $display("Writing and reading succesfully passed");
    end

    //Test HPS SOUT
    @(posedge clk);

    hps_override = 1;

    hps_sout_data = $random;
    @(posedge clk);

    success = 1;

    for (i=0; i<32; i++) begin
        hps_SOUT = hps_sout_data[31-i];
        @(posedge clk);
        assert (SOUT == hps_SOUT) 
        else  begin $error("HPS SOUT writing test failed.\nexpected: %b\nvalue  : %b", hps_SOUT, SOUT); success = 0; end
    end

    if (success)
    begin
        $display("HPS SOUT succesfully passed");
    end


    $display("All tests have been executed");

end

endmodule