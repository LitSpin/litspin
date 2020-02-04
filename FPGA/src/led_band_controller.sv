module led_band_controller #(
    parameter NB_LED_COLUMN = 32,
    parameter BIT_PER_COLOR = 8,
    parameter NB_0_LSB = 1,
    parameter NB_ANGLES = 128,
    parameter ANGLE_PCB = 0,

    parameter W_DATA_WIDTH = 128,

    parameter [47:0] default_FC = 48'h5c0201008048
    )
    (
        rst,
        clk,

        SCLK,
        LAT,
        angle,
        row,
        color,
        bit_sel,

        w_addr_input,
        w_data,
        w_clk,
        write,
        
        SOUT,
        new_frame,

        hps_override,
        hps_SOUT,
        hps_fc_clk,
        hps_fc_data
    );

localparam W_WORDS_NB = 2*3*BIT_PER_COLOR*NB_LED_COLUMN*NB_ANGLES/W_DATA_WIDTH;
localparam W_ADDR_WIDTH = $clog2(W_WORDS_NB);

localparam R_DATA_WIDTH = BIT_PER_COLOR;
localparam R_WORDS_NB = 2*3*NB_LED_COLUMN*NB_ANGLES;
localparam R_ADDR_WIDTH = $clog2(R_WORDS_NB);

localparam ANGLE_WIDTH =   $clog2(NB_ANGLES);
localparam ROW_WIDTH =     $clog2(NB_LED_COLUMN);
localparam BIT_SEL_WIDTH = $clog2(BIT_PER_COLOR + NB_0_LSB);

input rst, clk;

input SCLK, LAT;
input [ANGLE_WIDTH - 1:0] angle;
input [ROW_WIDTH - 1:0] row;
input [1:0] color;
input [BIT_SEL_WIDTH - 1:0] bit_sel;

input [W_ADDR_WIDTH-2:0] w_addr_input;
input [W_DATA_WIDTH-1:0] w_data;
input w_clk, write;

output SOUT;
input new_frame;

input hps_override, hps_SOUT, hps_fc_clk, hps_fc_data;

wire [R_DATA_WIDTH-1 : 0] r_data;
wire r_clk;
wire SOUT_GS, SOUT_FC;

wire  [W_ADDR_WIDTH-1:0] w_addr;
wire  [R_ADDR_WIDTH-1:0] r_addr;
wire  read;

/*
 * This signal is used to block data sending while
 * the LED driver is not configured
*/ 
wire en;
assign SOUT = (en) ? ((hps_override) ? hps_SOUT : SOUT_GS) : SOUT_FC;


/*
 * This signal is used to choose the good buffer
*/ 
logic buffer_choice;
always @(posedge clk)
    if(rst)
        buffer_choice <= 0;
    else
        if (new_frame)
            buffer_choice <= ~buffer_choice;

assign w_addr[W_ADDR_WIDTH-2:0] = w_addr_input;
assign w_addr[W_ADDR_WIDTH-1]   = buffer_choice;
assign r_addr[R_ADDR_WIDTH-1]   = ~buffer_choice;


assign r_clk = clk;
assign read = en;

led_band_GS_controller#(
    .BIT_PER_COLOR(BIT_PER_COLOR)
    )
    GS_c
    (
    .bit_sel(bit_sel),
    .r_data(r_data),
    .SOUT(SOUT_GS)
    );


led_band_memory#(
    .W_ADDR_WIDTH(W_ADDR_WIDTH),
    .W_DATA_WIDTH(W_DATA_WIDTH),
    .R_ADDR_WIDTH(R_ADDR_WIDTH),
    .R_DATA_WIDTH(R_DATA_WIDTH)
    )
    m0
    (
    .r_clk(r_clk),
    .read(read),
    .r_addr(r_addr),
    .r_data(r_data),

    .w_addr(w_addr),
    .w_data(w_data),
    .w_clk(w_clk),
    .write(write)
);

led_band_FC_setter#
(
    .default_FC(default_FC)
) f0(
    .rst(rst),
    .clk(clk),
    .SCLK(SCLK),
    .en(en),
    .SOUT(SOUT_FC),
    .LAT(LAT),
    .spi_clk(hps_fc_clk),
    .spi_data(hps_fc_data)
);

address_computer #(
    .PCB_ANGLE(ANGLE_PCB),
    .ADDR_WIDTH(R_ADDR_WIDTH-1),
    .ROW_WIDTH(ROW_WIDTH),
    .NB_ANGLES(NB_ANGLES)

)   addr_comput(
    .row(row),
    .angle(angle),
    .color(color),
    .r_addr(r_addr[R_ADDR_WIDTH - 2:0])
);

endmodule