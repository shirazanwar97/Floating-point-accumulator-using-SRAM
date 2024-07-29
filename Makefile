
TESTS=./inputs/test1.dat ./inputs/test2.dat ./inputs/test3.dat ./inputs/test4.dat

all: ${TESTS} 

%.dat: %.val
	python3 ./scripts/input_gen.py -t $@ -m $(shell cat $<)  

regen:
	python3 ./scripts/input_gen.py -i ./inputs/ -m "10 20 100 600"
