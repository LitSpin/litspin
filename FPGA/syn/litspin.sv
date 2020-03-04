//
// ARIES MCV module reference project -- top level module
//
// MIT License
//
// Copyright (c) 2016-2017 ARIES Embedded GmbH
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use, copy,
// modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

module litspin(
	             memory_oct_rzqin,
	             clk50a,
	             hps_0_uart1_rxd,
	             hps_io_hps_io_emac0_inst_RXD0,
	             hps_io_hps_io_emac0_inst_RX_CTL,
	             hps_io_hps_io_emac0_inst_RX_CLK,
	             hps_io_hps_io_emac0_inst_RXD1,
	             hps_io_hps_io_emac0_inst_RXD2,
	             hps_io_hps_io_emac0_inst_RXD3,
	             hps_io_hps_io_usb1_inst_CLK,
	             hps_io_hps_io_usb1_inst_DIR,
	             hps_io_hps_io_usb1_inst_NXT,
	             hps_io_hps_io_spim1_inst_MISO,
	             hps_io_hps_io_uart0_inst_RX,
	             hps_io_hps_io_can0_inst_RX,
	             hps_io_hps_io_can1_inst_RX,
	             hps_io_hps_io_gpio_inst_HLGPI0,
	             hps_io_hps_io_gpio_inst_HLGPI1,
	             hps_io_hps_io_gpio_inst_HLGPI2,
	             hps_io_hps_io_gpio_inst_HLGPI3,
	             hps_io_hps_io_gpio_inst_HLGPI4,
	             hps_io_hps_io_gpio_inst_HLGPI5,
	             hps_io_hps_io_gpio_inst_HLGPI6,
	             hps_io_hps_io_gpio_inst_HLGPI7,
	             hps_io_hps_io_gpio_inst_HLGPI8,
	             hps_io_hps_io_gpio_inst_HLGPI9,
	             hps_io_hps_io_gpio_inst_HLGPI10,
	             hps_io_hps_io_gpio_inst_HLGPI11,
	             hps_io_hps_io_gpio_inst_HLGPI12,
	             hps_io_hps_io_gpio_inst_HLGPI13,
	             nrst,
	             memory_mem_ck,
	             memory_mem_ck_n,
	             memory_mem_cke,
	             memory_mem_cs_n,
	             memory_mem_ras_n,
	             memory_mem_cas_n,
	             memory_mem_we_n,
	             memory_mem_reset_n,
	             memory_mem_odt,
	             hps_0_uart1_txd,
	             hps_io_hps_io_emac0_inst_TX_CLK,
	             hps_io_hps_io_emac0_inst_TXD0,
	             hps_io_hps_io_emac0_inst_TXD1,
	             hps_io_hps_io_emac0_inst_TXD2,
	             hps_io_hps_io_emac0_inst_TXD3,
	             hps_io_hps_io_emac0_inst_MDC,
	             hps_io_hps_io_emac0_inst_TX_CTL,
	             hps_io_hps_io_sdio_inst_CLK,
	             hps_io_hps_io_usb1_inst_STP,
	             hps_io_hps_io_spim1_inst_CLK,
	             hps_io_hps_io_spim1_inst_MOSI,
	             hps_io_hps_io_spim1_inst_SS0,
	             hps_io_hps_io_uart0_inst_TX,
	             hps_io_hps_io_can0_inst_TX,
	             hps_io_hps_io_can1_inst_TX,
	             hps_io_hps_io_emac0_inst_MDIO,
	             hps_io_hps_io_sdio_inst_CMD,
	             hps_io_hps_io_sdio_inst_D0,
	             hps_io_hps_io_sdio_inst_D1,
	             hps_io_hps_io_sdio_inst_D2,
	             hps_io_hps_io_sdio_inst_D3,
	             hps_io_hps_io_sdio_inst_D4,
	             hps_io_hps_io_sdio_inst_D5,
	             hps_io_hps_io_sdio_inst_D6,
	             hps_io_hps_io_sdio_inst_D7,
	             hps_io_hps_io_usb1_inst_D0,
	             hps_io_hps_io_usb1_inst_D1,
	             hps_io_hps_io_usb1_inst_D2,
	             hps_io_hps_io_usb1_inst_D3,
	             hps_io_hps_io_usb1_inst_D4,
	             hps_io_hps_io_usb1_inst_D5,
	             hps_io_hps_io_usb1_inst_D6,
	             hps_io_hps_io_usb1_inst_D7,
	             hps_io_hps_io_i2c0_inst_SDA,
	             hps_io_hps_io_i2c0_inst_SCL,
	             hps_io_hps_io_gpio_inst_GPIO19,
	             hps_io_hps_io_gpio_inst_GPIO20,
	             hps_io_hps_io_gpio_inst_GPIO21,
	             hps_io_hps_io_gpio_inst_GPIO26,
	             hps_io_hps_io_gpio_inst_GPIO27,
	             hps_io_hps_io_gpio_inst_GPIO28,
	             hps_io_hps_io_gpio_inst_GPIO33,
	             hps_io_hps_io_gpio_inst_GPIO34,
	             hps_io_hps_io_gpio_inst_GPIO35,
	             hps_io_hps_io_gpio_inst_GPIO37,
	             hps_io_hps_io_gpio_inst_GPIO44,
	             hps_io_hps_io_gpio_inst_GPIO48,
	             hps_io_hps_io_gpio_inst_GPIO51,
	             hps_io_hps_io_gpio_inst_GPIO52,
	             hps_io_hps_io_gpio_inst_GPIO57,
	             hps_io_hps_io_gpio_inst_GPIO58,
	             hps_io_hps_io_gpio_inst_GPIO59,
	             hps_io_hps_io_gpio_inst_GPIO60,
	             iob3a,
	             iob3b,
	             iob4a,
	             iob5a,
	             iob5b,
	             iob8a,
	             memory_mem_a,
	             memory_mem_ba,
	             memory_mem_dm,
	             memory_mem_dq,
	             memory_mem_dqs,
	             memory_mem_dqs_n
                     );

   input wire	memory_oct_rzqin;
   input wire	clk50a;
   input wire	hps_0_uart1_rxd;
   input wire	hps_io_hps_io_emac0_inst_RXD0;
   input wire	hps_io_hps_io_emac0_inst_RX_CTL;
   input wire	hps_io_hps_io_emac0_inst_RX_CLK;
   input wire	hps_io_hps_io_emac0_inst_RXD1;
   input wire	hps_io_hps_io_emac0_inst_RXD2;
   input wire	hps_io_hps_io_emac0_inst_RXD3;
   input wire	hps_io_hps_io_usb1_inst_CLK;
   input wire	hps_io_hps_io_usb1_inst_DIR;
   input wire	hps_io_hps_io_usb1_inst_NXT;
   input wire	hps_io_hps_io_spim1_inst_MISO;
   input wire	hps_io_hps_io_uart0_inst_RX;
   input wire	hps_io_hps_io_can0_inst_RX;
   input wire	hps_io_hps_io_can1_inst_RX;
   input wire	hps_io_hps_io_gpio_inst_HLGPI0;
   input wire	hps_io_hps_io_gpio_inst_HLGPI1;
   input wire	hps_io_hps_io_gpio_inst_HLGPI2;
   input wire	hps_io_hps_io_gpio_inst_HLGPI3;
   input wire	hps_io_hps_io_gpio_inst_HLGPI4;
   input wire	hps_io_hps_io_gpio_inst_HLGPI5;
   input wire	hps_io_hps_io_gpio_inst_HLGPI6;
   input wire	hps_io_hps_io_gpio_inst_HLGPI7;
   input wire	hps_io_hps_io_gpio_inst_HLGPI8;
   input wire	hps_io_hps_io_gpio_inst_HLGPI9;
   input wire	hps_io_hps_io_gpio_inst_HLGPI10;
   input wire	hps_io_hps_io_gpio_inst_HLGPI11;
   input wire	hps_io_hps_io_gpio_inst_HLGPI12;
   input wire	hps_io_hps_io_gpio_inst_HLGPI13;
   input wire	nrst;
   output wire	memory_mem_ck;
   output wire	memory_mem_ck_n;
   output wire	memory_mem_cke;
   output wire	memory_mem_cs_n;
   output wire	memory_mem_ras_n;
   output wire	memory_mem_cas_n;
   output wire	memory_mem_we_n;
   output wire	memory_mem_reset_n;
   output wire	memory_mem_odt;
   output wire	hps_0_uart1_txd;
   output wire	hps_io_hps_io_emac0_inst_TX_CLK;
   output wire	hps_io_hps_io_emac0_inst_TXD0;
   output wire	hps_io_hps_io_emac0_inst_TXD1;
   output wire	hps_io_hps_io_emac0_inst_TXD2;
   output wire	hps_io_hps_io_emac0_inst_TXD3;
   output wire	hps_io_hps_io_emac0_inst_MDC;
   output wire	hps_io_hps_io_emac0_inst_TX_CTL;
   output wire	hps_io_hps_io_sdio_inst_CLK;
   output wire	hps_io_hps_io_usb1_inst_STP;
   output wire	hps_io_hps_io_spim1_inst_CLK;
   output wire	hps_io_hps_io_spim1_inst_MOSI;
   output wire	hps_io_hps_io_spim1_inst_SS0;
   output wire	hps_io_hps_io_uart0_inst_TX;
   output wire	hps_io_hps_io_can0_inst_TX;
   output wire	hps_io_hps_io_can1_inst_TX;
   inout wire	hps_io_hps_io_emac0_inst_MDIO;
   inout wire	hps_io_hps_io_sdio_inst_CMD;
   inout wire	hps_io_hps_io_sdio_inst_D0;
   inout wire	hps_io_hps_io_sdio_inst_D1;
   inout wire	hps_io_hps_io_sdio_inst_D2;
   inout wire	hps_io_hps_io_sdio_inst_D3;
   inout wire	hps_io_hps_io_sdio_inst_D4;
   inout wire	hps_io_hps_io_sdio_inst_D5;
   inout wire	hps_io_hps_io_sdio_inst_D6;
   inout wire	hps_io_hps_io_sdio_inst_D7;
   inout wire	hps_io_hps_io_usb1_inst_D0;
   inout wire	hps_io_hps_io_usb1_inst_D1;
   inout wire	hps_io_hps_io_usb1_inst_D2;
   inout wire	hps_io_hps_io_usb1_inst_D3;
   inout wire	hps_io_hps_io_usb1_inst_D4;
   inout wire	hps_io_hps_io_usb1_inst_D5;
   inout wire	hps_io_hps_io_usb1_inst_D6;
   inout wire	hps_io_hps_io_usb1_inst_D7;
   inout wire	hps_io_hps_io_i2c0_inst_SDA;
   inout wire	hps_io_hps_io_i2c0_inst_SCL;
   inout wire	hps_io_hps_io_gpio_inst_GPIO19;
   inout wire	hps_io_hps_io_gpio_inst_GPIO20;
   inout wire	hps_io_hps_io_gpio_inst_GPIO21;
   inout wire	hps_io_hps_io_gpio_inst_GPIO26;
   inout wire	hps_io_hps_io_gpio_inst_GPIO27;
   inout wire	hps_io_hps_io_gpio_inst_GPIO28;
   inout wire	hps_io_hps_io_gpio_inst_GPIO33;
   inout wire	hps_io_hps_io_gpio_inst_GPIO34;
   inout wire	hps_io_hps_io_gpio_inst_GPIO35;
   inout wire	hps_io_hps_io_gpio_inst_GPIO37;
   inout wire	hps_io_hps_io_gpio_inst_GPIO44;
   inout wire	hps_io_hps_io_gpio_inst_GPIO48;
   inout wire	hps_io_hps_io_gpio_inst_GPIO51;
   inout wire	hps_io_hps_io_gpio_inst_GPIO52;
   inout wire	hps_io_hps_io_gpio_inst_GPIO57;
   inout wire	hps_io_hps_io_gpio_inst_GPIO58;
   inout wire	hps_io_hps_io_gpio_inst_GPIO59;
   inout wire	hps_io_hps_io_gpio_inst_GPIO60;
   inout wire [15:0] iob3a;
   inout wire [31:0] iob3b;
   inout wire [67:0] iob4a;
   inout wire [15:0] iob5a;
   inout wire [5:0]  iob5b;
   inout wire [3:0]  iob8a;
   output wire [14:0] memory_mem_a;
   output wire [2:0]  memory_mem_ba;
   output wire [3:0]  memory_mem_dm;
   inout wire [31:0]  memory_mem_dq;
   inout wire [3:0]   memory_mem_dqs;
   inout wire [3:0]   memory_mem_dqs_n;

   wire   sysclk;
   assign sysclk = clk50a;

   mcv_hps b2v_inst(
	            .clk_clk(sysclk),
	            .reset_reset_n(nrst),
	            .hps_io_hps_io_emac0_inst_RXD0(hps_io_hps_io_emac0_inst_RXD0),
	            .hps_io_hps_io_emac0_inst_RX_CTL(hps_io_hps_io_emac0_inst_RX_CTL),
	            .hps_io_hps_io_emac0_inst_RX_CLK(hps_io_hps_io_emac0_inst_RX_CLK),
	            .hps_io_hps_io_emac0_inst_RXD1(hps_io_hps_io_emac0_inst_RXD1),
	            .hps_io_hps_io_emac0_inst_RXD2(hps_io_hps_io_emac0_inst_RXD2),
	            .hps_io_hps_io_emac0_inst_RXD3(hps_io_hps_io_emac0_inst_RXD3),
	            .hps_io_hps_io_usb1_inst_CLK(hps_io_hps_io_usb1_inst_CLK),
	            .hps_io_hps_io_usb1_inst_DIR(hps_io_hps_io_usb1_inst_DIR),
	            .hps_io_hps_io_usb1_inst_NXT(hps_io_hps_io_usb1_inst_NXT),
	            .hps_io_hps_io_spim1_inst_MISO(hps_io_hps_io_spim1_inst_MISO),
	            .hps_io_hps_io_uart0_inst_RX(hps_io_hps_io_uart0_inst_RX),
	            .hps_io_hps_io_can0_inst_RX(hps_io_hps_io_can0_inst_RX),
	            .hps_io_hps_io_can1_inst_RX(hps_io_hps_io_can1_inst_RX),
	            .hps_io_hps_io_gpio_inst_HLGPI0(hps_io_hps_io_gpio_inst_HLGPI0),
	            .hps_io_hps_io_gpio_inst_HLGPI1(hps_io_hps_io_gpio_inst_HLGPI1),
	            .hps_io_hps_io_gpio_inst_HLGPI2(hps_io_hps_io_gpio_inst_HLGPI2),
	            .hps_io_hps_io_gpio_inst_HLGPI3(hps_io_hps_io_gpio_inst_HLGPI3),
	            .hps_io_hps_io_gpio_inst_HLGPI4(hps_io_hps_io_gpio_inst_HLGPI4),
	            .hps_io_hps_io_gpio_inst_HLGPI5(hps_io_hps_io_gpio_inst_HLGPI5),
	            .hps_io_hps_io_gpio_inst_HLGPI6(hps_io_hps_io_gpio_inst_HLGPI6),
	            .hps_io_hps_io_gpio_inst_HLGPI7(hps_io_hps_io_gpio_inst_HLGPI7),
	            .hps_io_hps_io_gpio_inst_HLGPI8(hps_io_hps_io_gpio_inst_HLGPI8),
	            .hps_io_hps_io_gpio_inst_HLGPI9(hps_io_hps_io_gpio_inst_HLGPI9),
	            .hps_io_hps_io_gpio_inst_HLGPI10(hps_io_hps_io_gpio_inst_HLGPI10),
	            .hps_io_hps_io_gpio_inst_HLGPI11(hps_io_hps_io_gpio_inst_HLGPI11),
	            .hps_io_hps_io_gpio_inst_HLGPI12(hps_io_hps_io_gpio_inst_HLGPI12),
	            .hps_io_hps_io_gpio_inst_HLGPI13(hps_io_hps_io_gpio_inst_HLGPI13),
	            .memory_oct_rzqin(memory_oct_rzqin),

	            .hps_0_uart1_rxd(hps_0_uart1_rxd),
	            .hps_io_hps_io_emac0_inst_MDIO(hps_io_hps_io_emac0_inst_MDIO),
	            .hps_io_hps_io_sdio_inst_CMD(hps_io_hps_io_sdio_inst_CMD),
	            .hps_io_hps_io_sdio_inst_D0(hps_io_hps_io_sdio_inst_D0),
	            .hps_io_hps_io_sdio_inst_D1(hps_io_hps_io_sdio_inst_D1),
	            .hps_io_hps_io_sdio_inst_D2(hps_io_hps_io_sdio_inst_D2),
	            .hps_io_hps_io_sdio_inst_D3(hps_io_hps_io_sdio_inst_D3),
	            .hps_io_hps_io_sdio_inst_D4(hps_io_hps_io_sdio_inst_D4),
	            .hps_io_hps_io_sdio_inst_D5(hps_io_hps_io_sdio_inst_D5),
	            .hps_io_hps_io_sdio_inst_D6(hps_io_hps_io_sdio_inst_D6),
	            .hps_io_hps_io_sdio_inst_D7(hps_io_hps_io_sdio_inst_D7),
	            .hps_io_hps_io_usb1_inst_D0(hps_io_hps_io_usb1_inst_D0),
	            .hps_io_hps_io_usb1_inst_D1(hps_io_hps_io_usb1_inst_D1),
	            .hps_io_hps_io_usb1_inst_D2(hps_io_hps_io_usb1_inst_D2),
	            .hps_io_hps_io_usb1_inst_D3(hps_io_hps_io_usb1_inst_D3),
	            .hps_io_hps_io_usb1_inst_D4(hps_io_hps_io_usb1_inst_D4),
	            .hps_io_hps_io_usb1_inst_D5(hps_io_hps_io_usb1_inst_D5),
	            .hps_io_hps_io_usb1_inst_D6(hps_io_hps_io_usb1_inst_D6),
	            .hps_io_hps_io_usb1_inst_D7(hps_io_hps_io_usb1_inst_D7),
	            .hps_io_hps_io_i2c0_inst_SDA(hps_io_hps_io_i2c0_inst_SDA),
	            .hps_io_hps_io_i2c0_inst_SCL(hps_io_hps_io_i2c0_inst_SCL),
	            .hps_io_hps_io_gpio_inst_GPIO19(hps_io_hps_io_gpio_inst_GPIO19),
	            .hps_io_hps_io_gpio_inst_GPIO20(hps_io_hps_io_gpio_inst_GPIO20),
	            .hps_io_hps_io_gpio_inst_GPIO21(hps_io_hps_io_gpio_inst_GPIO21),
	            .hps_io_hps_io_gpio_inst_GPIO26(hps_io_hps_io_gpio_inst_GPIO26),
	            .hps_io_hps_io_gpio_inst_GPIO27(hps_io_hps_io_gpio_inst_GPIO27),
	            .hps_io_hps_io_gpio_inst_GPIO28(hps_io_hps_io_gpio_inst_GPIO28),
	            .hps_io_hps_io_gpio_inst_GPIO33(hps_io_hps_io_gpio_inst_GPIO33),
	            .hps_io_hps_io_gpio_inst_GPIO34(hps_io_hps_io_gpio_inst_GPIO34),
	            .hps_io_hps_io_gpio_inst_GPIO35(hps_io_hps_io_gpio_inst_GPIO35),
	            .hps_io_hps_io_gpio_inst_GPIO37(hps_io_hps_io_gpio_inst_GPIO37),
	            .hps_io_hps_io_gpio_inst_GPIO44(hps_io_hps_io_gpio_inst_GPIO44),
	            .hps_io_hps_io_gpio_inst_GPIO48(hps_io_hps_io_gpio_inst_GPIO48),
	            .hps_io_hps_io_gpio_inst_GPIO51(hps_io_hps_io_gpio_inst_GPIO51),
	            .hps_io_hps_io_gpio_inst_GPIO52(hps_io_hps_io_gpio_inst_GPIO52),
	            .hps_io_hps_io_gpio_inst_GPIO57(hps_io_hps_io_gpio_inst_GPIO57),
	            .hps_io_hps_io_gpio_inst_GPIO58(hps_io_hps_io_gpio_inst_GPIO58),
	            .hps_io_hps_io_gpio_inst_GPIO59(hps_io_hps_io_gpio_inst_GPIO59),
	            .hps_io_hps_io_gpio_inst_GPIO60(hps_io_hps_io_gpio_inst_GPIO60),
	            .memory_mem_dq(memory_mem_dq),
	            .memory_mem_dqs(memory_mem_dqs),
	            .memory_mem_dqs_n(memory_mem_dqs_n),
	            .hps_io_hps_io_emac0_inst_TX_CLK(hps_io_hps_io_emac0_inst_TX_CLK),
	            .hps_io_hps_io_emac0_inst_TXD0(hps_io_hps_io_emac0_inst_TXD0),
	            .hps_io_hps_io_emac0_inst_TXD1(hps_io_hps_io_emac0_inst_TXD1),
	            .hps_io_hps_io_emac0_inst_TXD2(hps_io_hps_io_emac0_inst_TXD2),
	            .hps_io_hps_io_emac0_inst_TXD3(hps_io_hps_io_emac0_inst_TXD3),
	            .hps_io_hps_io_emac0_inst_MDC(hps_io_hps_io_emac0_inst_MDC),
	            .hps_io_hps_io_emac0_inst_TX_CTL(hps_io_hps_io_emac0_inst_TX_CTL),
	            .hps_io_hps_io_sdio_inst_CLK(hps_io_hps_io_sdio_inst_CLK),
	            .hps_io_hps_io_usb1_inst_STP(hps_io_hps_io_usb1_inst_STP),
	            .hps_io_hps_io_spim1_inst_CLK(hps_io_hps_io_spim1_inst_CLK),
	            .hps_io_hps_io_spim1_inst_MOSI(hps_io_hps_io_spim1_inst_MOSI),
	            .hps_io_hps_io_spim1_inst_SS0(hps_io_hps_io_spim1_inst_SS0),
	            .hps_io_hps_io_uart0_inst_TX(hps_io_hps_io_uart0_inst_TX),
	            .hps_io_hps_io_can0_inst_TX(hps_io_hps_io_can0_inst_TX),
	            .hps_io_hps_io_can1_inst_TX(hps_io_hps_io_can1_inst_TX),
	            .memory_mem_ck(memory_mem_ck),
	            .memory_mem_ck_n(memory_mem_ck_n),
	            .memory_mem_cke(memory_mem_cke),
	            .memory_mem_cs_n(memory_mem_cs_n),
	            .memory_mem_ras_n(memory_mem_ras_n),
	            .memory_mem_cas_n(memory_mem_cas_n),
	            .memory_mem_we_n(memory_mem_we_n),
	            .memory_mem_reset_n(memory_mem_reset_n),
	            .memory_mem_odt(memory_mem_odt),

	            .hps_0_uart1_txd(hps_0_uart1_txd),

	            .memory_mem_a(memory_mem_a),
	            .memory_mem_ba(memory_mem_ba),
	            .memory_mem_dm(memory_mem_dm)
	            );

endmodule
