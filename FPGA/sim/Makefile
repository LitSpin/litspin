COMP    = vlog +acc
SIM     = vsim -c
SIM_GUI = vsim

TB_SRC = $(wildcard ../tb_src/*.sv)
SRC    = $(wildcard ../src/*.sv)
TOP    = tb_led_band_controller

sim: compile
	$(SIM) $(TOP) 

sim-gui: compile
	$(SIM_GUI) $(TOP)

compile: $(TB_SRC) $(SRC)
	$(COMP) $(TB_SRC) $(SRC)
	touch compile

clean:
	rm -rf work
	rm -rf compile

.PHONY: clean
