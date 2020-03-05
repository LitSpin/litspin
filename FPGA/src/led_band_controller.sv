`default_nettype none

module led_band_controller 
#(
    parameter NB_LED_ROWS = 32,        // Number of leds per face in led bands
    parameter NB_ANGLES = 128,         // Number of displayed angular positions
                                       //  (must be a power of 2)
    parameter PCB_ANGLE = 0,           // Angle of the PCB on the plate
    parameter COLOR_DATA_WIDTH = 8,    // Number of bits per color in memory
    parameter NB_ADDED_LSB_BITS = 1,   // Number of supplementary bits
                                       //  sent to the driver with value 0
    parameter COLOR_W_DATA_WIDTH = 128 // Width of the color avalon slave write data
)
(
    rst,
    clk,

    SCLK,
    LAT,
    angle,
    led_row,
    color,
    bit_sel,

    color_w_addr,
    color_w_data,
    color_w_enable,

    SOUT,
    new_frame,

    hps_override,
    hps_SOUT,

    fc_w_addr,
    fc_w_data,
    fc_w_enable
);

input wire rst, clk;

// Signals from the synchronizer
localparam ANGLE_WIDTH   = $clog2(NB_ANGLES);
localparam LED_ROW_WIDTH = $clog2(NB_LED_ROWS);
localparam BIT_SEL_WIDTH = $clog2(COLOR_DATA_WIDTH + NB_ADDED_LSB_BITS);
input wire SCLK, LAT;
input wire [ANGLE_WIDTH - 1:0] angle;
input wire [LED_ROW_WIDTH - 1:0] led_row;
input wire [1:0] color;
input wire [BIT_SEL_WIDTH - 1:0] bit_sel;

// Signals from the HPS
input wire new_frame;
input wire hps_override, hps_SOUT;

// FC avalon slave
input wire fc_w_addr;
input wire [47:0] fc_w_data;
input wire fc_w_enable;

// color avalon slave
localparam COLOR_W_ADDR_NB = 3*COLOR_DATA_WIDTH*NB_LED_ROWS*NB_ANGLES/COLOR_W_DATA_WIDTH;
localparam COLOR_W_ADDR_WIDTH = $clog2(COLOR_W_ADDR_NB);
input wire [COLOR_W_ADDR_WIDTH-1:0] color_w_addr;
input wire [COLOR_W_DATA_WIDTH-1:0] color_w_data;
input wire color_w_enable;

// Output data to the driver
output logic SOUT;


// Output multiplexing. Selects the SOUT that needs to be output (hps, FC or GS)
wire gs_enable;
wire SOUT_GS, SOUT_FC;
always_comb
begin
    if(hps_override)
        SOUT <= hps_SOUT;
    else if(~gs_enable)
        SOUT <= SOUT_FC;
    else
        SOUT <= SOUT_GS;
end


// Buffer selection.
// Keeps track of the writing buffer (MSB to buffer_choice)
// and reading buffer (MSB to ~buffer_choice)
logic buffer_choice;
always @(posedge clk)
    if(rst)
        buffer_choice <= 0;
    else
        if (new_frame)
            buffer_choice <= ~buffer_choice;


// Memory avalon master
// Communicates with the on-chip ram module containing
// the buffers.
localparam MEM_W_ADDR_WIDTH = COLOR_W_ADDR_WIDTH + 1;
localparam MEM_W_DATA_WIDTH = COLOR_W_DATA_WIDTH;
localparam MEM_R_DATA_WIDTH = COLOR_DATA_WIDTH;
localparam MEM_R_ADDR_NB    = 2*3*NB_LED_ROWS*NB_ANGLES;
localparam MEM_R_ADDR_WIDTH = $clog2(MEM_R_ADDR_NB);
wire [MEM_W_ADDR_WIDTH-1:0] mem_w_addr = {buffer_choice, color_w_addr};
wire [MEM_W_DATA_WIDTH-1:0] mem_w_data = color_w_data;
wire mem_w_enable = color_w_enable;
wire [MEM_R_ADDR_WIDTH-1:0] mem_r_addr;
assign mem_r_addr[MEM_R_ADDR_WIDTH-1] = ~buffer_choice;
wire [MEM_R_DATA_WIDTH-1:0] mem_r_data;
wire mem_r_enable = gs_enable;

// Computes the LSB of the address on which data must be read
led_band_address_computer 
#(
    .PCB_ANGLE(PCB_ANGLE),
    .ADDR_WIDTH(MEM_R_ADDR_WIDTH-1),
    .LED_ROW_WIDTH(LED_ROW_WIDTH),
    .NB_ANGLES(NB_ANGLES)
)   
address_computer
(
    .led_row(led_row),
    .angle(angle),
    .color(color),
    .r_addr(mem_r_addr[MEM_R_ADDR_WIDTH - 2:0])
);

// Dual channel on-chip ram module
led_band_memory
#(
    .W_ADDR_WIDTH(MEM_W_ADDR_WIDTH),
    .W_DATA_WIDTH(MEM_W_DATA_WIDTH),
    .R_ADDR_WIDTH(MEM_R_ADDR_WIDTH),
    .R_DATA_WIDTH(MEM_R_DATA_WIDTH)
)
memory
(
    .clk(clk),

    .r_enable(mem_r_enable),
    .r_addr(mem_r_addr),
    .r_data(mem_r_data),

    .w_data(mem_w_data),
    .w_addr(mem_w_addr),
    .w_enable(mem_w_enable)
);

// Contains the FC register data and outputs it when
// WRTFCEN is detected on the LAT signal
led_band_FC_setter FC_setter
(
    .rst(rst),
    .clk(clk),
    .SCLK(SCLK),
    .en(gs_enable),
    .SOUT(SOUT_FC),
    .LAT(LAT),
    .w_addr(fc_w_addr),
    .w_data(fc_w_data),
    .w_enable(fc_w_enable)
);


led_band_GS_controller
#(
    .COLOR_DATA_WIDTH(COLOR_DATA_WIDTH),
    .NB_ADDED_LSB_BITS(NB_ADDED_LSB_BITS)
)
GS_controller
(
    .bit_sel(bit_sel),
    .r_data(mem_r_data),
    .SOUT(SOUT_GS)
);

endmodule
