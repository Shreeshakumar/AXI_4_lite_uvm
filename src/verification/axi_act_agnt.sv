class axi_act_agnt extends uvm_agent;
	`uvm_component_utils(axi_act_agnt)

  	axi_act_drv dr_h;
  	axi_act_mon act_mon_h;
  	axi_seqr 	seqr_h;
  	axi_config 	m_cfg;

   	function new(string name="axi_act_agnt",uvm_component parent);
		super.new(name,parent);
   	endfunction

  	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
    
  		if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m_cfg))
			`uvm_fatal(get_type_name(),"Input_agt Getting Failed")

    	act_mon_h=axi_act_mon::type_id::create("act_mon_h",this);

    	if(m_cfg.input_agent_is_active==UVM_ACTIVE)
    	begin
    		dr_h=axi_act_drv::type_id::create("dr_h",this);
    		seqr_h=axi_seqr::type_id::create("seqr_h",this);
	    end
	endfunction

 	function void connect_phase(uvm_phase phase);
		if(m_cfg.input_agent_is_active==UVM_ACTIVE)
	    begin
			dr_h.seq_item_port.connect(seqr_h.seq_item_export);
	    end
 	endfunction
endclass
