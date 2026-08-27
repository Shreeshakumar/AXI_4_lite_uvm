class axi_pas_agnt extends uvm_agent;
	`uvm_component_utils(axi_pas_agnt)

	axi_pas_mon pas_mon_h;
    axi_config `m_cfg;

   	function new(string name="axi_pas_agnt",uvm_component parent);
		super.new(name,parent);
   	endfunction

  	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
    
  		if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m_cfg))
			`uvm_fatal(get_type_name(),"Output_agt Getting Failed")
    	if(m_cfg.output_agent_is_active==UVM_PASSIVE)
    		pas_mon_h=axi_pas_mon::type_id::create("pas_mon_h",this); 
  	endfunction
endclass
