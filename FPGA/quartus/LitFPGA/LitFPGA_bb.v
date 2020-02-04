
module LitFPGA (
	clk_clk,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	reset_reset_n,
	led_band_controller_0_hps_sout,
	led_band_controller_0_hps_fc_clk,
	led_band_controller_0_hps_fc_data,
	led_band_controller_0_hps_override,
	led_band_controller_0_hps_new_frame,
	hps_io_hps_io_sdio_inst_CMD,
	hps_io_hps_io_sdio_inst_D0,
	hps_io_hps_io_sdio_inst_D1,
	hps_io_hps_io_sdio_inst_D4,
	hps_io_hps_io_sdio_inst_D5,
	hps_io_hps_io_sdio_inst_D6,
	hps_io_hps_io_sdio_inst_D7,
	hps_io_hps_io_sdio_inst_CLK,
	hps_io_hps_io_sdio_inst_D2,
	hps_io_hps_io_sdio_inst_D3,
	hps_io_hps_io_gpio_inst_GPIO49,
	hps_io_hps_io_gpio_inst_GPIO50,
	hps_io_hps_io_gpio_inst_GPIO51,
	hps_io_hps_io_gpio_inst_GPIO52);	

	input		clk_clk;
	output	[12:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[7:0]	memory_mem_dq;
	inout		memory_mem_dqs;
	inout		memory_mem_dqs_n;
	output		memory_mem_odt;
	output		memory_mem_dm;
	input		memory_oct_rzqin;
	input		reset_reset_n;
	input		led_band_controller_0_hps_sout;
	input		led_band_controller_0_hps_fc_clk;
	input		led_band_controller_0_hps_fc_data;
	input		led_band_controller_0_hps_override;
	input		led_band_controller_0_hps_new_frame;
	inout		hps_io_hps_io_sdio_inst_CMD;
	inout		hps_io_hps_io_sdio_inst_D0;
	inout		hps_io_hps_io_sdio_inst_D1;
	inout		hps_io_hps_io_sdio_inst_D4;
	inout		hps_io_hps_io_sdio_inst_D5;
	inout		hps_io_hps_io_sdio_inst_D6;
	inout		hps_io_hps_io_sdio_inst_D7;
	output		hps_io_hps_io_sdio_inst_CLK;
	inout		hps_io_hps_io_sdio_inst_D2;
	inout		hps_io_hps_io_sdio_inst_D3;
	inout		hps_io_hps_io_gpio_inst_GPIO49;
	inout		hps_io_hps_io_gpio_inst_GPIO50;
	inout		hps_io_hps_io_gpio_inst_GPIO51;
	inout		hps_io_hps_io_gpio_inst_GPIO52;
endmodule
