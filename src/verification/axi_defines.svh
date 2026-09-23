    `define DATA_WIDTH   32
    `define ADDR_WIDTH   32
    `define MEM_DEPTH    16
   	`define DEFAULT_PROT 00
   	
   	`define AXI_OKAY 2'b00
	`define AXI_EXOKAY 2'b01
	`define AXI_SLVERR 2'b10
	`define AXI_DECERR 2'b11
	
	`define TXN_BIT_WRITE 0
	`define TXN_BIT_READ 1
