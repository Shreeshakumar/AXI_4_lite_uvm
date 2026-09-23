SHELL = /bin/bash

VCS = vcs
SIMV = ./simv
URG = urg

SRC_DIR = src/verification
SIM_DIR = src/simulation

# Absolute paths so sources can still be found after we `cd` into SIM_DIR
ABS_SRC_DIR = $(CURDIR)/$(SRC_DIR)

SRC = \
	$(ABS_SRC_DIR)/axi_top.sv

VCS_FLAGS = -full64 \
	-sverilog \
	-ntb_opts uvm \
	-debug_access+all \
	+incdir+$(ABS_SRC_DIR) \
	-cm line+cond+fsm+tgl+branch

#========================================================
# COLORS
#========================================================

RED     := $(shell printf '\033[1;31m')
GREEN   := $(shell printf '\033[1;32m')
YELLOW  := $(shell printf '\033[1;33m')
BLUE    := $(shell printf '\033[1;34m')
MAGENTA := $(shell printf '\033[1;35m')
CYAN    := $(shell printf '\033[1;36m')
WHITE   := $(shell printf '\033[1;37m')
RESET   := $(shell printf '\033[0m')

#========================================================
# OUTPUT COLORIZATION
#========================================================

COLORIZE = perl -pe '\
s/Error/\e[1;31m$$&\e[0m/g; \
s/ERROR/\e[1;31m$$&\e[0m/g; \
s/Warning/\e[1;33m$$&\e[0m/g; \
s/WARNING/\e[1;33m$$&\e[0m/g; \
s/Fatal/\e[1;35m$$&\e[0m/g; \
s/FATAL/\e[1;35m$$&\e[0m/g; \
s/Passes\b/\e[1;92m$$&\e[0m/g; \
s/Passed\b/\e[1;92m$$&\e[0m/g; \
s/Failed/\e[1;31m$$&\e[0m/g; \
s/Failes/\e[1;31m$$&\e[0m/g; \
s/MATCH\b/\e[1;92m$$&\e[0m/g; \
s/MISMATCH\b/\e[1;91m$$&\e[0m/g; \
s/axi_drv/\e[1;32m$$&\e[0m/g; \
s/axi_act_drv/\e[1;32m$$&\e[0m/g; \
s/axi_monitor/\e[1;36m$$&\e[0m/g; \
s/axi_scrbd/\e[1;95m$$&\e[0m/g; \
s/reference/\e[1;95m$$&\e[0m/g; \
s/waiting/\e[1;36m$$&\e[0m/g; \
s/waited/\e[1;34m$$&\e[0m/g; \
s/DUV_DUV/\e[1;95m$$&\e[0m/g;'

#========================================================
# TESTS
# Automatically extract test class names from axi_test.sv
#========================================================

TEST_FILE = $(SRC_DIR)/axi_test.sv

TESTS := $(shell grep -E '^[[:space:]]*class[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]+extends' $(TEST_FILE) | \
	sed -E 's/^[[:space:]]*class[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*).*/\1/')

SEEDS = 101 102 103

VERBOSITY_LEVELS = UVM_NONE UVM_LOW UVM_MEDIUM UVM_HIGH UVM_FULL UVM_DEBUG

#========================================================
# TARGETS
#========================================================

.PHONY: all compile regression test coverage clean \
        push pull status check help

all: regression coverage

#========================================================
# COMPILE
#========================================================
# All build artifacts (build, cm.log, coverage, csrc,
# .fsm.sch.verilog.xml, logs, simv, simv.daidir, ucli.key,
# vc_hdrs.h, ...) are created under $(SIM_DIR).
#========================================================

