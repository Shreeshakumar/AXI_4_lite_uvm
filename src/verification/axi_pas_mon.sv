class axi_pas_mon extends uvm_monitor;
	`uvm_component_utils(axi_pas_mon)
	uvm_analysis_port#(trans) pas_mon_port;

	virtual axi_interface.PAS_MON vif;
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
	   		`uvm_info("OUTPUT_MONITOR"x,$sformatf("OUTPUT MONITOR\n%s",pas_mon.sprint()),UVM_FULL)
		end
 	endtask
  
	virtual task collect_data();
		pas_mon=trans::type_id::create("pas_mon");
		@(vif.pas_mon_cb);
		 	pas_mon.ARESETn		= vif.pas_mon_cb.ARESETn;
		 	
		 	pas_mon.AWADDR		= vif.pas_mon_cb.AWADDR;
		  	pas_mon.AWPORT		= vif.pas_mon_cb.AWPORT;
		  	pas_mon.AWVALID		= vif.pas_mon_cb.AWVALID;
		  	pas_mon.AWREADY		= vif.pas_mon_cb.AWREADY;
		  	
		  	pas_mon.WDATA		= vif.pas_mon_cb.WDATA;
		  	pas_mon.WSTRB		= vif.pas_mon_cb.WSTRB;
		  	pas_mon.WVALID		= vif.pas_mon_cb.WVALID;
		  	pas_mon.WREADY		= vif.pas_mon_cb.WREADY;

		  	pas_mon.BRESP 		= vif.pas_mon_cb.BRESP; 
		  	pas_mon.BVALID		= vif.pas_mon_cb.BVALID;
		  	pas_mon.BREADY  	= vif.pas_mon_cb.BREADY;
		  	
		  	pas_mon.ARADDR		= vif.pas_mon_cb.ARADDR;
		  	pas_mon.ARPORT		= vif.pas_mon_cb.ARPORT;
		  	pas_mon.ARVALID		= vif.pas_mon_cb.ARVALID;
		  	pas_mon.ARREADY		= vif.pas_mon_cb.ARREADY;
		  	
		  	pas_mon.RDATA		= vif.pas_mon_cb.RDATA;
		  	pas_mon.PRESP		= vif.pas_mon_cb.PRESP;
		  	pas_mon.RVALID		= vif.pas_mon_cb.RVALID;
		  	pas_mon.RREADY		= vif.pas_mon_cb.RREADY;
		  	
		pas_mon_port.write(pas_mon);
	endtask
endclass	   		

