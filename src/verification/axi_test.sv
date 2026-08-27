class axi_test extends uvm_test;
	`uvm_component_utils(axi_test)

 	axi_env 	env_h;
 	axi_config 	m_cfg;

 	function new(string name="axi_test",uvm_component parent); super.new(name,parent); endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

  		m_cfg=axi_config::type_id::create("m_cfg");
  		env_h=axi_env::type_id::create("env_h",this);
  		
  		if(!uvm_config_db#(virtual axi_interface)::get(this,"","vif",m_cfg.vif))
		`uvm_fatal(get_type_name,"Can't get the interface from config_db")
  				
  			m_cfg.input_agent_is_active  = UVM_ACTIVE;
  			m_cfg.output_agent_is_active = UVM_PASSIVE;

  		uvm_config_db#(axi_config)::set(this,"*","axi_config",m_cfg);
 	endfunction

 	function void end_of_elaboration_phase(uvm_phase phase);
  		super.end_of_elaboration_phase(phase);
   		uvm_top.print_topology();
	endfunction
	
	
	virtual task reset_duv();
	begin
		rst_seq ss;
		ss=rst_seq::type_id::create("ss");
		ss.start(env_h.inp_agt_h.seqr_h);
	end
	endtask
endclass

class test_reset extends axi_test;
	`uvm_component_utils(test_reset)			rst_seq seq;
 	function new(string name="test_reset",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); reset_duv(); repeat(20)begin	seq=rst_seq::type_id::create("seq");		seq.start(env_h.act_agt_h.seqr_h);	end 	#21;	phase.drop_objection(this);
 	endtask
endclass