compile:
	@mkdir -p $(SIM_DIR)/build $(SIM_DIR)/logs $(SIM_DIR)/coverage
	@echo ""
	@echo "$(BLUE)============================================================$(RESET)"
	@echo "$(BLUE)                    COMPILING CODE$(RESET)"
	@echo "$(BLUE)============================================================$(RESET)"
	@echo "$(CYAN)Source : $(SRC)$(RESET)"
	@echo "$(CYAN)Sim dir: $(SIM_DIR)$(RESET)"
	@echo "$(CYAN)Output : $(SIM_DIR)/simv$(RESET)"
	@echo ""
	# NOTE: vcs is run from the project root (NOT $(SIM_DIR)) because
	# axi_top.sv uses `include "src/verification/..." with a path that
	# is relative to the project root. Outputs that VCS lets us redirect
	# via flags go straight into $(SIM_DIR); the few files VCS always
	# drops in cwd regardless (vc_hdrs.h, ucli.key, cm.log,
	# .fsm.sch.verilog.xml, DVEfiles) are moved there right after.
	csh -c 'source /fetools/synopsys/source/source.sh; \
	$(VCS) $(VCS_FLAGS) \
	-cm_dir $(SIM_DIR)/coverage/simv.vdb \
	-Mdir=$(SIM_DIR)/csrc \
	$(SRC) \
	-top axi_top \
	-o $(SIM_DIR)/simv \
	-l $(SIM_DIR)/logs/compile.log' |& $(COLORIZE)
	@for f in vc_hdrs.h ucli.key cm.log .fsm.sch.verilog.xml DVEfiles; do \
		if [ -e "$$f" ]; then mv -f "$$f" $(SIM_DIR)/; fi; \
	done
	@echo ""
	@echo "$(GREEN)Compilation completed.$(RESET)"
	@echo ""

#========================================================
# REGRESSION
#========================================================

regression: compile

	@echo ""
	@echo "$(CYAN)============================================================$(RESET)"
	@echo "$(CYAN)                 AXI4-LITE UVM REGRESSION$(RESET)"
	@echo "$(CYAN)============================================================$(RESET)"
	@echo "$(YELLOW)Test file : $(TEST_FILE)$(RESET)"
	@echo "$(YELLOW)Tests     : $(words $(TESTS))$(RESET)"
	@echo "$(YELLOW)Seeds     : $(SEEDS)$(RESET)"
	@echo ""

	@echo "$(GREEN)Discovered tests:$(RESET)"
	@for test in $(TESTS); do \
		echo "  $$test"; \
	done

	@echo ""

	@fail_count=0; pass_count=0; failed_list=""; \
	scb_pass_grand=0; scb_fail_grand=0; \
	for test in $(TESTS); do \
		for seed in $(SEEDS); do \
			echo ""; \
			echo "$(BLUE)------------------------------------------$(RESET)"; \
			echo "$(CYAN)TEST = $$test$(RESET)"; \
			echo "$(CYAN)SEED = $$seed$(RESET)"; \
			echo "$(BLUE)------------------------------------------$(RESET)"; \
			rm -rf $(SIM_DIR)/coverage/$${test}_$${seed}.vdb; \
			set -o pipefail; \
			csh -c 'source /fetools/synopsys/source/source.sh; \
			cd $(SIM_DIR); \
			$(SIMV) \
				+UVM_TESTNAME='$$test' \
				+ntb_random_seed='$$seed' \
				-cm line+cond+fsm+tgl+branch \
				-cm_dir coverage/'$$test'_'$$seed'.vdb \
				-l logs/'$$test'_'$$seed'.log' > /dev/null 2>&1; \
			status=$$?; \
			echo "$(MAGENTA)Scoreboard results:$(RESET)"; \
			grep -E '\[SCB_(PASS|FAIL)\]' $(SIM_DIR)/logs/$${test}_$${seed}.log | $(COLORIZE); \
			scb_pass=$$(grep -cE '\[SCB_PASS\]' $(SIM_DIR)/logs/$${test}_$${seed}.log); \
			scb_fail=$$(grep -cE '\[SCB_FAIL\]' $(SIM_DIR)/logs/$${test}_$${seed}.log); \
			echo "$(YELLOW)Scoreboard total for $$test seed $$seed -> PASS: $$scb_pass  FAIL: $$scb_fail$(RESET)"; \
			scb_pass_grand=$$((scb_pass_grand+scb_pass)); \
			scb_fail_grand=$$((scb_fail_grand+scb_fail)); \
			if [ $$status -ne 0 ]; then \
				echo "$(RED)FAILED: $$test seed $$seed (simv exit $$status)$(RESET)"; \
				fail_count=$$((fail_count+1)); \
				failed_list="$$failed_list $${test}_$${seed}"; \
			elif [ $$scb_fail -ne 0 ] || \
			     grep -qE 'UVM_FATAL\s*:\s*[1-9][0-9]*' $(SIM_DIR)/logs/$${test}_$${seed}.log || \
			     grep -qE 'UVM_ERROR\s*:\s*[1-9][0-9]*' $(SIM_DIR)/logs/$${test}_$${seed}.log; then \
				echo "$(RED)FAILED: $$test seed $$seed (scoreboard/UVM_ERROR/UVM_FATAL reported)$(RESET)"; \
				fail_count=$$((fail_count+1)); \
				failed_list="$$failed_list $${test}_$${seed}"; \
			else \
				echo "$(GREEN)PASSED: $$test seed $$seed$(RESET)"; \
				pass_count=$$((pass_count+1)); \
			fi; \
		done; \
	done; \
	echo ""; \
	echo "$(YELLOW)============================================================$(RESET)"; \
	echo "$(YELLOW)                   REGRESSION SUMMARY$(RESET)"; \
	echo "$(YELLOW)============================================================$(RESET)"; \
	echo "$(GREEN)Tests Passed : $$pass_count$(RESET)"; \
	echo "$(RED)Tests Failed : $$fail_count$(RESET)"; \
	echo "$(GREEN)Scoreboard PASS (all tests) : $$scb_pass_grand$(RESET)"; \
	echo "$(RED)Scoreboard FAIL (all tests) : $$scb_fail_grand$(RESET)"; \
	if [ $$fail_count -ne 0 ]; then \
		echo "$(RED)Failed tests:$$failed_list$(RESET)"; \
	fi; \
	echo "$$fail_count" > $(SIM_DIR)/logs/.regression_fail_count; \
	true

	@echo ""
	@echo "$(GREEN)============================================================$(RESET)"
	@echo "$(GREEN)                 REGRESSION COMPLETED$(RESET)"
	@echo "$(GREEN)============================================================$(RESET)"
	@echo ""
	@if [ -s $(SIM_DIR)/logs/.regression_fail_count ] && [ "$$(cat $(SIM_DIR)/logs/.regression_fail_count)" != "0" ]; then \
		echo "$(RED)Regression finished with failures  see summary above.$(RESET)"; \
		echo ""; \
	fi

