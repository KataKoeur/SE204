#
.PHONY: clean all simu_batch compile simu_gui info

# WORK_DIR est le répertoire de simulation
WORK_DIR = $(shell pwd)/work

# TOPDIR est le répertoire principal
TOPDIR = $(shell pwd)/../..

# Le module top a simuler
TB_TOP = testbench_top

# Les répertoires contenant les sources sont toujours de la forme
# <nom_du_module>/src ou <nom_du_macro_module>/src
#
DIRS = ${TOPDIR}/wb16_sdram16/src ${TOPDIR}/wb16_sdram16/tb_src ${TOPDIR}/wb16_sdram16/tb_src  ${TOPDIR}/../wshb_if ${TOPDIR}/../wshb_if/testbench ${TOPDIR}/wb16_sdram16/local_testbench

# Les sources sont dans ces répertoires
# Attention, on a besoins de la définition du bus wishbone
SOURCES = $(wildcard ${TOPDIR}/wb16_sdram16/src/*.sv ${TOPDIR}/wb16_sdram16/tb_src/*.sv ${TOPDIR}/wb16_sdram16/tb_src/*.sv ${TOPDIR}/../wshb_if/*.sv ${TOPDIR}/../wshb_if/testbench/*.sv ${TOPDIR}/wb16_sdram16/local_testbench/*.sv)


# D'ou les cibles pour la compilation
TARGETS = $(addprefix ${WORK_DIR}/.,$(notdir $(SOURCES:%.sv=.%.compiled)))

aa:
	@echo ${TARGETS}

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
	cd $(WORK_DIR) ; vsim  -batch -t 1ps -lib work $(TB_TOP) -do "run -all ; quit"

simu_gui: compile
	cd $(WORK_DIR); vsim -t 1ps -lib work $(TB_TOP) 

compile: $(TARGETS) 

$(WORK_DIR)/.%.compiled: %.sv | $(WORK_DIR)
	cd $(WORK_DIR) ; vlog  +acc -timescale "1ns/1ps" $< 
	touch $@

$(WORK_DIR):
	mkdir $(WORK_DIR) 


clean:
	rm -rf $(WORK_DIR)

# Les interfaces on besoin du générateur de paquets
$(WORK_DIR)/.wshb_m.compiled:$(WORK_DIR)/.packet.compiled
$(WORK_DIR)/.wshb_s.compiled:$(WORK_DIR)/.packet.compiled
$(WORK_DIR)/.test.compiled:$(WORK_DIR)/.wshb_m.compiled
$(WORK_DIR)/.test.compiled:$(WORK_DIR)/.wshb_s.compiled
$(WORK_DIR)/.wb16_sdram16.compiled:$(WORK_DIR)/.sdram_if.compiled


