PREFIX :=
CC := $(PREFIX)gcc
AS := $(PREFIX)as
CFLAGS := -c -g -O1 -Wall
SRC := $(wildcard src/*.c *.s)
OBJS := $(patsubst src/%.c,%.o,$(SRC))
ASFLAGS :=
EXE := LitSpin


$(EXE) : $(SRC)
	$(CC) -g -O1  $^ -o $@

clean :
	rm -f $(OBJS)
	rm -f $(EXE)


all :$(EXE)

run : $(EXE)
	$(PREFIX)gdb