#========================================================
# RUN A SINGLE SELECTED TEST
#========================================================

test: compile
	@echo ""
	@echo "$(CYAN)============================================================$(RESET)"
	@echo "$(CYAN)                 SELECT A TEST TO RUN$(RESET)"
	@echo "$(CYAN)============================================================$(RESET)"
	@i=1; \
	for t in $(TESTS); do \
		echo "  $(YELLOW)$$i)$(RESET) $$t"; \
		i=$$((i+1)); \
	done; \
	echo ""; \
	read -p "Enter test number: " tchoice; \
	selected=$$(echo $(TESTS) | tr ' ' '\n' | sed -n "$${tchoice}p"); \
	if [ -z "$$selected" ]; then \
		echo "$(RED)Invalid selection: $$tchoice$(RESET)"; \
		exit 1; \
	fi; \
	echo ""; \
	echo "$(YELLOW)Selected test : $$selected$(RESET)"; \
	\
	echo ""; \
	echo "$(CYAN)============================================================$(RESET)"; \
	echo "$(CYAN)                 SELECT A SEED$(RESET)"; \
	echo "$(CYAN)============================================================$(RESET)"; \
	i=1; \
	for s in $(SEEDS); do \
		echo "  $(YELLOW)$$i)$(RESET) $$s"; \
		i=$$((i+1)); \
	done; \
	echo "  $(YELLOW)c)$(RESET) Enter a custom seed value"; \
	echo ""; \
	read -p "Enter seed number (or 'c' for custom): " schoice; \
	if [ "$$schoice" = "c" ]; then \
		read -p "Enter custom seed value: " seed; \
	else \
		seed=$$(echo $(SEEDS) | tr ' ' '\n' | sed -n "$${schoice}p"); \
	fi; \
	if [ -z "$$seed" ]; then \
		echo "$(RED)Invalid seed selection: $$schoice$(RESET)"; \
		exit 1; \
	fi; \
	echo ""; \
	echo "$(YELLOW)Selected seed : $$seed$(RESET)"; \
	\
	echo ""; \
	echo "$(CYAN)============================================================$(RESET)"; \
	echo "$(CYAN)                 SELECT VERBOSITY$(RESET)"; \
	echo "$(CYAN)============================================================$(RESET)"; \
	i=1; \
	for v in $(VERBOSITY_LEVELS); do \
		echo "  $(YELLOW)$$i)$(RESET) $$v"; \
		i=$$((i+1)); \
	done; \
	echo ""; \
	read -p "Enter verbosity number [default: UVM_FULL]: " vchoice; \
	if [ -z "$$vchoice" ]; then \
		verbosity=UVM_FULL; \
	else \
		verbosity=$$(echo $(VERBOSITY_LEVELS) | tr ' ' '\n' | sed -n "$${vchoice}p"); \
		if [ -z "$$verbosity" ]; then \
			echo "$(RED)Invalid verbosity selection: $$vchoice$(RESET)"; \
			exit 1; \
		fi; \
	fi; \
	echo ""; \
	echo "$(YELLOW)Selected verbosity : $$verbosity$(RESET)"; \
	\
	echo ""; \
	echo "$(BLUE)------------------------------------------$(RESET)"; \
	echo "$(CYAN)TEST      = $$selected$(RESET)"; \
	echo "$(CYAN)SEED      = $$seed$(RESET)"; \
	echo "$(CYAN)VERBOSITY = $$verbosity$(RESET)"; \
	echo "$(BLUE)------------------------------------------$(RESET)"; \
	rm -rf $(SIM_DIR)/coverage/$${selected}_$${seed}.vdb; \
	set -o pipefail; \
	csh -c 'source /fetools/synopsys/source/source.sh; \
	cd $(SIM_DIR); \
	$(SIMV) \
		+UVM_TESTNAME='$$selected' \
		+ntb_random_seed='$$seed' \
		+UVM_VERBOSITY='$$verbosity' \
		-cm line+cond+fsm+tgl+branch \
		-cm_dir coverage/'$$selected'_'$$seed'.vdb \
		-l logs/'$$selected'_'$$seed'.log' |& $(COLORIZE); \
	status=$$?; \
	echo "$(MAGENTA)Scoreboard results:$(RESET)"; \
	grep -E '\[SCB_(PASS|FAIL)\]' $(SIM_DIR)/logs/$${selected}_$${seed}.log | $(COLORIZE); \
	scb_pass=$$(grep -cE '\[SCB_PASS\]' $(SIM_DIR)/logs/$${selected}_$${seed}.log); \
	scb_fail=$$(grep -cE '\[SCB_FAIL\]' $(SIM_DIR)/logs/$${selected}_$${seed}.log); \
	echo "$(YELLOW)Scoreboard total for $$selected seed $$seed -> PASS: $$scb_pass  FAIL: $$scb_fail$(RESET)"; \
	echo ""; \
	echo "$(YELLOW)============================================================$(RESET)"; \
	echo "$(YELLOW)                 SELECTED TEST SUMMARY$(RESET)"; \
	echo "$(YELLOW)============================================================$(RESET)"; \
	echo "$(CYAN)Test      : $$selected$(RESET)"; \
	echo "$(CYAN)Seed      : $$seed$(RESET)"; \
	echo "$(CYAN)Verbosity : $$verbosity$(RESET)"; \
	if [ $$status -ne 0 ]; then \
		echo "$(RED)Result    : FAILED (simv exit $$status)$(RESET)"; \
	elif [ $$scb_fail -ne 0 ] || \
	     grep -qE 'UVM_FATAL\s*:\s*[1-9][0-9]*' $(SIM_DIR)/logs/$${selected}_$${seed}.log || \
	     grep -qE 'UVM_ERROR\s*:\s*[1-9][0-9]*' $(SIM_DIR)/logs/$${selected}_$${seed}.log; then \
		echo "$(RED)Result    : FAILED (scoreboard/UVM_ERROR/UVM_FATAL reported)$(RESET)"; \
	else \
		echo "$(GREEN)Result    : PASSED$(RESET)"; \
	fi; \
	echo "$(GREEN)Scoreboard PASS : $$scb_pass$(RESET)"; \
	echo "$(RED)Scoreboard FAIL : $$scb_fail$(RESET)"; \
	echo ""

