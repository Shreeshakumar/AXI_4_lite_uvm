class axi_env extends uvm_env;
	`uvm_component_utils(axi_env)
 
 	axi_act_agent 	act_agt_h;
 	axi_pas_agent 	pas_agt_h;
 	axi_scrbd 		sb_h;
 	axi_subr 		sub_h;

 	axi_config m_cfg;

 	function new(string name="axi_env",uvm_component parent);
		super.new(name,parent);
   	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

 		if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m_cfg))
			`uvm_fatal(get_type_name(),"Output_agt Getting Failed")`

  		act_agt_h	=axi_act_agnt	::type_id::create("act_agt_h",this);
  		pas_agt_h	=axi_pas_agnt	::type_id::create("pas_agt_h",this);
  		sb_h		=axi_scrbd		::type_id::create("sb_h",this);
  		sub_h		=axi_subr		::type_id::create("sub_h",this);
 	endfunction

 	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		act_agt_h.act_mon_h.act_mon_port.connect(sb_h.act_mon_fifo.analysis_export);
		pas_agt_h.pas_mon_h.pas_mon_port.connect(sb_h.pas_mon_fifo.analysis_export);
		act_agt_h.act_mon_h.act_mon_port.connect(sub_h.analysis_export);
 	endfunction
endclass
  

	
  

