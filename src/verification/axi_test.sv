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
   		//uvm_top.print_topology();
	endfunction
	
	virtual task reset_duv();
		begin
			rst_seq ss;
			ss=rst_seq::type_id::create("ss");
			ss.start(env_h.act_agt_h.seqr_h);
		end
	endtask
endclass

class test_reset extends axi_test;
	`uvm_component_utils(test_reset)			rst_seq seq;
 	function new(string name="test_reset",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); reset_duv(); repeat(20)begin	seq=rst_seq::type_id::create("seq");			seq.start(env_h.act_agt_h.seqr_h);	end 	#21;	phase.drop_objection(this);
 	endtask
endclass

class wr_wo_access_test extends axi_test;
	`uvm_component_utils(wr_wo_access_test)			wr_wo_access_seq seq;
 	function new(string name="wr_wo_access_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=wr_wo_access_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class wr_special_addr_test extends axi_test;
	`uvm_component_utils(wr_special_addr_test)			wr_special_addr_seq seq;
 	function new(string name="wr_special_addr_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=wr_special_addr_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class write_read_only_test extends axi_test;
	`uvm_component_utils(write_read_only_test)			write_read_only_seq seq;
 	function new(string name="write_read_only_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=write_read_only_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class invalid_write_test extends axi_test;
	`uvm_component_utils(invalid_write_test)			invalid_write_seq seq;
 	function new(string name="invalid_write_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=invalid_write_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class unaligned_write_test extends axi_test;
	`uvm_component_utils(unaligned_write_test)			unaligned_write_seq seq;
 	function new(string name="unaligned_write_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=unaligned_write_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class rd_sequence_test extends axi_test;
	`uvm_component_utils(rd_sequence_test)			rd_sequence seq;
 	function new(string name="rd_sequence_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=rd_sequence::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class rd_ro_access_test extends axi_test;
	`uvm_component_utils(rd_ro_access_test)			rd_ro_access_seq seq;
 	function new(string name="rd_ro_access_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=rd_ro_access_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class rd_special_addr_test extends axi_test;
	`uvm_component_utils(rd_special_addr_test)			rd_special_addr_seq seq;
 	function new(string name="rd_special_addr_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=rd_special_addr_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class read_write_only_test extends axi_test;
	`uvm_component_utils(read_write_only_test)			read_write_only_seq seq;
 	function new(string name="read_write_only_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=read_write_only_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class invalid_read_test extends axi_test;
	`uvm_component_utils(invalid_read_test)			invalid_read_seq seq;
 	function new(string name="invalid_read_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=invalid_read_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class unaligned_read_test extends axi_test;
	`uvm_component_utils(unaligned_read_test)			unaligned_read_seq seq;
 	function new(string name="unaligned_read_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=unaligned_read_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class aw_before_w_test extends axi_test;
	`uvm_component_utils(aw_before_w_test)			aw_before_w_seq seq;
 	function new(string name="aw_before_w_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=aw_before_w_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class aw_addr_retain_test extends axi_test;
	`uvm_component_utils(aw_addr_retain_test)			aw_addr_retain_seq seq;
 	function new(string name="aw_addr_retain_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=aw_addr_retain_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class w_before_aw_test extends axi_test;
	`uvm_component_utils(w_before_aw_test)			w_before_aw_seq seq;
 	function new(string name="w_before_aw_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=w_before_aw_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class w_data_retain_test extends axi_test;
	`uvm_component_utils(w_data_retain_test)			w_data_retain_seq seq;
 	function new(string name="w_data_retain_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=w_data_retain_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class aw_w_same_cycle_test extends axi_test;
	`uvm_component_utils(aw_w_same_cycle_test)			aw_w_same_cycle_seq seq;
 	function new(string name="aw_w_same_cycle_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=aw_w_same_cycle_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class backpressure_sequence_test extends axi_test;
	`uvm_component_utils(backpressure_sequence_test)			backpressure_sequence seq;
 	function new(string name="backpressure_sequence_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=backpressure_sequence::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class bp_r_test extends axi_test;
	`uvm_component_utils(bp_r_test)			bp_r_seq seq;
 	function new(string name="bp_r_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=bp_r_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class simultaneous_read_write_test extends axi_test;
	`uvm_component_utils(simultaneous_read_write_test)			simultaneous_read_write_seq seq;
 	function new(string name="simultaneous_read_write_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=simultaneous_read_write_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class con_br_independent_test extends axi_test;
	`uvm_component_utils(con_br_independent_test)			con_br_independent_seq seq;
 	function new(string name="con_br_independent_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=con_br_independent_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class rand_awprot_test extends axi_test;
	`uvm_component_utils(rand_awprot_test)			rand_awprot_seq seq;
 	function new(string name="rand_awprot_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=rand_awprot_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#5000;	phase.drop_objection(this);
 	endtask
endclass

class rand_arprot_test extends axi_test;
	`uvm_component_utils(rand_arprot_test)			rand_arprot_seq seq;
 	function new(string name="rand_arprot_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=rand_arprot_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#5000;	phase.drop_objection(this);
 	endtask
endclass

class rand_wdata_wstrb_test extends axi_test;
	`uvm_component_utils(rand_wdata_wstrb_test)			rand_wdata_wstrb_seq seq;
 	function new(string name="rand_wdata_wstrb_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=rand_wdata_wstrb_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#5000;	phase.drop_objection(this);
 	endtask
endclass

/*
class wr_rw_access_test extends axi_test;
	`uvm_component_utils(wr_rw_access_test)			wr_rw_access_seq seq;
 	function new(string name="wr_rw_access_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=wr_rw_access_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	#100000;	phase.drop_objection(this);
 	endtask
endclass

class axi_random_test extends axi_test;
	`uvm_component_utils(axi_random_test)			axi_random_seq seq;
 	function new(string name="axi_random_test",uvm_component parent); super.new(name,parent); endfunction
 	task run_phase(uvm_phase phase);
		phase.raise_objection(this); uvm_top.set_timeout(20000ns); reset_duv(); repeat(20)begin	seq=axi_random_seq::type_id::create("seq");	seq.start(env_h.act_agt_h.seqr_h);	end 	 #20000;	phase.drop_objection(this);
 	endtask
endclass
*/
