class axi_scrbd extends uvm_scoreboard;
	`uvm_component_utils(axi_scrbd)
	trans in_txn, out_mon, inn, reff, p;

	trans q[$];

	uvm_tlm_analysis_fifo #(trans)act_mon_fifo;
	uvm_tlm_analysis_fifo #(trans)pas_mon_fifo;
	
	uvm_tlm_analysis_fifo #(trans) act_fifo;
  uvm_tlm_analysis_fifo #(trans) exp_fifo;
	
	int pass_count, fail_count, pass, fail;

	function new(string name="axi_scrbd",uvm_component parent);
		super.new(name,parent);
		act_mon_fifo=new("act_mon_fifo",this);
		pas_mon_fifo=new("pas_mon_fifo",this);
    	act_fifo = new("act_fifo", this);
    	exp_fifo = new("exp_fifo", this);
	endfunction

	task run_phase(uvm_phase phase);
    trans act, exp;
    bit match;
    
    forever begin
      exp_fifo.get(exp); 
      act_fifo.get(act);
      match = 1; 

      if ((act.RRESP !== exp.RRESP) || (act.BRESP !== exp.BRESP))  begin
        `uvm_error("SCB_FAIL", $sformatf("RESP Mismatch. Act: %0h, Exp: %0h | act %0h, exp %0h", act.BRESP, exp.BRESP, act.RRESP, exp.RRESP))
        if(act.txn_sel[`TXN_BIT_READ]) begin
          `uvm_error("SCB_FAIL", $sformatf("During Read Mismatch at Addr %0h. Act Data: %0h, Exp Data: %0h", act.ARADDR, act.RDATA, exp.RDATA))        
        end
        else begin
          `uvm_error("SCB_FAIL", $sformatf("During Write Mismatch at Addr %0h. Act Data: %0h, Exp Data: %0h", act.AWADDR, act.WDATA, exp.WDATA))        
        end
        match = 0;
      end
      
      if (act.txn_sel[`TXN_BIT_READ] && (act.RRESP == `AXI_OKAY)) begin
        if (act.RDATA !== exp.RDATA) begin
          `uvm_error("SCB_FAIL", $sformatf("RDATA Mismatch at Addr %0h. Act: %0h, Exp: %0h", act.ARADDR, act.RDATA, exp.RDATA))
          match = 0;
        end
      end
      
      if (match) begin
        if (act.txn_sel[`TXN_BIT_WRITE]) begin
          `uvm_info("SCB_PASS", $sformatf("WRITE PASS -> Addr: %0h | Data: %0h | RESP: %0h", act.AWADDR, act.WDATA, act.BRESP), UVM_HIGH)
        end
        if (act.txn_sel[`TXN_BIT_READ]) begin
          `uvm_info("SCB_PASS", $sformatf("READ PASS  -> Addr: %0h | RDATA: %0h | RESP: %0h", act.ARADDR, act.RDATA, act.RRESP), UVM_HIGH)
        end
      end
      
      $display(match);
      
    end
          $display("finals boss %d",match);
	endtask

endclass
