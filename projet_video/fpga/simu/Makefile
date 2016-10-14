# Squelette de Makefile pour le projet Video
#
.PHONY: clean all simu_batch compile simu_gui info

# WORKDIR est le répertoire de simulation
WORKDIR = $(shell pwd)/work
# TOPDIR est le répertoire principal (le dépot git de vos travaux)
TOPDIR = $(shell pwd)/../..

# Le module top a simuler
TB_TOP = tb_fpga

#VPATH := ${TOPDIR} ${TOPDIR}/.. 


# Module sources
SRCDIR    = $(TOPDIR)/fpga/src
SRC       = $(wildcard $(SRCDIR)/*.sv)
DEP      += $(patsubst $(SRCDIR)/%.sv,$(WORKDIR)/.%.compiled,${SRC})

# Module testbench sources
TBDIR     = $(TOPDIR)/fpga/tb_src
TBSRC     = $(wildcard $(TBDIR)/*.sv)
DEP      += $(patsubst $(TBDIR)/%.sv,$(WORKDIR)/.%.compiled,${TBSRC})


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
	cd $(WORKDIR) ; vsim  -batch -t 1ps -lib work $(TB_TOP) -do "run -all ; quit"

simu_gui: compile
	cd $(WORKDIR); vsim -t 1ps -lib work $(TB_TOP) 

compile: $(DEP) 

$(WORKDIR)/.%.compiled: $(TBDIR)/%.sv | $(WORKDIR)/work
	cd $(WORKDIR) ; vlog  +acc +define+SIMULATION $< 
	touch $@

$(WORKDIR)/.%.compiled: $(SRCDIR)/%.sv | $(WORKDIR)/work
	cd $(WORKDIR) ; vlog  +acc +define+SIMULATION $< 
	touch $@


$(WORKDIR):
	mkdir $(WORKDIR) 

$(WORKDIR)/work: $(WORKDIR)
	cd $(WORKDIR) ; vlib work

clean:
	rm -rf $(WORKDIR)

