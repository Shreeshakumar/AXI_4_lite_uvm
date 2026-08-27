class rst_seq extends uvm_sequence #(trans);
	`uvm_object_utils(rst_seq) 
 	function new(string name="rst_seq"); super.new(name); endfunction
 	task body();
     	begin req=trans::type_id::create("req");	start_item(req);	assert(req.randomize() with {ARESETn==1'd1;														});	finish_item(req);	end	
	endtask
endclass
