QUESTA := /home/share/questa.csh
SHELL := /bin/csh
TEST ?= nco_regression_test
V ?= UVM_LOW

.ONESHELL:	
all:
	source $(QUESTA)
	make clean
	make compile
	make simulate
	vcover report -html nco_coverage.ucdb -htmldir covReport -details

clean:
	rm -rf work/ transcript vsim.wlf wave.vcd vsim_stacktrace.vstf
	rm -rf covReport nco_coverage.ucdb
	rm nco.log simulation.log
	rm nco_coverage.ucdb
	clear
	clear
	clear

compile:
	@echo "\t\t\t\t...............................COMPILING CODE..............................."
	source $(QUESTA)
	vlog -sv +acc +cover +fcover -l nco.log nco_top.sv 

wave:
	make compile
	@echo "\t\t\t\t\t...............GENERATING WAVEFORM FOR TEST = $(TEST)..............."
	vsim -novopt work.top +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(V)

simulate:
	@echo "\t\t\t\t...........................SIMULATING TEST = $(TEST) WITH VERBOSITY = $(V)..........................."
	vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll nco_coverage.ucdb; run -all; exit" +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(V)

view:
	firefox ./covReport/index.html
