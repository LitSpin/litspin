	component LitFPGA is
		port (
			clk_clk                             : in    std_logic                     := 'X';             -- clk
			memory_mem_a                        : out   std_logic_vector(12 downto 0);                    -- mem_a
			memory_mem_ba                       : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck                       : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n                     : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke                      : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n                     : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n                    : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n                    : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n                     : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n                  : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq                       : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dq
			memory_mem_dqs                      : inout std_logic                     := 'X';             -- mem_dqs
			memory_mem_dqs_n                    : inout std_logic                     := 'X';             -- mem_dqs_n
			memory_mem_odt                      : out   std_logic;                                        -- mem_odt
			memory_mem_dm                       : out   std_logic;                                        -- mem_dm
			memory_oct_rzqin                    : in    std_logic                     := 'X';             -- oct_rzqin
			reset_reset_n                       : in    std_logic                     := 'X';             -- reset_n
			led_band_controller_0_hps_sout      : in    std_logic                     := 'X';             -- sout
			led_band_controller_0_hps_fc_clk    : in    std_logic                     := 'X';             -- fc_clk
			led_band_controller_0_hps_fc_data   : in    std_logic                     := 'X';             -- fc_data
			led_band_controller_0_hps_override  : in    std_logic                     := 'X';             -- override
			led_band_controller_0_hps_new_frame : in    std_logic                     := 'X';             -- new_frame
			hps_io_hps_io_sdio_inst_CMD         : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0          : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1          : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_D4          : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D4
			hps_io_hps_io_sdio_inst_D5          : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D5
			hps_io_hps_io_sdio_inst_D6          : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D6
			hps_io_hps_io_sdio_inst_D7          : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D7
			hps_io_hps_io_sdio_inst_CLK         : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2          : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3          : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_io_hps_io_gpio_inst_GPIO49      : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO49
			hps_io_hps_io_gpio_inst_GPIO50      : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO50
			hps_io_hps_io_gpio_inst_GPIO51      : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO51
			hps_io_hps_io_gpio_inst_GPIO52      : inout std_logic                     := 'X'              -- hps_io_gpio_inst_GPIO52
		);
	end component LitFPGA;

	u0 : component LitFPGA
		port map (
			clk_clk                             => CONNECTED_TO_clk_clk,                             --                       clk.clk
			memory_mem_a                        => CONNECTED_TO_memory_mem_a,                        --                    memory.mem_a
			memory_mem_ba                       => CONNECTED_TO_memory_mem_ba,                       --                          .mem_ba
			memory_mem_ck                       => CONNECTED_TO_memory_mem_ck,                       --                          .mem_ck
			memory_mem_ck_n                     => CONNECTED_TO_memory_mem_ck_n,                     --                          .mem_ck_n
			memory_mem_cke                      => CONNECTED_TO_memory_mem_cke,                      --                          .mem_cke
			memory_mem_cs_n                     => CONNECTED_TO_memory_mem_cs_n,                     --                          .mem_cs_n
			memory_mem_ras_n                    => CONNECTED_TO_memory_mem_ras_n,                    --                          .mem_ras_n
			memory_mem_cas_n                    => CONNECTED_TO_memory_mem_cas_n,                    --                          .mem_cas_n
			memory_mem_we_n                     => CONNECTED_TO_memory_mem_we_n,                     --                          .mem_we_n
			memory_mem_reset_n                  => CONNECTED_TO_memory_mem_reset_n,                  --                          .mem_reset_n
			memory_mem_dq                       => CONNECTED_TO_memory_mem_dq,                       --                          .mem_dq
			memory_mem_dqs                      => CONNECTED_TO_memory_mem_dqs,                      --                          .mem_dqs
			memory_mem_dqs_n                    => CONNECTED_TO_memory_mem_dqs_n,                    --                          .mem_dqs_n
			memory_mem_odt                      => CONNECTED_TO_memory_mem_odt,                      --                          .mem_odt
			memory_mem_dm                       => CONNECTED_TO_memory_mem_dm,                       --                          .mem_dm
			memory_oct_rzqin                    => CONNECTED_TO_memory_oct_rzqin,                    --                          .oct_rzqin
			reset_reset_n                       => CONNECTED_TO_reset_reset_n,                       --                     reset.reset_n
			led_band_controller_0_hps_sout      => CONNECTED_TO_led_band_controller_0_hps_sout,      -- led_band_controller_0_hps.sout
			led_band_controller_0_hps_fc_clk    => CONNECTED_TO_led_band_controller_0_hps_fc_clk,    --                          .fc_clk
			led_band_controller_0_hps_fc_data   => CONNECTED_TO_led_band_controller_0_hps_fc_data,   --                          .fc_data
			led_band_controller_0_hps_override  => CONNECTED_TO_led_band_controller_0_hps_override,  --                          .override
			led_band_controller_0_hps_new_frame => CONNECTED_TO_led_band_controller_0_hps_new_frame, --                          .new_frame
			hps_io_hps_io_sdio_inst_CMD         => CONNECTED_TO_hps_io_hps_io_sdio_inst_CMD,         --                    hps_io.hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0          => CONNECTED_TO_hps_io_hps_io_sdio_inst_D0,          --                          .hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1          => CONNECTED_TO_hps_io_hps_io_sdio_inst_D1,          --                          .hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_D4          => CONNECTED_TO_hps_io_hps_io_sdio_inst_D4,          --                          .hps_io_sdio_inst_D4
			hps_io_hps_io_sdio_inst_D5          => CONNECTED_TO_hps_io_hps_io_sdio_inst_D5,          --                          .hps_io_sdio_inst_D5
			hps_io_hps_io_sdio_inst_D6          => CONNECTED_TO_hps_io_hps_io_sdio_inst_D6,          --                          .hps_io_sdio_inst_D6
			hps_io_hps_io_sdio_inst_D7          => CONNECTED_TO_hps_io_hps_io_sdio_inst_D7,          --                          .hps_io_sdio_inst_D7
			hps_io_hps_io_sdio_inst_CLK         => CONNECTED_TO_hps_io_hps_io_sdio_inst_CLK,         --                          .hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2          => CONNECTED_TO_hps_io_hps_io_sdio_inst_D2,          --                          .hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3          => CONNECTED_TO_hps_io_hps_io_sdio_inst_D3,          --                          .hps_io_sdio_inst_D3
			hps_io_hps_io_gpio_inst_GPIO49      => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO49,      --                          .hps_io_gpio_inst_GPIO49
			hps_io_hps_io_gpio_inst_GPIO50      => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO50,      --                          .hps_io_gpio_inst_GPIO50
			hps_io_hps_io_gpio_inst_GPIO51      => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO51,      --                          .hps_io_gpio_inst_GPIO51
			hps_io_hps_io_gpio_inst_GPIO52      => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO52       --                          .hps_io_gpio_inst_GPIO52
		);

