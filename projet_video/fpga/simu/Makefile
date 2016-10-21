#
.PHONY: clean all simu_batch compile simu_gui info

# WORK_DIR est le répertoire de simulation
WORK_DIR = $(shell pwd)/work

# TOPDIR est le répertoire principal (le dépot git de vos travaux)
TOPDIR = $(shell pwd)/../..

# Le module top a simuler
TB_TOP = tb_fpga

# Les répertoires contenant les sources sont toujours de la forme
# <nom_du_module>/src ou <nom_du_macro_module>/src
#
DIRS = $(wildcard ${TOPDIR}/*/src ${TOPDIR}/*/tb_src)

# Les sources sont dans ces répertoires
SOURCES = $(wildcard ${TOPDIR}/*/src/*.sv ${TOPDIR}/*/tb_src/*.sv)

# D'ou les cibles pour la compilation
TARGETS = $(addprefix ${WORK_DIR}/.,$(notdir $(SOURCES:%.sv=.%.compiled)))

# chemin des sources pour Make
vpath %.sv $(DIRS) 

## Les cibles
info: 
	@echo "Les commandes possibles sont:"
	@echo "make compile    : compilation des codes (module à tester et testbenchs)"
	@echo "make simu_batch : simulation en mode terminal, avec simple affichage des résultats des tests"
	@echo "make simu_gui   : simulation en mode graphique pour faire un debug de votre code."
	@echo "make all        : équivalent à simu_gui"
	@echo "make info       : ce message"
	@echo "make clean      : nettoyage des fichiers inutiles"

all: simu_batch

simu_batch: compile
	cd $(WORK_DIR) ; vsim  -batch -t 1ps -lib work -L altera_lnsim_ver $(TB_TOP) -do "run -all ; quit"

simu_gui: compile
	cd $(WORK_DIR); vsim -t 1ps -lib work -L altera_lnsim_ver $(TB_TOP) 

compile: $(TARGETS) 

$(WORK_DIR)/.%.compiled: %.sv | $(WORK_DIR)
	cd $(WORK_DIR) ; vlog  +acc +define+SIMULATION -timescale "1ns/1ps" $< 
	touch $@

$(WORK_DIR):
	mkdir $(WORK_DIR) 


clean:
	rm -rf $(WORK_DIR)

