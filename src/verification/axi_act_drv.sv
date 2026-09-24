class axi_act_drv extends uvm_driver#(trans);
	`uvm_component_utils(axi_act_drv)

	virtual axi_interface.DRV vif;
	axi_config m_cfg;
	
  	trans wr_req_q[$], rd_req_q[$];
  	trans aw_q[$], w_q[$], ar_q[$], b_q[$], r_q[$];

 	function new(string name="axi_act_drv",uvm_component parent);
		super.new(name,parent);
 	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
   		if(!uvm_config_db#(axi_config)::get(this,"","axi_config",m_cfg))
			`uvm_fatal(get_type_name(),"Input_Driver Getting Failed")
 	endfunction

 	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
 		vif=m_cfg.vif;
 	endfunction

 	task run_phase(uvm_phase phase);
    	reset_signals();
		@(vif.drv_cb);
    	//wait (vif.drv_cb.ARESETn === 1'b1);
    	fork
      		dispatch();
      		write_manager();
      		read_manager();
      		aw_thread();
      		w_thread();
      		ar_thread();
      		b_thread();
      		r_thread();
    	join
	endtask
	
	virtual task dispatch();
    	forever begin
     		trans req;
      		seq_item_port.get_next_item(req);
      		if (req.txn_sel[`TXN_BIT_WRITE]) wr_req_q.push_back(req);
      		if (req.txn_sel[`TXN_BIT_READ])  rd_req_q.push_back(req);
      		`uvm_info("DISPATCH_TRACE", $sformatf("Queued item, txn_sel=%0b, data=%h %h", req.txn_sel,req.WDATA,req.WDATA ), UVM_FULL)
      		seq_item_port.item_done();
    	end
  	endtask

  	virtual task write_manager();
    	forever begin
    	 	trans r;
    	  	wait (wr_req_q.size() > 0);
    	  	r = wr_req_q.pop_front();
    	  	aw_q.push_back(r); w_q.push_back(r); b_q.push_back(r);
    	  	wait (aw_q.size() == 0 && w_q.size() == 0 && b_q.size() == 0);
    	end
  	endtask

  	virtual task read_manager();
    	forever begin
    	  	trans r;
    	  	wait (rd_req_q.size() > 0);
    	  	r = rd_req_q.pop_front();
    	  	ar_q.push_back(r); r_q.push_back(r);
      		wait (ar_q.size() == 0 && r_q.size() == 0);
    	end
  	endtask

  	virtual task aw_thread();
    	forever begin
    	  	trans r;
    	  	wait (aw_q.size() > 0);
    	  	r = aw_q.pop_front();
    	  	repeat (r.wait_cfg_vector[3:0]) @(vif.drv_cb);
    	  	vif.drv_cb.AWADDR  <= r.AWADDR;
    	  	vif.drv_cb.AWPROT  <= r.AWPROT;
    	  	vif.drv_cb.AWVALID <= 1;
    	  	do @(vif.drv_cb); while (!vif.drv_cb.AWREADY);
    	  	vif.drv_cb.AWVALID <= 0;
    	  	`uvm_info("AW_TRACE", "AW handshake done", UVM_FULL)
    	end
  	endtask

  	virtual task w_thread();
    	forever begin
    	  	trans r;
    	  	wait (w_q.size() > 0);
    	  	r = w_q.pop_front();
    		  	repeat (r.wait_cfg_vector[7:4]) @(vif.drv_cb);
      		vif.drv_cb.WDATA  <= r.WDATA;
      		vif.drv_cb.WSTRB  <= r.WSTRB;
      		vif.drv_cb.WVALID <= 1;
      		do @(vif.drv_cb); while (!vif.drv_cb.WREADY);
      		vif.drv_cb.WVALID <= 0;
    	end
  	endtask

  	virtual task ar_thread();
    	forever begin
    	  	trans r;
    	  	wait (ar_q.size() > 0);
    	  	r = ar_q.pop_front();
    	  	repeat (r.wait_cfg_vector[11:8]) @(vif.drv_cb);
    	 	vif.drv_cb.ARADDR  <= r.ARADDR;
    	  	vif.drv_cb.ARPROT  <= r.ARPROT;
    	  	vif.drv_cb.ARVALID <= 1;
    	  	do @(vif.drv_cb); while (!vif.drv_cb.ARREADY);
    	  	vif.drv_cb.ARVALID <= 0;
    	  	`uvm_info("AR_TRACE", "AR handshake done", UVM_FULL)
    	end
  	endtask

  	virtual task b_thread();
    	forever begin
    	  	trans r;
    	  	wait (b_q.size() > 0);
    	  	r = b_q.pop_front();
    	  	repeat (r.wait_cfg_vector[15:12]) @(vif.drv_cb);
    	  	vif.drv_cb.BREADY <= 1;
    	  	do @(vif.drv_cb); while (!vif.drv_cb.BVALID);
    	  	vif.drv_cb.BREADY <= 0;
    	 	`uvm_info("B_TRACE", "B handshake done", UVM_FULL)
    	end
  	endtask

  	virtual task r_thread();
    	forever begin
    	  	trans r;
    	  	wait (r_q.size() > 0);
    	  	r = r_q.pop_front();
    	  	repeat (r.wait_cfg_vector[19:16]) @(vif.drv_cb);
    	  	vif.drv_cb.RREADY <= 1;
    	  	do @(vif.drv_cb); while (!vif.drv_cb.RVALID);
    	  	vif.drv_cb.RREADY <= 0;
    	  	`uvm_info("R_TRACE", "R handshake done", UVM_FULL)
    	end
  	endtask

  	virtual task reset_signals();
    	vif.drv_cb.AWVALID <= 0;
    	vif.drv_cb.WVALID  <= 0;
    	vif.drv_cb.ARVALID <= 0;
    	vif.drv_cb.BREADY  <= 0;
   		vif.drv_cb.RREADY  <= 0;
  	endtask
 	
endclass


