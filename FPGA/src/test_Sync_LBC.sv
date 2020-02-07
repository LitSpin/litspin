`default_nettype none

module test_Sync_LBC(
    input wire clk,
    input wire n_rst,

    output wire SCLK,
    output wire GCLK,
    output wire LAT,
    output wire SOUT,
    output wire turn_tick,
    output wire [3:0] row_en
);

logic hps_override_sync,
      hps_SCLK,
      hps_LAT,
      force_fc,
      hps_override_lbc,
      hps_SOUT;

logic [47:0] hps_fc_data = 0;


wire [6:0] angle;
wire [1:0] color;
wire [3:0] bit_sel;
wire [4:0] led_row;

wire new_frame;

logic [9:0] w_addr;
logic [127:0] w_data;
logic write;

wire rst = ~n_rst;

wire hps_fc_write, hps_fc_addr;

assign hps_fc_write = 0;
assign hps_fc_addr = 0;
assign hps_override_sync =0;
assign hps_SCLK =0;
assign hps_LAT =0;
assign force_fc =0;
assign hps_override_lbc =0;
assign hps_SOUT =0;

synchronizer sync(
    .clk(clk),
    .rst(rst),
    .turn_tick(turn_tick),
    .force_fc(force_fc),
    .GCLK(GCLK),
    .SCLK(SCLK),
    .LAT(LAT),
    .row_en(row_en),
    .led_row(led_row),
    .color(color),
    .bit_sel(bit_sel),
    .angle(angle),

    .hps_override(hps_override_sync),
    .hps_SCLK(hps_SCLK),
    .hps_LAT(hps_LAT)

);

led_band_controller lbc(
    .rst(rst),
    .clk(clk),

    .SCLK(SCLK),
    .LAT(LAT),
    .angle(angle),
    .row(led_row),
    .color(color),
    .bit_sel(bit_sel),

    .w_addr_input(w_addr),
    .w_data(w_data),
    .write(write),

    .SOUT(SOUT),
    .new_frame(new_frame),

    .hps_override(hps_override_lbc),
    .hps_SOUT(hps_SOUT),
    .hps_fc_write(hps_fc_write),
    .hps_fc_data(hps_fc_data),
    .hps_fc_addr(hps_fc_addr)
    
);

localparam TURN_PERIOD = 2500000;

logic [$clog2(TURN_PERIOD)-1:0] compteur_turn;

always_ff@(posedge clk)
    if(rst)
        compteur_turn <= 0;
    else
        if(compteur_turn == TURN_PERIOD)
            compteur_turn <= 0;
        else
            compteur_turn <= compteur_turn + 1;

assign turn_tick = (compteur_turn == 0) ? 1 : 0;
assign new_frame = turn_tick;

logic [9:0] compteur_data;


always_ff@(posedge clk)
    if (rst | new_frame)
    begin
        compteur_data <= 0;
        write <= 1;
    end
    else 
        if(compteur_data == 768)
        begin
            compteur_data <= 0;
            write <= 0;
        end
        else if (write)
            compteur_data <= compteur_data + 1;


always_ff@(posedge clk)
    if (write)
    begin
        w_addr <= compteur_data;
        w_data <= compteur_data;
    end
            


endmodule