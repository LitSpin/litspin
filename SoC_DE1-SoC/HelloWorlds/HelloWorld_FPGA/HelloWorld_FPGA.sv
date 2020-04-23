module HelloWorld_FPGA(
input sw[9:0],
output led[9:0]
);

assign led=sw;

endmodule