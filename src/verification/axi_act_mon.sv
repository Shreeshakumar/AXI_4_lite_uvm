class axi_act_mon extends uvm_monitor;
	`uvm_component_utils(axi_act_mon)
	
	uvm_analysis_port#(trans) act_mon_port;

	virtual axi_interface.MON vif;
	axi_config 	m_cfg;
	trans		act_mon;

 	function new(string name="axi_act_monitor",uvm_component parent);
		super.new(name,parent);
		m_cfg = new();
 	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
   		if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m_cfg))
			`uvm_fatal(get_type_name(),"Input_Monitor Getting Failed")
		act_mon_port=new("act_mon_port",this);
		vif = m_cfg.vif;
 	endfunction

 	task run_phase(uvm_phase phase);
		forever begin
	    	collect_input_monitor();
			`uvm_info("INPUT_MONITOR",$sformatf("Input MONITOR\n%s",act_mon.sprint()),UVM_DEBUG)
		end		    
 	endtask

 	virtual task collect_input_monitor();
		act_mon=trans::type_id::create("act_mon");
        @(vif.act_mon_cb);
        `uvm_info("INPUT_MONITOR","INPUT_MONITOR",UVM_HIGH)
        
			act_mon.ARESETn   	= vif.act_mon_cb.ARESETn; 
			
			act_mon.AWADDR      = vif.act_mon_cb.AWADDR; 
	    	act_mon.AWPORT 		= vif.act_mon_cb.AWPORT;
	    	act_mon.AWVALID     = vif.act_mon_cb.AWVALID;
	    	
	    	act_mon.WDATA      	= vif.act_mon_cb.WDATA; 
	    	act_mon.WSTRB 		= vif.act_mon_cb.WSTRB;
	    	act_mon.WVALID     	= vif.act_mon_cb.WVALID;

	   		act_mon.BREADY   	= vif.act_mon_cb.BREADY;
	   		
	   		act_mon.ARADDR      = vif.act_mon_cb.ARADDR; 
	    	act_mon.ARPORT 		= vif.act_mon_cb.ARPORT;
	    	act_mon.ARVALID     = vif.act_mon_cb.ARVALID;
	    	
	    	act_mon.RREADY     	= vif.act_mon_cb.RREADY;
	   		
	    act_mon_port.write(act_mon);
	endtask
endclass

