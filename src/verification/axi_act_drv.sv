class axi_act_drv extends uvm_driver#(trans);
	`uvm_component_utils(axi_act_drv)

	virtual axi_interface.ACT_DRV vif;
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
		drive(req);
		seq_item_port.item_done();
	end
	endtask

 	task drive(trans data2duv);
	begin
        @(vif.act_drv_cb);
		`uvm_info("INPUT_DRIVER","Input Driver",UVM_HIGH)
		`uvm_info("INPUT_DRIVER",$sformatf("Input Driver\n%s",data2duv.sprint()),UVM_DEBUG)
	    
	    vif.act_drv_cb.ARESETn	<= data2duv.ARESETn;
	    
	    vif.inp_drv_cb.AWADDR   <= data2duv.AWADDR;
	    vif.inp_drv_cb.AWPORT	<= data2duv.AWPORT;
	    vif.inp_drv_cb.AWVALID	<= data2duv.AWVALID;
	    
	    vif.inp_drv_cb.WDATA 	<= data2duv.WDATA;
	    vif.inp_drv_cb.WSTRB   	<= data2duv.WSTRB;
        vif.inp_drv_cb.WVALID  	<= data2duv.WVALID;
        
	    vif.inp_drv_cb.BREADY 	<= data2duv.BREADY;
	    
	    vif.inp_drv_cb.ARADDR 	<= data2duv.ARADDR;
	    vif.inp_drv_cb.ARPORT  	<= data2duv.ARPORT;
	    vif.inp_drv_cb.ARVALID	<= data2duv.ARVALID;
	    
	    vif.inp_drv_cb.RREADY	<= data2duv.RREADY;
	end
 	endtask
endclass
