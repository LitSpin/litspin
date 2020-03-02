/* Quartus Prime Version 18.1.0 Build 625 09/12/2018 SJ Standard Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(SOCVHPS) MfrSpec(OpMask(0));
	P ActionCode(Cfg)
		Device PartName(5CSEMA5F31) Path("/home/rguilloteau/Telecom/litspin/litspin-project/SoC_DE1-SoC/HelloWorld_SoC/") File("HelloWorld_SoC.sof") MfrSpec(OpMask(1));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
