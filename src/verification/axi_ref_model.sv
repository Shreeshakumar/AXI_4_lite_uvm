`uvm_analysis_imp_decl(_mon)
class axi_ref_model extends uvm_component;
  `uvm_component_utils(axi_ref_model)
  uvm_analysis_imp_mon #(trans, axi_ref_model) mon_export;
  uvm_analysis_port #(trans) exp_port;

  bit [31:0] mem [16]; 

  function new(string name="axi_ref_model", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_export = new("mon_export", this);
    exp_port = new("exp_port", this);
    foreach(mem[i]) mem[i] = 32'h0;
  endfunction

  virtual function void write_mon(trans t);
    trans exp = trans::type_id::create("exp");
    exp.copy(t);
    if (t.txn_sel[`TXN_BIT_WRITE]) process_write(exp);
    else if (t.txn_sel[`TXN_BIT_READ]) process_read(exp);
    exp_port.write(exp);
  endfunction

  function void process_write(trans txn);
    bit [3:0] word_idx = txn.AWADDR[5:2]; 
    if (txn.AWADDR[1:0] != 2'b00) txn.BRESP = `AXI_SLVERR;
    else if (txn.AWADDR > 32'h3F) txn.BRESP = `AXI_DECERR;
    else if (word_idx >= 10 && word_idx <= 12) txn.BRESP = `AXI_SLVERR; 
    else begin
      txn.BRESP = `AXI_OKAY;
      if (txn.WSTRB[0]) mem[word_idx][7:0]   = txn.WDATA[7:0];
      if (txn.WSTRB[1]) mem[word_idx][15:8]  = txn.WDATA[15:8];
      if (txn.WSTRB[2]) mem[word_idx][23:16] = txn.WDATA[23:16];
      if (txn.WSTRB[3]) mem[word_idx][31:24] = txn.WDATA[31:24];
    end
  endfunction

  function void process_read(trans txn);
    bit [3:0] word_idx = txn.ARADDR[5:2];
    if (txn.ARADDR[1:0] != 2'b00) txn.RRESP = `AXI_SLVERR;
    else if (txn.ARADDR > 32'h3F) txn.RRESP = `AXI_DECERR;
    else if (word_idx >= 13 && word_idx <= 14) txn.RRESP = `AXI_SLVERR;
    else begin
      txn.RRESP  = `AXI_OKAY;
      txn.RDATA = mem[word_idx];
    end
  endfunction
endclass
