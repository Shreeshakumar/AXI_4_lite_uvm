class axi_pas_mon extends uvm_monitor;
	`uvm_component_utils(axi_pas_mon)
	uvm_analysis_port#(trans) pas_mon_port;

	virtual axi_interface.MON vif;
	axi_config m_cfg;
	trans pas_mon;

 	function new(string name="axi_pas_mon",uvm_component parent);
		super.new(name,parent);
 	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
   		if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m_cfg))
			`uvm_fatal(get_type_name(),"Output_Monitor Getting Failed")
		pas_mon_port=new("pas_mon_port",this);
		vif = m_cfg.vif;
 	endfunction

 	task run_phase(uvm_phase phase);
		forever begin	 
	    	collect_data();
			`uvm_info("OUTPUT_MONITOR","OUTPUT MONITOR",UVM_HIGH)
	   		`uvm_info("OUTPUT_MONITOR",$sformatf("OUTPUT MONITOR\n%s",pas_mon.sprint()),UVM_FULL)
		end
 	endtask
  
	virtual task collect_data();
		pas_mon=trans::type_id::create("pas_mon");
		@(vif.mon_cb);
		 	pas_mon.ARESETn		= vif.mon_cb.ARESETn;
		 	
		 	pas_mon.AWADDR		= vif.mon_cb.AWADDR;
		  	pas_mon.AWPROT		= vif.mon_cb.AWPROT;
		  	pas_mon.AWVALID		= vif.mon_cb.AWVALID;
		  	pas_mon.AWREADY		= vif.mon_cb.AWREADY;
		  	
		  	pas_mon.WDATA		= vif.mon_cb.WDATA;
		  	pas_mon.WSTRB		= vif.mon_cb.WSTRB;
		  	pas_mon.WVALID		= vif.mon_cb.WVALID;
		  	pas_mon.WREADY		= vif.mon_cb.WREADY;

		  	pas_mon.BRESP 		= vif.mon_cb.BRESP; 
		  	pas_mon.BVALID		= vif.mon_cb.BVALID;
		  	pas_mon.BREADY  	= vif.mon_cb.BREADY;
		  	
		  	pas_mon.ARADDR		= vif.mon_cb.ARADDR;
		  	pas_mon.ARPROT		= vif.mon_cb.ARPROT;
		  	pas_mon.ARVALID		= vif.mon_cb.ARVALID;
		  	pas_mon.ARREADY		= vif.mon_cb.ARREADY;
		  	
		  	pas_mon.RDATA		= vif.mon_cb.RDATA;
		  	pas_mon.RRESP		= vif.mon_cb.RRESP;
		  	pas_mon.RVALID		= vif.mon_cb.RVALID;
		  	pas_mon.RREADY		= vif.mon_cb.RREADY;
		  	
		pas_mon_port.write(pas_mon);
	endtask
endclass	   		

