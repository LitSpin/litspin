module tb_memory;

logic r_clk;
logic read;
logic [14:0] r_addr;
logic [7:0]  r_data;

logic w_clk;
logic write;
logic [10:0] w_addr;
logic [127:0]  w_data;


wire [127:0] write_data   [0:1] = {128'h7bc5511cb423da47895a04fe67194761, 128'hab59a2048344149b0a3072fcffd30873};
logic [15:0][7:0] read_data[0:1];

led_band_memory mem(
    .r_clk(r_clk),
    .read(read),
    .r_addr(r_addr),
    .r_data(r_data),

    .w_clk(w_clk),
    .write(write),
    .w_addr(w_addr),
    .w_data(w_data)
);


always #10ns w_clk = ~w_clk;
always #50ns r_clk = ~r_clk;

initial begin: TESTBENCH

    w_clk = 0;
    r_clk = 0;
    write = 0;

    @(posedge r_clk);

    w_data = write_data[0];
    w_addr = 14'h0;
    write = 1;
    @(posedge w_clk);
    w_addr = 14'h1;
    w_data = write_data[1];
    @(posedge w_clk);
    write = 0;

    @(posedge r_clk)
    read=1;

    for (int i = 0; i<32; i++) begin
        r_addr = i;
        @(posedge r_clk);
        @(posedge r_clk);
        read_data[i/16][i%16] = r_data;
    end

    read = 0;

    assert (read_data == write_data) $display("Test passed"); 
    else   $error("FC writing test failed.\nexpected: %h\nvalue  : %h", write_data, read_data);

end


endmodule