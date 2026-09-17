package axi_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	
	`include "src/verification/axi_defines.svh"
	`include "src/verification/axi_trans.sv"
	`include "src/verification/axi_config.sv"
	`include "src/verification/axi_seqr.sv"
	`include "src/verification/axi_act_drv.sv"
	`include "src/verification/axi_act_mon.sv"
	`include "src/verification/axi_pas_mon.sv"
	`include "src/verification/axi_pas_agnt.sv"
	`include "src/verification/axi_act_agnt.sv"
	`include "src/verification/axi_scrbd.sv"
	`include "src/verification/axi_subr.sv"
	`include "src/verification/axi_env.sv"
	`include "src/verification/axi_seq.sv"
	`include "src/verification/axi_test.sv"
endpackage
