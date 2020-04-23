EXE = main

CC = arm-linux-gnueabihf-gcc
AS = arm-linux-gnueabihf-as
CFLAGS = -g -Wall -O2 -I$(SOCEDS_DEST_ROOT)/ip/altera/hps/altera_hps/hwlib/include -Dsoc_cv_av
OBJS = main.o

all : $(EXE)
$(EXE) : $(OBJS)


clean:
	rm -f $(OBJS) $(EXE)