#========================================================
# COVERAGE MERGE
#========================================================

coverage:
	@echo ""
	@echo "$(MAGENTA)============================================================$(RESET)"
	@echo "$(MAGENTA)                  MERGING COVERAGE$(RESET)"
	@echo "$(MAGENTA)============================================================$(RESET)"
	@echo ""

	@rm -rf $(SIM_DIR)/merged
	@mkdir -p $(SIM_DIR)/merged

	csh -c 'source /fetools/synopsys/source/source.sh; \
	cd $(SIM_DIR); \
	$(URG) \
	-dir coverage/*.vdb \
	-report merged' |& $(COLORIZE)

	@echo ""
	@echo "$(GREEN)============================================================$(RESET)"
	@echo "$(GREEN)                COVERAGE REPORT CREATED$(RESET)"
	@echo "$(GREEN)============================================================$(RESET)"
	@echo "$(CYAN)Report: $(SIM_DIR)/merged/dashboard.html$(RESET)"
	@echo ""

#========================================================
# GIT PUSH
#========================================================

push:
	@echo ""
	@echo "$(GREEN)============================================================$(RESET)"
	@echo "$(GREEN)                    PUSHING TO GIT$(RESET)"
	@echo "$(GREEN)============================================================$(RESET)"
	@echo ""

	@echo "$(CYAN)Adding files...$(RESET)"
	git add --all

	@echo "$(CYAN)Committing changes...$(RESET)"
	git commit -m "commit via make push"

	@echo "$(CYAN)Pushing to remote repository...$(RESET)"
	git push |& $(COLORIZE)

	@echo ""
	@echo "$(GREEN)Git push completed.$(RESET)"
	@echo ""

