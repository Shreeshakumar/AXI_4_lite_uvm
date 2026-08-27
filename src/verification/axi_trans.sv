class trans extends uvm_sequence_item;
	`uvm_object_utils(trans)

	//reset
	rand 	bit						ARESETn;
	
	//AXI WRITE ADDRESS
 	rand 	bit	[`ADDR_WIDTH-1:0]	AWADDR;
 	rand 	bit	[2:0]				AWPORT;
 	rand 	bit						AWVALID;
 		 	bit						AWREADY;
 	
 	//AXI WRITE DATA
 	rand 	bit	[DATA_WIDTH-1:0]	WDATA;
 	rand 	bit	[(DATA_WIDTH/8)-1:0] WSTRB;
 	rand 	bit						WVALID;
 		 	bit						WREADY;
 	
 	//AXI WRITE RESPONSE
 			bit	[1:0]				BRESP;
 		 	bit						BVALID;
 	rand 	bit						BREADY;
 	
 	//AXI READ ADDRESS
 	rand 	bit	[ADDR_WIDTH-1:0]	ARADDR;
 	rand 	bit	[1:0]				ARPORT;
 	rand 	bit						ARVALID;
 		 	bit						ARREADY;
 	
 	//AXI READ DATA
 		 	bit	[DATA_WIDTH-1:0]	RDATA;
 		 	bit	[1:0]				PRESP;
 		 	bit						RVALID;
	rand 	bit						RREADY;
 	
 	/*constraint temp{	soft OA dist {'d0 := 2, 'hFF := 2, ['h1:'hFE] :/ 6};
 						soft OB dist {'d0 := 2, 'hFF := 2, ['h1:'hFE] :/ 6}; }
 	*/
 	
 	function new(string name="trans");	super.new(name);	endfunction

 	virtual function void do_copy(uvm_object rhs);
		trans rhs_;
		if(!$cast(rhs_,rhs))
			`uvm_fatal("do_copy","cast of the rhs object failed")
		super.do_copy(rhs);
			this.ARESETn=rhs_.ARESETn;
			
			this.AWADDR=rhs_.AWADDR;
			this.AWPORT=rhs_.AWPORT;
			this.AWVALID=rhs_.AWVALID;
			this.AWREADY=rhs_.AWREADY;
			
			this.WDATA=rhs_.WDATA;
			this.WSTRB=rhs_.WSTRB;
			this.WVALID=rhs_.WVALID;
			this.WREADY=rhs_.WREADY;
			
			this.BRESP=rhs_.BRESP;
			this.BVALID=rhs_.BVALID;
			this.BREADY=rhs_.BREADY;
			
			this.ARADDR=rhs_.ARADDR;
			this.ARPORT=rhs_.ARPORT;
			this.ARVALID=rhs_.ARVALID;
			this.ARREADY=rhs_.ARREADY;
			
			this.RDATA=rhs_.RDATA;
			this.PRESP=rhs_.PRESP;
			this.RVALID=rhs_.RVALID;
			this.RREADY=rhs_.RREADY;
	endfunction
/*
	virtual function bit do_compare(uvm_object rhs,uvm_comparer comparer);
		alu_sequence_item rhs_;
		if(!$cast(rhs_,rhs))
		begin	`uvm_fatal("do_compare","cast of the rhs object failed")	return 0;	end 
		return
			super.do_compare(rhs,comparer)&&
			res==rhs_.res &&
			err==rhs_.err &&
			oflow==rhs_.oflow &&
			cout==rhs_.cout &&
			G==rhs_.G &&
			L==rhs_.L &&
			E==rhs_.E;
		endfunction
*/
	virtual function void do_print(uvm_printer printer);
		//super.do_print(printer);
		printer.print_field("ARESETn",this.ARESETn,1,UVM_HEX);
		
		printer.print_field("AWADDR",this.AWADDR,1,UVM_HEX);
		printer.print_field("AWPORT",this.AWPORT,8,UVM_HEX);
		printer.print_field("AWVALID",this.AWVALID,8,UVM_HEX);
		printer.print_field("AWREADY",this.AWREADY,2,UVM_BIN);
		
		printer.print_field("WDATA",this.WDATA,4,UVM_BIN);
		printer.print_field("WSTRB",this.WSTRB,1,UVM_HEX);
		printer.print_field("WVALID",this.WVALID,1,UVM_HEX);
		printer.print_field("WREADY",this.WREADY,1,UVM_HEX);
		
		printer.print_field("BRESP",this.BRESP,16,UVM_HEX);
		printer.print_field("BVALID",this.BVALID,1,UVM_HEX);
		printer.print_field("BREADY",this.BREADY,1,UVM_HEX);

		printer.print_field("ARADDR",this.ARADDR,1,UVM_HEX);
		printer.print_field("ARPORT",this.ARPORT,8,UVM_HEX);
		printer.print_field("ARVALID",this.ARVALID,8,UVM_HEX);
		printer.print_field("ARREADY",this.ARREADY,2,UVM_BIN);
		
		printer.print_field("RDATA",this.RDATA,4,UVM_BIN);
		printer.print_field("PRESP",this.PRESP,1,UVM_HEX);
		printer.print_field("RVALID",this.RVALID,1,UVM_HEX);
		printer.print_field("RREADY",this.RREADY,1,UVM_HEX);
	endfunction
	/*
	virtual function void inn_print(alu_sequence_item t);
		$write("   RST=%0b  CE=%0b  INP_VALID=%02b  MODE=%0b  CMD=%04b  OA=%02h(%03d)  OB=%02h(%03d)  CIN=%0b  ",
         			t.rst,   t.ce, 	 t.inp_valid,   t.mode,   t.cmd,   t.OA,t.OA,   t.OB,t.OB, 	  t.cin);
	endfunction
	
	virtual function void out_print(alu_sequence_item t);
		$display("  RES=%0h(%0d)  ERR=%0b  OFLOW=%0b  COUT=%0b  G=%0b  E=%0b  L=%0b",
         			t.res,t.res,  t.err,   t.oflow,   t.cout,   t.G,   t.E,   t.L);
	endfunction
	
	virtual function void print_both(alu_sequence_item r, alu_sequence_item o);
		$write("  RES=%04h/%04h(%05d/%05d)  ERR=%0b/%0b  OFLOW=%0b/%0b  COUT=%0b/%0b  G=%0b/%0b  E=%0b/%0b  L=%0b/%0b",
         			r.res,o.res,r.res,o.res,  r.err,o.err,   r.oflow,o.oflow,   r.cout,o.cout,   r.G,o.G,   r.E,o.E,   r.L,o.L);
	endfunction
*/
endclass 
