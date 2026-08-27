interface axi_interface(input bit ACLK);

	//reset
  	logic 						ARESETn;
  
  	//WRITE address chhannel
  	logic [`ADDR_WIDTH-1:0] 	AWADDR;
  	logic [2:0]  				AWPROT;
  	logic 					  	AWVALID;
  	logic 					  	AWREADY;
  
  	//WRITE data channel
  	logic [DATA_WIDTH-1:0]	  	WDATA;
  	logic [(DATA_WIDTH/8)-1:0]  WSTRB;
  	logic   					WVALID;
  	logic 					  	WREADY;
  
  	//WRITE response channel
  	logic [1:0]  				BRESP;
  	logic 					  	BVALID;
  	logic 					  	BREADY;
  
  	//READ address channel
  	logic [ADDR_WIDTH-1:0]	  	ARADDR;
  	logic [1:0]  				ARPROT;
  	logic 					 	ARVALID;
  	logic 					 	ARREADY;
  
  	//READ data channel
  	logic [DATA_WIDTH-1:0] 	  	RDATA;
  	logic [1:0]   				RRESP;
  	logic					 	RVALID;
 	logic 					  	RREADY;

  	clocking drv_cb @(negedge ACLK);
    	default output #0;
    	output ARESETn;						//reset
    	output AWADDR, AWPROT, AWVALID;		//WRITE address chhannel
    	output WDATA, WSTRB, WVALID;		//WRITE data channel
    	output BREADY;						//WRITE response channel
    	output ARADDR, ARPROT, ARVALID;		//READ address channel
    	output RREADY;						//READ data channel
  	endclocking

  	clocking mon_cb @(posedge clk);
    	default input #0;
    	input ARESETn;								//reset
    	input AWADDR, AWPROT, AWVALID, AWREADY;		//WRITE address chhannel
    	input WDATA, WSTRB, WVALID, WREADY;			//WRITE data channel
    	input BRESP, BVALID, BREADY;				//WRITE response channel
    	input ARADDR, ARPROT, ARVALID, ARREADY;		//READ address channel
    	input RDATA, RRESP, RVALID, RREADY;			//READ data channel
  	endclocking

  	modport DRV(clocking drv_cb);
  	modport MON(clocking mon_cb);

/*	property p_reset_clears_outputs;
    	@(posedge clk)
    	rst |=> (res=='d0) && !cout && !oflow && !G && !E && !L && !err;
  	endproperty a_reset_clears_outputs: 
  	assert property (p_reset_clears_outputs)
  	else $error("[ALU_IF] Reset active but outputs not cleared: res=%0h cout=%0b oflow=%0b G=%0b E=%0b L=%0b err=%0b",res, cout, oflow, G, E, L, err);
*/

endinterface
