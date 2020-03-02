module septsegment #(parameter ADDR_WIDTH = 32)
(
   // Global Signals
   ACLK,
   ARESETn,
   // Write Address Channel
   AWADDR,
   AWPROT,
   AWVALID,
   AWREADY,
   // Write Channel
   WDATA,
   WSTRB,
   WVALID,
   WREADY,
   // Write Response Channel
   BRESP,
   BVALID,
   BREADY,
   // Read Address Channel
   ARADDR,
   ARPROT,
   ARVALID,
   ARREADY,
   // Read Channel
   RDATA,
   RRESP,
   RVALID,
   RREADY,
   // 7 segment
   oSEG0,oSEG1,oSEG2,oSEG3,oSEG4,oSEG5
);

// Global Signals
// =====
input                      ACLK;        // AXI Clock
input                      ARESETn;     // AXI Reset
// Write Address Channel
// =====
input   [ADDR_WIDTH - 1:0] AWADDR;
input   [2:0]              AWPROT;
input                      AWVALID;
output                     AWREADY;
// Write Data Channel
// =====
input                      WVALID;
output                     WREADY;
input   [31:0]             WDATA;
input   [3:0]              WSTRB;
// Write Response Channel
// =====
output  [1:0]              BRESP;
output                     BVALID;
input                      BREADY;
// Read Address Channel
// =====
input   [ADDR_WIDTH - 1:0] ARADDR;
input   [2:0]              ARPROT;
input                      ARVALID;
output                     ARREADY;
// Read Data Channel
// =====
output  [31:0]             RDATA;
output  [1:0]              RRESP;
output                     RVALID;
input                      RREADY;

// 7-seg output
// =====
output  [6:0] oSEG0,oSEG1,oSEG2,oSEG3,oSEG4,oSEG5;

logic [3:0][7:0] REG [0:5];

SEG7_LUT dec0(.iDIG(REG[0][0][3:0]), .oSEG(oSEG0));
SEG7_LUT dec1(.iDIG(REG[1][0][3:0]), .oSEG(oSEG1));
SEG7_LUT dec2(.iDIG(REG[2][0][3:0]), .oSEG(oSEG2));
SEG7_LUT dec3(.iDIG(REG[3][0][3:0]), .oSEG(oSEG3));
SEG7_LUT dec4(.iDIG(REG[4][0][3:0]), .oSEG(oSEG4));
SEG7_LUT dec5(.iDIG(REG[5][0][3:0]), .oSEG(oSEG5));

// Write processus

enum logic[2:0] {S_WAIT_WRITE ,S_WAIT_ADDR , S_WAIT_DATA , S_WRITE, S_SEND_ANS } BState;
logic [31:0] Data_write;
logic [ADDR_WIDTH-1:0] addr_write;
logic [1:0] b_resp;

always_ff @(posedge ACLK)
   if (!ARESETn) begin
   BState <= S_WAIT_WRITE;
   addr_write <= '0;
   for (int i=0; i<=5; i++)
			REG[i] <= 0;
   end
   else begin
     if ((BState == S_WAIT_WRITE)) begin
       if (AWVALID & WVALID) begin
         Data_write <= WDATA;
         addr_write <= AWADDR;
         BState <= S_WRITE;
       end
       else if (AWVALID) begin
         addr_write <= AWADDR;
         BState <= S_WAIT_DATA;
       end
       else if (WVALID) begin
         Data_write <= WDATA;
         BState <= S_WAIT_ADDR;
       end
     end

     else if ((BState == S_WAIT_DATA) & WVALID) begin
       Data_write <= WDATA;
       BState <= S_WRITE;
     end

     else if ((BState == S_WAIT_ADDR) & AWVALID) begin
       addr_write <= AWADDR;
       BState <= S_WRITE;
     end

     else if (BState == S_WRITE) begin
       if (BRESP == 2'b00)
         REG[addr_write[4:2]] <= Data_write;
       BState <= S_SEND_ANS;
     end

     else if ((BState == S_SEND_ANS) & BREADY)
       BState <= S_WAIT_WRITE;
   end

assign AWREADY = ((BState == S_WAIT_WRITE) | (BState == S_WAIT_ADDR)) ;
assign WREADY  = ((BState == S_WAIT_WRITE) | (BState == S_WAIT_DATA)) ;
assign BRESP   = ((addr_write <= 32'h14) & (addr_write[1:0]==0)) & (WSTRB == 4'hf) ? 2'b00 : 2'b11;
assign BVALID  = (BState == S_SEND_ANS) ;

// Read processus
enum logic {S_WAITREAD, S_SENDREAD  } RState;
logic [31:0] Data_read;
logic [1:0] r_resp;

always_ff @(posedge ACLK)
	if (!ARESETn) begin
   RState <= S_WAITREAD;
   r_resp <= 2'b00;   
   end
   else begin
     if ((RState == S_WAITREAD) & ARVALID) begin
       Data_read <= REG[ARADDR[4:2]];
       RState    <= S_SENDREAD;
       r_resp    <= ((ARADDR <= 32'h14) & (ARADDR[1:0]==0)) ? 2'b00 : 2'b11;
     end

     else if ((RState == S_SENDREAD) & RREADY)
       RState <= S_WAITREAD;
   end


assign  ARREADY = (RState == S_WAITREAD) ;
assign  RRESP   = r_resp;
assign  RVALID = (RState == S_SENDREAD) ;
assign  RDATA  = (RRESP == 2'h00) ? Data_read : 0;



endmodule