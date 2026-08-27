QUESTA := /home/share/questa.csh
SHELL := /bin/csh
T ?= axi_test
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
	vlog -sv +acc +cover +fcover -l src/simulation/log_file.log src/verification/axi_top.sv |& $(COLORIZE)
	
sim:
	@echo "\t\t\t\t$(CYAN)................................................... SIMULATING TEST = $(TEST) ...................................................$(RESET)"
	source $(QUESTA)
	vsim -vopt work.alu_top -voptargs=+acc=npr +UVM_TESTNAME=$(T) +UVM_VERBOSITY=$(V) -assertdebug -l src/simulation/log_file.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll src/simulation/ucdb_file.ucdb; run -all; exit" |& $(COLORIZE)

cov:
	@echo "\t\t\t\t$(MAGENTA).................................................... CREATING COVERAGE REPORT ...................................................$(RESET)"
	source $(QUESTA)
	vcover report -html src/simulation/ucdb_file.ucdb -htmldir src/simulation/covReport -details |& $(COLORIZE)
	
regression:
	@echo "$(GREEN)==================== STARTING REGRESSION ====================$(RESET)"
	make sim T=test_reset V=$(V) UCDB=test_reset
	make sim T=test_arithmetic V=$(V) UCDB=test_arithmetic
	make sim T=test_arithmetic_max V=$(V) UCDB=test_arithmetic_max
	make sim T=test_arithmetic_min V=$(V) UCDB=test_arithmetic_min
	make sim T=test_logical V=$(V) UCDB=test_logical
	make sim T=test_logical_max V=$(V) UCDB=test_logical_max
	make sim T=test_logical_min V=$(V) UCDB=test_logical_min
	make sim T=test_err_cycle V=$(V) UCDB=test_err_cycle
	make sim T=test_cycle V=$(V) UCDB=test_cycle
	@echo "$(GREEN)==================== REGRESSION COMPLETE ====================$(RESET)"
	
merge_cov:
	@echo "$(YELLOW)==================== MERGING COVERAGE ====================$(RESET)"
	source $(QUESTA)
	vcover merge src/simulation/regression.ucdb src/simulation/regression/*.ucdb |& $(COLORIZE)
	
covv:
	@echo "\t\t\t\t$(MAGENTA).................................................... CREATING COVERAGE REPORT ...................................................$(RESET)"
	source $(QUESTA)
	vcover report -html src/simulation/regression.ucdb \
		-htmldir src/simulation/covReport \
		-details |& $(COLORIZE)
	
pu:
	@echo "\t\t\t\t$(GREEN)....................................................... PUSHING TO GIT REPO ......................................................$(RESET)"
	git add --all
	git commit -m 'commit via make'
	git push |& $(COLORIZE)

check:
	@echo "\t\t\t\t$(CYAN)........................................................ CHECKING SERVER USERS .....................................................$(RESET)"
	source $(QUESTA)
	lmstat -A |& $(COLORIZE)
