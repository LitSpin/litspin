CXX := g++
CXXFLAGS := -Wall -g
SRCDIR := ./src
SRC := $(wildcard $(SRCDIR)/*.cpp)
OBJ := $(SRC:.cpp=.o)

voxelizer: $(SRC)
	$(CXX) $(CXXFLAGS) $^ -o $@

clean:
	rm test
