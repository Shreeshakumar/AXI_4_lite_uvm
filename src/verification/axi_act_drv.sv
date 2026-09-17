class axi_act_drv extends uvm_driver#(trans);
	`uvm_component_utils(axi_act_drv)

	virtual axi_interface.DRV vif;
	axi_config m_cfg;

 	function new(string name="axi_act_drv",uvm_component parent);
		super.new(name,parent);
 	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
   		if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m_cfg))
			`uvm_fatal(get_type_name(),"Input_Driver Getting Failed")
 	endfunction

 	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
 		vif=m_cfg.vif;
 	endfunction

 	task run_phase(uvm_phase phase);
	forever
	begin
		seq_item_port.get_next_item(req);
		@(vif.drv_cb);
		drive(req);
		seq_item_port.item_done();
	end
	endtask

 	task drive(trans data2duv);
	begin
   		@(vif.drv_cb);
		`uvm_info("INPUT_DRIVER","Input Driver",UVM_HIGH)
		`uvm_info("INPUT_DRIVER",$sformatf("Input Driver\n%s",data2duv.sprint()),UVM_DEBUG)
	    
	    vif.drv_cb.ARESETn	<= data2duv.ARESETn;
	    
	    vif.drv_cb.AWADDR   <= data2duv.AWADDR;
	    vif.drv_cb.AWPROT	<= data2duv.AWPROT;
	    vif.drv_cb.AWVALID	<= data2duv.AWVALID;
	    
	    vif.drv_cb.WDATA 	<= data2duv.WDATA;
	    vif.drv_cb.WSTRB   	<= data2duv.WSTRB;
        vif.drv_cb.WVALID  	<= data2duv.WVALID;
        
	    vif.drv_cb.BREADY 	<= data2duv.BREADY;
	    
	    vif.drv_cb.ARADDR 	<= data2duv.ARADDR;
	    vif.drv_cb.ARPROT  	<= data2duv.ARPROT;
	    vif.drv_cb.ARVALID	<= data2duv.ARVALID;
	    
	    vif.drv_cb.RREADY	<= data2duv.RREADY;
	end
 	endtask
 	
endclass


