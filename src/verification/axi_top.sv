`include "axi_pkg.sv"
`include "axi_interface.sv"
`include "../design/axi_rtl.sv"

module axi_top();       
	import uvm_pkg::*;
	import axi_pkg::*;

	bit ACLK;
	initial	forever #5 ACLK = !ACLK;

	axi_interface INF(ACLK);

	axi_rtl DUV(.ACLK(ACLK), 			.ARESETn(INF.ARESETn),													//reser
				.AWADDR(INF.AWADDR), 	.AWPROT(INF.AWPROT),	.AWVALID(INF.AWVALID),	.AWREADY(INF.AWREADY),	//AXI WRITE ADDRESS
				.WDATA(INF.WDATA), 		.WSTRB(INF.WSTRB),		.WVALID(INF.WVALID),	.WREADY(INF.WREADY),	//AXI WRITE DATA
				.BRESP(INF.BRESP),		.BVALID(INF.BVALID),	.BREADY(INF.BREADY),							//AXI WRITE RESPONSE
				.ARADDR(INF.ARADDR), 	.ARPROT(INF.ARPROT),	.ARVALID(INF.ARVALID),	.ARREADY(INF.ARREADY),	//AXI READ ADDRESS
				.RDATA(INF.RDATA), 		.RRESP(INF.RRESP),		.RVALID(INF.RVALID),	.RREADY(INF.RREADY));	//AXI READ DATA

 	initial
	begin
		uvm_config_db#(virtual axi_interface)::set(null,"*","vif",INF);
	    run_test();
	end
endmodule
