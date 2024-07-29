
VERILOG_SRC=$(wildcard ../rtl/*.*v)  
TESTBENCH_SRC=$(wildcard ../testbench/*.*v)
DPI_SRC=$(wildcard ../dpi/*.c) 
DW_SRC_PATH=/mnt/apps/public/COE/synopsys_apps/syn/T-2022.03-SP4/dw/sim_ver
DW_SRC=$(shell find ${DW_SRC_PATH} -name "DW_fp*.v" -printf "%p ")
EPSILON_MULT_TEST=1.0
NUMBER_OF_TEST=4
INFO_LEVEL?=0
TIMEOUT=10000000

build-dw:
	/bin/bash -c "vlog ${DW_SRC} "	

build:
	/bin/bash -c "vlog -sv +incdir+../testbench $(TESTBENCH_SRC) $(VERILOG_SRC) $(DPI_SRC)"	

eval: build
	mkdir -p logs logs/test 
	/bin/bash -c "vsim -c -voptargs=+acc tb_top +TIMEOUT=${TIMEOUT} +num_of_testcases=${NUMBER_OF_TEST} +epsilon_mult=${EPSILON_MULT_TEST}  +input_dir=../inputs +info_level=${INFO_LEVEL} -do \"run -all\" | tee logs/output.log "
	grep -r "INFO" logs/output.log > logs/INFO.log
	grep -r "INFO" logs/output.log | grep  Result > logs/RESULTS.log

debug: build
	/bin/bash -c "vsim -voptargs=+acc tb_top +TIMEOUT=${TIMEOUT} +num_of_testcases=${NUMBER_OF_TEST} +epsilon_mult=${EPSILON_MULT_TEST}  +input_dir=../inputs/ " 


clean:
	rm -rf work logs results transcript
