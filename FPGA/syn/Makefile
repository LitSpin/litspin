#
# MCV reference project
#
# Copyright (C) 2016-2017 ARIES Embedded GmbH
#

PROJECT := litspin
#CONFIG  := c2
CONFIG  := c6

ifeq ($(CONFIG),c2)
DEVICE_NAME := 5CSXFC2C6U23C7
else
DEVICE_NAME := 5CSXFC6C6U23C7
endif

QSYS_FILE := mcv_hps.qsys

VERILOG_FILES := litspin.sv

QSYS_SYSTEM_NAME := $(subst .qsys,,$(QSYS_FILE))
QSYS_QIP_FILE := $(QSYS_SYSTEM_NAME)/synthesis/$(QSYS_SYSTEM_NAME).qip

ASSIGNMENT_FILES := $(PROJECT).qpf $(widlcard *.qsf)

SOURCE_FILES := $(ASSIGNMENT_FILES) $(VERILOG_FILES) $(QSYS_QIP_FILE)

OUTPUT_DIR := ./output_files
BSP_DIR := ./software/spl_bsp
HEADER_DIR := ./software

DTS_FILE := $(OUTPUT_DIR)/$(QSYS_SYSTEM_NAME).dts

STAMP := echo done >
RM    := rm -f

QUARTUS := quartus
#Q_ARGS  := --read_settings_file=off --write_settings_file=off $(PROJECT) -c $(CONFIG)
Q_ARGS  := --read_settings_file=off --write_settings_file=off $(PROJECT) -c $(CONFIG)

QUARTUS_INSTALL_DIR := $(shell which $(QUARTUS) | sed -e 's@/quartus/bin/quartus$$@@')
QUARTUS_EMBEDDED_TOOLS := $(QUARTUS_INSTALL_DIR)/embedded/host_tools/altera

.PHONY: all bsp dts clean distclean clean-qsys clean-bsp clean-dts

all: $(OUTPUT_DIR)/$(CONFIG).sof $(OUTPUT_DIR)/$(CONFIG).rbf

distclean: clean clean-qsys clean-bsp clean-dts
	$(RM) -r db incremental_db simulation
	$(RM) *.qws *.sopcinfo *.csv
	$(RM) *~ *.bak

clean-qsys:
	$(RM) -r $(QSYS_SYSTEM_NAME) .qsys_edit
	$(RM) $(QSYS_SYSTEM_NAME).{cmp,html,sopcinfo}

clean-bsp:
	$(RM) -r $(BSP_DIR)/generated
	$(RM) $(BSP_DIR)/Makefile $(BSP_DIR)/*.ds

clean-dts:
	$(RM) $(DTS_FILE)

clean-git:
	git clean -d -f

clean:
	$(RM) -r $(OUTPUT_DIR)
	$(RM) -r hps_isw_handoff
	$(RM) *~ *.rpt *.chg *.htm *.txt *.eqn *.pin *.sof *.pof *.rbf *.summary

.PHONY: cfg

cfg: $(OUTPUT_DIR)/$(CONFIG).sof
	$(QUARTUS)_pgm $(CONFIG)_sof.cdf

$(OUTPUT_DIR)/$(CONFIG).sof: asm
$(OUTPUT_DIR)/$(CONFIG).rbf: asm

bsp: $(OUTPUT_DIR)/$(CONFIG).asm.rpt
	$(QUARTUS_EMBEDDED_TOOLS)/preloadergen/bsp-generate-files \
		--settings=$(BSP_DIR)/settings.bsp --bsp-dir=$(BSP_DIR)

dts: $(DTS_FILE)

$(DTS_FILE): asm $(QSYS_SYSTEM_NAME).sopcinfo
	$(QUARTUS_EMBEDDED_TOOLS)/device_tree/sopc2dts --input=$(QSYS_SYSTEM_NAME).sopcinfo > $@

$(QSYS_QIP_FILE): $(QSYS_FILE)
	qsys-generate --synthesis=VERILOG $<

$(HEADER_DIR)/$(QSYS_SYSTEM_NAME).h: $(QSYS_SYSTEM_NAME).sopcinfo
	mkdir -p $(HEADER_DIR)
	sopc-create-header-files $< --single $@ --module hps_0


.PHONY: qsys map fit asm sta
qsys:$(QSYS_QIP_FILE)
header:$(HEADER_DIR)/$(QSYS_SYSTEM_NAME).h
map: $(OUTPUT_DIR)/$(CONFIG).map.rpt
fit: $(OUTPUT_DIR)/$(CONFIG).fit.rpt
asm: $(OUTPUT_DIR)/$(CONFIG).asm.rpt
sta: $(OUTPUT_DIR)/$(CONFIG).sta.rpt

#MAP_ARGS := --read_settings_file=on --write_settings_file=off $(PROJECT) -c $(CONFIG)
MAP_ARGS := --read_settings_file=on --write_settings_file=off $(PROJECT) -c $(CONFIG)
FIT_ARGS := $(Q_ARGS)
ASM_ARGS := $(Q_ARGS)
STA_ARGS := $(CONFIG)

$(OUTPUT_DIR)/$(CONFIG).map.rpt: map.chg $(SOURCE_FILES) $(IP_FILES)
	$(QUARTUS)_map $(MAP_ARGS)
	$(STAMP) fit.chg

$(OUTPUT_DIR)/$(CONFIG).fit.rpt: fit.chg $(OUTPUT_DIR)/$(CONFIG).map.rpt $(PIN_ASSIGNMENTS)
	$(QUARTUS)_fit $(FIT_ARGS)
	$(STAMP) asm.chg
	$(STAMP) sta.chg

$(OUTPUT_DIR)/$(CONFIG).asm.rpt: asm.chg $(OUTPUT_DIR)/$(CONFIG).fit.rpt
	$(QUARTUS)_asm $(ASM_ARGS)

$(OUTPUT_DIR)/$(CONFIG).sta.rpt: sta.chg $(OUTPUT_DIR)/$(CONFIG).fit.rpt
	$(QUARTUS)_sta $(STA_ARGS)

map.chg:
	$(STAMP) map.chg
fit.chg:
	$(STAMP) fit.chg
sta.chg:
	$(STAMP) sta.chg
asm.chg:
	$(STAMP) asm.chg
