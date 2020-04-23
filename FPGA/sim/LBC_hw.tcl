# TCL File Generated by Component Editor 18.1
# Wed Feb 05 11:12:17 CET 2020
# DO NOT MODIFY


# 
# LBC "LBC" v1.0
#  2020.02.05.11:12:17
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module LBC
# 
set_module_property DESCRIPTION ""
set_module_property NAME LBC
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME LBC
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL led_band_controller
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file led_band_controller.sv SYSTEM_VERILOG PATH ../src/led_band_controller.sv TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter NB_LED_COLUMN INTEGER 32
set_parameter_property NB_LED_COLUMN DEFAULT_VALUE 32
set_parameter_property NB_LED_COLUMN DISPLAY_NAME NB_LED_COLUMN
set_parameter_property NB_LED_COLUMN TYPE INTEGER
set_parameter_property NB_LED_COLUMN UNITS None
set_parameter_property NB_LED_COLUMN HDL_PARAMETER true
add_parameter BIT_PER_COLOR INTEGER 8
set_parameter_property BIT_PER_COLOR DEFAULT_VALUE 8
set_parameter_property BIT_PER_COLOR DISPLAY_NAME BIT_PER_COLOR
set_parameter_property BIT_PER_COLOR TYPE INTEGER
set_parameter_property BIT_PER_COLOR UNITS None
set_parameter_property BIT_PER_COLOR HDL_PARAMETER true
add_parameter NB_0_LSB INTEGER 1
set_parameter_property NB_0_LSB DEFAULT_VALUE 1
set_parameter_property NB_0_LSB DISPLAY_NAME NB_0_LSB
set_parameter_property NB_0_LSB TYPE INTEGER
set_parameter_property NB_0_LSB UNITS None
set_parameter_property NB_0_LSB HDL_PARAMETER true
add_parameter NB_ANGLES INTEGER 128
set_parameter_property NB_ANGLES DEFAULT_VALUE 128
set_parameter_property NB_ANGLES DISPLAY_NAME NB_ANGLES
set_parameter_property NB_ANGLES TYPE INTEGER
set_parameter_property NB_ANGLES UNITS None
set_parameter_property NB_ANGLES HDL_PARAMETER true
add_parameter ANGLE_PCB INTEGER 0
set_parameter_property ANGLE_PCB DEFAULT_VALUE 0
set_parameter_property ANGLE_PCB DISPLAY_NAME ANGLE_PCB
set_parameter_property ANGLE_PCB TYPE INTEGER
set_parameter_property ANGLE_PCB UNITS None
set_parameter_property ANGLE_PCB HDL_PARAMETER true
add_parameter W_DATA_WIDTH INTEGER 128
set_parameter_property W_DATA_WIDTH DEFAULT_VALUE 128
set_parameter_property W_DATA_WIDTH DISPLAY_NAME W_DATA_WIDTH
set_parameter_property W_DATA_WIDTH TYPE INTEGER
set_parameter_property W_DATA_WIDTH UNITS None
set_parameter_property W_DATA_WIDTH HDL_PARAMETER true
add_parameter default_FC STD_LOGIC_VECTOR 101163676500040
set_parameter_property default_FC DEFAULT_VALUE 101163676500040
set_parameter_property default_FC DISPLAY_NAME default_FC
set_parameter_property default_FC WIDTH 50
set_parameter_property default_FC TYPE STD_LOGIC_VECTOR
set_parameter_property default_FC UNITS None
set_parameter_property default_FC ALLOWED_RANGES 0:1125899906842623
set_parameter_property default_FC HDL_PARAMETER true


# 
# display items
# 


# 
# connection point avalon_slave
# 
add_interface avalon_slave avalon end
set_interface_property avalon_slave addressUnits WORDS
set_interface_property avalon_slave associatedClock ""
set_interface_property avalon_slave associatedReset ""
set_interface_property avalon_slave bitsPerSymbol 8
set_interface_property avalon_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_slave burstcountUnits WORDS
set_interface_property avalon_slave explicitAddressSpan 0
set_interface_property avalon_slave holdTime 0
set_interface_property avalon_slave linewrapBursts false
set_interface_property avalon_slave maximumPendingReadTransactions 0
set_interface_property avalon_slave maximumPendingWriteTransactions 0
set_interface_property avalon_slave readLatency 0
set_interface_property avalon_slave readWaitTime 1
set_interface_property avalon_slave setupTime 0
set_interface_property avalon_slave timingUnits Cycles
set_interface_property avalon_slave writeWaitTime 0
set_interface_property avalon_slave ENABLED true
set_interface_property avalon_slave EXPORT_OF ""
set_interface_property avalon_slave PORT_NAME_MAP ""
set_interface_property avalon_slave CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave w_addr_input address Input "(non-static) - (0) + 1"
add_interface_port avalon_slave write write Input 1
add_interface_port avalon_slave w_data writedata Input W_DATA_WIDTH
set_interface_assignment avalon_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave embeddedsw.configuration.isPrintableDevice 0


# 
# connection point w_clk
# 
add_interface w_clk clock end
set_interface_property w_clk clockRate 0
set_interface_property w_clk ENABLED true
set_interface_property w_clk EXPORT_OF ""
set_interface_property w_clk PORT_NAME_MAP ""
set_interface_property w_clk CMSIS_SVD_VARIABLES ""
set_interface_property w_clk SVD_ADDRESS_GROUP ""

add_interface_port w_clk w_clk clk Input 1


# 
# connection point rst
# 
add_interface rst reset end
set_interface_property rst associatedClock w_clk
set_interface_property rst synchronousEdges DEASSERT
set_interface_property rst ENABLED true
set_interface_property rst EXPORT_OF ""
set_interface_property rst PORT_NAME_MAP ""
set_interface_property rst CMSIS_SVD_VARIABLES ""
set_interface_property rst SVD_ADDRESS_GROUP ""


# 
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock w_clk
set_interface_property avalon_slave_0 associatedReset ""
set_interface_property avalon_slave_0 bitsPerSymbol 8
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 burstcountUnits WORDS
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0
set_interface_property avalon_slave_0 ENABLED true
set_interface_property avalon_slave_0 EXPORT_OF ""
set_interface_property avalon_slave_0 PORT_NAME_MAP ""
set_interface_property avalon_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_0 rst beginbursttransfer Input 1
add_interface_port avalon_slave_0 SCLK beginbursttransfer Input 1
add_interface_port avalon_slave_0 LAT beginbursttransfer Input 1
add_interface_port avalon_slave_0 angle beginbursttransfer Input "(non-static) - (0) + 1"
add_interface_port avalon_slave_0 row beginbursttransfer Input "(non-static) - (0) + 1"
add_interface_port avalon_slave_0 color writebyteenable_n Input 2
add_interface_port avalon_slave_0 bit_sel beginbursttransfer Input "(non-static) - (0) + 1"
add_interface_port avalon_slave_0 SOUT writeresponsevalid_n Output 1
add_interface_port avalon_slave_0 new_frame beginbursttransfer Input 1
add_interface_port avalon_slave_0 hps_override beginbursttransfer Input 1
add_interface_port avalon_slave_0 hps_SOUT beginbursttransfer Input 1
add_interface_port avalon_slave_0 hps_fc_clk beginbursttransfer Input 1
add_interface_port avalon_slave_0 hps_fc_data beginbursttransfer Input 1
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1

