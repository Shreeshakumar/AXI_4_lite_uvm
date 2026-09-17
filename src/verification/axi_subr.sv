class axi_subr extends uvm_subscriber #(trans);
  `uvm_component_utils(axi_subr)

  trans req;

  covergroup axi_cg;
    option.per_instance = 1;
    option.name = "AXI_Coverage";

    cp_waddr: coverpoint req.AWADDR {
      bins a = {1'b1};
      bins b    = {1'b0};
    }
    
  endgroup

  	function new(string name = "axi_subr", uvm_component parent = null);
   		super.new(name, parent);
    	axi_cg = new();
  endfunction

  virtual function void write(trans t);
    req = t;
    axi_cg.sample();
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COV", $sformatf("ALU Input Coverage: %0.2f%%", axi_cg.get_coverage()), UVM_NONE);
  endfunction

endclass
