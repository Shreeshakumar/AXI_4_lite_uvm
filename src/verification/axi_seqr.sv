class axi_seqr extends uvm_sequencer#(trans);
	`uvm_component_utils(axi_seqr)

 function new(string name="axi_seqr",uvm_component parent);
	super.new(name,parent);
 endfunction

endclass
