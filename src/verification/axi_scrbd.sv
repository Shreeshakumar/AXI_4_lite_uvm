class axi_scrbd extends uvm_scoreboard;
	`uvm_component_utils(axi_scrbd)
	trans in_txn, out_mon, inn, reff, p;

	trans q[$];

	uvm_tlm_analysis_fifo #(trans)act_mon_fifo;
	uvm_tlm_analysis_fifo #(trans)pas_mon_fifo;
	
	int pass_count, fail_count, pass, fail;

	function new(string name="axi_scrbd",uvm_component parent);
		super.new(name,parent);
		act_mon_fifo=new("act_mon_fifo",this);
		pas_mon_fifo=new("pas_mon_fifo",this);
	endfunction

	task run_phase(uvm_phase phase);
		reff =new;	p =new; q.push_back(reff);  reff =new; p.res='d0;
		
		begin  end
		
		forever	begin	in_txn = new;	inp_mon_fifo.get(in_txn); 	q.push_back(in_txn);
      		
    	end
	endtask
	
	task check_data(trans reff, trans ch);
	begin
		bit check=1;
		$write("\t");
	   	if(reff.AWREADY !== ch.AWREADY)	begin $write(" AWREADY "); 	fail_count++; check=0; end else pass_count++;
	   	
       	if(reff.WREADY 	!== ch.WREADY)	begin $write(" WREADY "); 	fail_count++; check=0; end else	pass_count++;
       	
 	   	if(reff.BRESP 	!== ch.BRESP)	begin $write(" BRESP "); 	fail_count++; check=0; end else	pass_count++;
	   	if(reff.BVALID 	!== ch.BVALID)	begin $write(" OFLOW ");	fail_count++; check=0; end else	pass_count++;
	   	
      	if(reff.ARREADY !== ch.ARREADY)	begin $write(" ARREADY "); 	fail_count++; check=0; end else	pass_count++;
      	
	   	if(reff.RDATA 	!== ch.RDATA)	begin $write(" RDATA "); 	fail_count++; check=0; end else	pass_count++;
        if(reff.PRESP 	!== ch.PRESP)	begin $write(" PRESP "); 	fail_count++; check=0; end else pass_count++;
        if(reff.RVALID 	!== ch.RVALID)	begin $write(" RVALID "); 	fail_count++; check=0; end else pass_count++;
        
	   	if (check) 		begin $write("\tMATCH"); pass++; end else begin $write("  MISMATCH"); fail++; end
	end
 	endtask

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("SCB_SUMMARY", $sformatf("====== SCOREBOARD REPORT ====== Passed: %0d | Failed: %0d", pass_count, fail_count), UVM_NONE)
		`uvm_info("SCB_SUMMARY", $sformatf("=== FINAL SCOREBOARD REPORT === Passes: %0d | Failes: %0d", pass, fail), UVM_NONE)
	endfunction
endclass
