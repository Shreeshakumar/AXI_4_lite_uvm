QUESTA := /fetools/synopsys/source/source.sh
SHELL := /bin/csh
T ?= "test_reset"
V ?= UVM_NONE
UCDB ?= $(T)

# ANSI Colors
RED     := \033[1;31m
GREEN   := \033[1;32m
YELLOW  := \033[1;33m
BLUE    := \033[1;34m
MAGENTA := \033[1;35m
CYAN    := \033[1;36m
RESET   := \033[0m

COLORIZE = perl -pe '\
s/Error/\e[1;31m$$&\e[0m/g;   			\s/ERROR/\e[1;31m$$&\e[0m/g; \
s/Warning/\e[1;33m$$&\e[0m/g; 			\s/WARNING/\e[1;33m$$&\e[0m/g; \
s/Fatal/\e[1;35m$$&\e[0m/g;   			\s/FATAL/\e[1;35m$$&\e[0m/g; \
s/Passes\b/\e[1;92m$$&\e[0m/g; 			\s/Passed\b/\e[1;92m$$&\e[0m/g; \
s/Failed/\e[1;31m$$&\e[0m/g; 			\s/Failes/\e[1;31m$$&\e[0m/g; \
s/axi_drv/\e[1;32m$$&\e[0m/g; 	\
s/alu_act_mon/\e[1;36m$$&\e[0m/g; \
s/alu_pas_mon/\e[1;34m$$&\e[0m/g;\
s/waiting/\e[1;36m$$&\e[0m/g; \
s/waited/\e[1;34m$$&\e[0m/g; \
s/reference/\e[1;95m$$&\e[0m/g; \
s/DUV_DUV/\e[1;95m$$&\e[0m/g; \
s/axi_scrbd/\e[1;95m$$&\e[0m/g; \
s/shreeshakumar/\e[1;97m$$&\e[0m/g; \
s/\bMATCH\b/\e[1;92m$$&\e[0m/g; \
s/\bMISMATCH\b/\e[1;91m$$&\e[0m/g; '

.ONESHELL:	
all:
	make com
	make sim
	make cov
	make pu
	
cc:
	make com T=$(T) V=$(V)
	make sim T=$(T) V=$(V)

com:
	@echo "\t\t\t\t$(RED)........................................................ COMPILING CODE .........................................................$(RESET)"
	source $(QUESTA)
	vcs -V -R -full64 -sverilog +v2k +UVM_TESTNAME=test_reset +UVM_VERBOSITY=UVM_MEDIUM -debug_access+all -ntb_opts uvm-1.2 src/verification/axi_top.sv -o src/simulation/output1 -l src/simulation/vcs.log -cm line+tgl+cond+fsm+branch |& $(COLORIZE)
	
sim:
	@echo "\t\t\t\t$(CYAN)................................................... SIMULATING TEST = $(TEST) ...................................................$(RESET)"
	source $(QUESTA)
	./output1 |& $(COLORIZE)

cov:
	@echo "\t\t\t\t$(MAGENTA).................................................... CREATING COVERAGE REPORT ...................................................$(RESET)"
	source $(QUESTA)
	verdi -cov output1.vdb |& $(COLORIZE)
	
pu:
	@echo "\t\t\t\t$(GREEN)....................................................... PUSHING TO GIT REPO ......................................................$(RESET)"
	git add --all
	git commit -m 'commit via make pu'
	git push |& $(COLORIZE)

check:
	@echo "\t\t\t\t$(CYAN)........................................................ CHECKING SERVER USERS .....................................................$(RESET)"
	source $(QUESTA)
	lmstat -A |& $(COLORIZE)
