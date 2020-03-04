#**************************************************************
# Time Information
#**************************************************************
set_time_format -unit ns -decimal_places 3


#**************************************************************
# Create Clock
#**************************************************************
create_clock -name {clk_050} -period 20.000 [get_ports {clk50a}]

# create fake clocks for SoC clock signals since it is not affecting router, please refer spec for its supported frequency
create_clock -period 20  [get_ports hps_io_hps_io_usb1_inst_CLK]
create_clock -period 100 [get_ports hps_io_hps_io_i2c0_inst_SCL]


#**************************************************************
# Create Generated Clocks
#**************************************************************
derive_pll_clocks -create_base_clock


#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty


#**************************************************************
# Set Input Delay
#**************************************************************
set_input_delay -clock clk_050 -max 3 [get_ports {iob3a[*]}]
set_input_delay -clock clk_050 -min 2 [get_ports {iob3a[*]}]

set_input_delay -clock clk_050 -max 3 [get_ports {iob3b[*]}]
set_input_delay -clock clk_050 -min 2 [get_ports {iob3b[*]}]

set_input_delay -clock clk_050 -max 3 [get_ports {iob4a[*]}]
set_input_delay -clock clk_050 -min 2 [get_ports {iob4a[*]}]

set_input_delay -clock clk_050 -max 3 [get_ports {iob5a[*]}]
set_input_delay -clock clk_050 -min 2 [get_ports {iob5a[*]}]

set_input_delay -clock clk_050 -max 3 [get_ports {iob5b[*]}]
set_input_delay -clock clk_050 -min 2 [get_ports {iob5b[*]}]

set_input_delay -clock clk_050 -max 3 [get_ports {iob8a[*]}]
set_input_delay -clock clk_050 -min 2 [get_ports {iob8a[*]}]


#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -clock clk_050 2 [get_ports {iob3a[*]}]

set_output_delay -clock clk_050 2 [get_ports {iob3b[*]}]

set_output_delay -clock clk_050 2 [get_ports {iob4a[*]}]

set_output_delay -clock clk_050 2 [get_ports {iob5a[*]}]

set_output_delay -clock clk_050 2 [get_ports {iob5b[*]}]

set_output_delay -clock clk_050 2 [get_ports {iob8a[*]}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************
# Ignore Paths between Resets
set_false_path -from [get_ports {nrst}] -to *
# Ignore HPS I/O
set_false_path -from [get_ports {hps_*}] -to *
set_false_path -from * -to [get_ports {hps_*}]


#**************************************************************
# Set Multicycle Path
#**************************************************************
