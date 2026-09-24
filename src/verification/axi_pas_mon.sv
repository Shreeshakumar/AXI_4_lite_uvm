class axi_pas_mon extends uvm_monitor;
	`uvm_component_utils(axi_pas_mon)
	uvm_analysis_port#(trans) pas_mon_port;

	virtual axi_interface.MON vif;
	axi_config m_cfg;
	trans pas_mon;

 	function new(string name="axi_pas_mon",uvm_component parent);
		super.new(name,parent);
		pas_mon_port = new("pas_mon_port", this);
 	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
   		if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m_cfg))
			`uvm_fatal(get_type_name(),"Output_Monitor Getting Failed")
		vif = m_cfg.vif;
 	endfunction

 	task run_phase(uvm_phase phase);
    	fork 
      		collect_writes(); 
      		collect_reads(); 
			
      		$display("________________________________________________________________________________________________________________________________________________________________");
    	join
 	endtask
 	
 	virtual task collect_writes();
    	forever begin
    	  	trans txn = trans::type_id::create("txn");
    	  	txn.txn_sel = (1 << `TXN_BIT_WRITE); 
    	  	fork
    	    	begin
    	    	  	while (vif.mon_cb.AWVALID !== 1'b1 || vif.mon_cb.AWREADY !== 1'b1) @(vif.mon_cb);
    	    	  	txn.AWADDR = vif.mon_cb.AWADDR; 
    	    	  	txn.AWPROT = vif.mon_cb.AWPROT;
    	    	  	`uvm_info("MON_TRACE", "ADDRESS HANDSHAKE DONE", UVM_FULL)
       	 		end
       	 		begin
       	 		  	while (vif.mon_cb.WVALID !== 1'b1 || vif.mon_cb.WREADY !== 1'b1) @(vif.mon_cb);
        		  	txn.WDATA  = vif.mon_cb.WDATA; 
        		  	txn.WSTRB = vif.mon_cb.WSTRB;
        		  	`uvm_info("MON_TRACE", "DATA HANDSHAKE DONE", UVM_FULL)
        		end
      		join
      		while (vif.mon_cb.BVALID !== 1'b1 || vif.mon_cb.BREADY !== 1'b1) @(vif.mon_cb);
      		txn.BRESP = vif.mon_cb.BRESP;
        	`uvm_info("MON_TRACE", "Transaction captured", UVM_FULL)
      		pas_mon_port.write(txn); 
    	end
  	endtask

  	virtual task collect_reads();
    	forever begin
      		trans txn = trans::type_id::create("txn");
      		txn.txn_sel = (1 << `TXN_BIT_READ); 
      		while (vif.mon_cb.ARVALID !== 1'b1 || vif.mon_cb.ARREADY !== 1'b1) @(vif.mon_cb);
      		txn.ARADDR = vif.mon_cb.ARADDR; 
      		txn.ARPROT = vif.mon_cb.ARPROT;
      		`uvm_info("MON_TRACE", "ADDRESS captured", UVM_FULL)
      		while (vif.mon_cb.RVALID !== 1'b1 || vif.mon_cb.RREADY !== 1'b1) @(vif.mon_cb);
      		txn.RDATA = vif.mon_cb.RDATA; 
      		txn.RRESP  = vif.mon_cb.RRESP;
        	`uvm_info("MON_TRACE", "Read captured", UVM_FULL)
      		pas_mon_port.write(txn);
    	end
  	endtask
endclass	   		

