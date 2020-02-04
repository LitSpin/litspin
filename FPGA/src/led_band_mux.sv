module led_band_mux#(
                    parameter CURRENT_LED_WIDTH = 4,
                    parameter MULT_NUMBER = 4,
                    parameter R_ADDR_WIDTH = 14
                  )
                  (
                    current_led,
                    mult,
                    color,
                    angle,
                    r_addr
                  );

input [CURRENT_LED_WIDTH-1:0] current_led;
input [MULT_NUMBER-1 : 0] mult;
input [1:0] color;
input [5:0] angle;

output [R_ADDR_WIDTH-1 : 0] r_addr;

logic [15:0][1:0] tmp_mult = {2'h0,2'h0,2'h1,2'h0,2'h2,2'h0,2'h0,2'h0,2'h3,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0,2'h0};

assign r_addr = 3*32*angle +3*16*({{(R_ADDR_WIDTH-2){1'b0}},tmp_mult[mult]}%2) +3*current_led +{{(R_ADDR_WIDTH-2){1'b0}},color};



endmodule