#========================================================
# GIT PULL
#========================================================

pull:
	@echo ""
	@echo "$(CYAN)============================================================$(RESET)"
	@echo "$(CYAN)                    PULLING FROM GIT$(RESET)"
	@echo "$(CYAN)============================================================$(RESET)"
	@echo ""

	git pull |& $(COLORIZE)

	@echo ""
	@echo "$(GREEN)Git pull completed.$(RESET)"
	@echo ""

#========================================================
# GIT STATUS
#========================================================

status:
	@echo ""
	@echo "$(YELLOW)============================================================$(RESET)"
	@echo "$(YELLOW)                     GIT STATUS$(RESET)"
	@echo "$(YELLOW)============================================================$(RESET)"
	@echo ""

	git status

	@echo ""

#========================================================
# SERVER / LICENSE CHECK
#========================================================

check:
	@echo ""
	@echo "$(CYAN)============================================================$(RESET)"
	@echo "$(CYAN)                 CHECKING SERVER / LICENSE$(RESET)"
	@echo "$(CYAN)============================================================$(RESET)"
	@echo ""

	csh -c 'source /fetools/synopsys/source/source.sh; \
	lmstat -A' |& $(COLORIZE)

	@echo ""

#========================================================
# CLEAN
#========================================================
# Removes everything VCS/URG create under $(SIM_DIR):
# build, cm.log, coverage, csrc, .fsm.sch.verilog.xml,
# logs, simv, simv.daidir, ucli.key, vc_hdrs.h, DVEfiles
#========================================================

clean:
	@echo ""
	@echo "$(RED)============================================================$(RESET)"
	@echo "$(RED)                     CLEANING BUILD$(RESET)"
	@echo "$(RED)============================================================$(RESET)"
	@echo ""

	rm -rf \
		$(SIM_DIR)/build \
		$(SIM_DIR)/cm.log \
		$(SIM_DIR)/coverage \
		$(SIM_DIR)/csrc \
		$(SIM_DIR)/.fsm.sch.verilog.xml \
		$(SIM_DIR)/logs \
		$(SIM_DIR)/simv \
		$(SIM_DIR)/simv.daidir \
		$(SIM_DIR)/ucli.key \
		$(SIM_DIR)/vc_hdrs.h \
		$(SIM_DIR)/DVEfiles

	@echo "$(GREEN)Clean completed.$(RESET)"
	@echo ""

#========================================================
# HELP
#========================================================

help:
	@echo ""
	@echo "$(CYAN)============================================================$(RESET)"
	@echo "$(CYAN)                    AVAILABLE COMMANDS$(RESET)"
	@echo "$(CYAN)============================================================$(RESET)"
	@echo ""
	@echo "$(GREEN)make compile$(RESET)     - Compile the AXI4-Lite UVM environment"
	@echo "$(GREEN)make regression$(RESET)  - Run all tests with all seeds"
	@echo "$(GREEN)make test$(RESET)        - Pick one test, one seed, and a verbosity, then run it"
	@echo "$(GREEN)make coverage$(RESET)    - Merge coverage databases"
	@echo "$(GREEN)make all$(RESET)         - Run regression and coverage"
	@echo ""
	@echo "$(GREEN)make push$(RESET)        - Git add, commit and push"
	@echo "$(GREEN)make pull$(RESET)        - Git pull"
	@echo "$(GREEN)make status$(RESET)      - Show Git status"
	@echo "$(GREEN)make check$(RESET)       - Check Synopsys licenses/server"
	@echo "$(GREEN)make clean$(RESET)       - Remove generated files (under $(SIM_DIR))"
	@echo "$(GREEN)make help$(RESET)        - Show this help"
	@echo ""
	@echo "$(CYAN)============================================================$(RESET)"
