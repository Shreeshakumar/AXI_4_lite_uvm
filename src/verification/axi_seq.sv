class rst_seq extends uvm_sequence #(trans);
	`uvm_object_utils(rst_seq) 
 	function new(string name="rst_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {ARESETn==1'd1;														});	finish_item(req);	end	
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {ARESETn==1'd0;														});	finish_item(req);	end	
	endtask
endclass

class wr_rw_access_seq extends uvm_sequence #(trans);
`uvm_object_utils(wr_rw_access_seq) 
 	function new(string name="wr_rw_access_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR inside {[32'h00000000:32'h00000024]}; 																									AWADDR[1:0] == 2'b00; WSTRB != 4'h0;								});	finish_item(req);	end	
	endtask
endclass

class axi_random_seq extends uvm_sequence #(trans);
`uvm_object_utils(axi_random_seq) 
 	function new(string name="axi_random_seq"); super.new(name); endfunction
 	task body();
     	repeat (500) begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel != 2'b00;													});	finish_item(req);	end	
	endtask
endclass


class wr_wo_access_seq extends uvm_sequence #(trans);
`uvm_object_utils(wr_wo_access_seq) 
 	function new(string name="wr_wo_access_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR inside {[32'h00000034:32'h00000038]}; 																									AWADDR[1:0] == 2'b00; WSTRB != 4'h0;								});	finish_item(req);	end	
	endtask
endclass

class wr_special_addr_seq extends uvm_sequence #(trans);
`uvm_object_utils(wr_special_addr_seq) 
 	function new(string name="wr_special_addr_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR == 32'h0000003C; WSTRB != 4'h0;								});	finish_item(req);	end	
	endtask
endclass

class write_read_only_seq extends uvm_sequence #(trans);
`uvm_object_utils(write_read_only_seq) 
 	function new(string name="write_read_only_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR inside {[32'h00000028:32'h00000030]}; 																									AWADDR[1:0] == 2'b00; WSTRB != 4'h0;								});	finish_item(req);	end	
	endtask
endclass

class invalid_write_seq extends uvm_sequence #(trans);
`uvm_object_utils(invalid_write_seq) 
 	function new(string name="invalid_write_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR inside {[32'h00000040:32'hFFFFFFFF]}; 																									AWADDR[1:0] == 2'b00; WSTRB != 4'h0;								});	finish_item(req);	end	
	endtask
endclass

class unaligned_write_seq extends uvm_sequence #(trans);
`uvm_object_utils(unaligned_write_seq) 
 	function new(string name="unaligned_write_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR inside {[32'h00000000:32'h0000003C]}; 																									AWADDR[1:0] != 2'b00; WSTRB != 4'h0;								});	finish_item(req);	end	
	endtask
endclass

class rd_sequence extends uvm_sequence #(trans);
`uvm_object_utils(rd_sequence) 
 	function new(string name="rd_sequence"); super.new(name); endfunction
 	task body();
     	bit [31:0] addr;
     	addr = ($urandom_range(9, 0)) << 2;
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR == addr; WSTRB == 4'hF;								});	finish_item(req);	end	
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b10; ARADDR == addr; wait_cfg_vector[11:8] == 4'h8;								});	finish_item(req);	end	
	endtask
endclass

class rd_ro_access_seq extends uvm_sequence #(trans);
`uvm_object_utils(rd_ro_access_seq) 
 	function new(string name="rd_ro_access_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b10; ARADDR inside {[32'h00000028:32'h00000030]}; 																									ARADDR[1:0] == 2'b00;								});	finish_item(req);	end	
	endtask
endclass

class rd_special_addr_seq extends uvm_sequence #(trans);
`uvm_object_utils(rd_special_addr_seq) 
 	function new(string name="rd_special_addr_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b10; ARADDR == 32'h0000003C;								});	finish_item(req);	end	
	endtask
endclass

class read_write_only_seq extends uvm_sequence #(trans);
`uvm_object_utils(read_write_only_seq) 
 	function new(string name="read_write_only_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b10; ARADDR inside {[32'h00000034:32'h00000038]}; 																									ARADDR[1:0] == 2'b00;								});	finish_item(req);	end	
	endtask
endclass

class invalid_read_seq extends uvm_sequence #(trans);
`uvm_object_utils(invalid_read_seq) 
 	function new(string name="invalid_read_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b10; ARADDR inside {[32'h00000040:32'hFFFFFFFF]}; 																									ARADDR[1:0] == 2'b00;								});	finish_item(req);	end	
	endtask
endclass

class unaligned_read_seq extends uvm_sequence #(trans);
`uvm_object_utils(unaligned_read_seq) 
 	function new(string name="unaligned_read_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b10; ARADDR inside {[32'h00000000:32'h0000003C]}; 																									ARADDR[1:0] != 2'b00;								});	finish_item(req);	end	
	endtask
endclass

class aw_before_w_seq extends uvm_sequence #(trans);
`uvm_object_utils(aw_before_w_seq) 
 	function new(string name="aw_before_w_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR inside {[32'h00000000:32'h00000024]}; 																									AWADDR[1:0] == 2'b00; WSTRB != 4'h0; wait_cfg_vector[3:0] == 4'h0; wait_cfg_vector[7:4] == 4'h8;								});	finish_item(req);	end	
	endtask
endclass

class aw_addr_retain_seq extends uvm_sequence #(trans);
`uvm_object_utils(aw_addr_retain_seq) 
 	function new(string name="aw_addr_retain_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR inside {[32'h00000000:32'h00000024]}; 																									AWADDR[1:0] == 2'b00; WSTRB != 4'h0; wait_cfg_vector[3:0] == 4'h0; wait_cfg_vector[7:4] == 4'hF;								});	finish_item(req);	end	
	endtask
endclass

class w_before_aw_seq extends uvm_sequence #(trans);
`uvm_object_utils(w_before_aw_seq) 
 	function new(string name="w_before_aw_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR inside {[32'h00000000:32'h00000024]}; 																									AWADDR[1:0] == 2'b00; WSTRB != 4'h0; wait_cfg_vector[7:4] == 4'h0; wait_cfg_vector[3:0] == 4'h8;								});	finish_item(req);	end	
	endtask
endclass

class w_data_retain_seq extends uvm_sequence #(trans);
`uvm_object_utils(w_data_retain_seq) 
 	function new(string name="w_data_retain_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR inside {[32'h00000000:32'h00000024]}; 																									AWADDR[1:0] == 2'b00; WSTRB != 4'h0; wait_cfg_vector[7:4] == 4'h0; wait_cfg_vector[3:0] == 4'hF;								});	finish_item(req);	end	
	endtask
endclass

class aw_w_same_cycle_seq extends uvm_sequence #(trans);
`uvm_object_utils(aw_w_same_cycle_seq) 
 	function new(string name="aw_w_same_cycle_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR inside {[32'h00000000:32'h00000024]}; 																									AWADDR[1:0] == 2'b00; WSTRB != 4'h0; wait_cfg_vector[3:0] == 4'h0; wait_cfg_vector[7:4] == 4'h0;								});	finish_item(req);	end	
	endtask
endclass

class backpressure_sequence extends uvm_sequence #(trans);
`uvm_object_utils(backpressure_sequence) 
 	function new(string name="backpressure_sequence"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR inside {[32'h00000000:32'h00000024]}; 																									AWADDR[1:0] == 2'b00; WSTRB != 4'h0; wait_cfg_vector[15:12] == 4'hF;								});	finish_item(req);	end	
	endtask
endclass

class bp_r_seq extends uvm_sequence #(trans);
`uvm_object_utils(bp_r_seq) 
 	function new(string name="bp_r_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b10; ARADDR inside {[32'h00000000:32'h00000024]}; 																									ARADDR[1:0] == 2'b00; wait_cfg_vector[19:16] == 4'hF;								});	finish_item(req);	end	
	endtask
endclass

class simultaneous_read_write_seq extends uvm_sequence #(trans);
`uvm_object_utils(simultaneous_read_write_seq) 
 	function new(string name="simultaneous_read_write_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b11; AWADDR inside {[32'h00000000:32'h00000024]}; ARADDR inside {[32'h00000000:32'h00000024]}; 																									AWADDR[1:0] == 2'b00; ARADDR[1:0] == 2'b00; WSTRB != 4'h0;								});	finish_item(req);	end	
	endtask
endclass

class con_br_independent_seq extends uvm_sequence #(trans);
`uvm_object_utils(con_br_independent_seq) 
 	function new(string name="con_br_independent_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b11; AWADDR inside {[32'h00000000:32'h00000024]}; ARADDR inside {[32'h00000000:32'h00000024]}; 																									AWADDR[1:0] == 2'b00; ARADDR[1:0] == 2'b00; WSTRB != 4'h0; wait_cfg_vector[15:12] == 4'hF; wait_cfg_vector[19:16] == 4'h0;								});	finish_item(req);	end	
	endtask
endclass

class rand_awprot_seq extends uvm_sequence #(trans);
`uvm_object_utils(rand_awprot_seq) 
 	function new(string name="rand_awprot_seq"); super.new(name); endfunction
 	task body();
     	repeat (100) begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR inside {[32'h00000000:32'hFFFFFFFF]}; WSTRB != 4'h0;								});	finish_item(req);	end	
	endtask
endclass

class rand_arprot_seq extends uvm_sequence #(trans);
`uvm_object_utils(rand_arprot_seq) 
 	function new(string name="rand_arprot_seq"); super.new(name); endfunction
 	task body();
     	repeat (100) begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b10; ARADDR inside {[32'h00000000:32'hFFFFFFFF]};								});	finish_item(req);	end	
	endtask
endclass

class rand_wdata_wstrb_seq extends uvm_sequence #(trans);
`uvm_object_utils(rand_wdata_wstrb_seq) 
 	function new(string name="rand_wdata_wstrb_seq"); super.new(name); endfunction
 	task body();
     	repeat (100) begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {txn_sel == 2'b01; AWADDR inside {[32'h00000000:32'h00000024]}; AWADDR[1:0] == 2'b00;								});	finish_item(req);	end	
	endtask
endclass
