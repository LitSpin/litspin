CXX := g++
CXXFLAGS := -Wall -g
SRCDIR := ./src
SRC := $(wildcard $(SRCDIR)/*.cpp)
OBJ := $(SRC:.cpp=.o)
EXE := LitControl

all : $(SRC)
	$(CXX) $(CXXFLAGS) $^ -o $(EXE)

clean:
	rm $(EXE)
