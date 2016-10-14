SHELL:=/bin/bash -O extglob
# Le nom du projet doit être le nom du module de plus haut niveau
export PROJET = fpga
export TOPDIR = $(shell pwd)/../..

.PHONY: all clean program nodb syn

# Pour colorier les logs en fonction de la nature des Infos
colorize = sed  -e "s/Error/\x1b[31mError/" -e "s/Info/\x1b[32mInfo/" -e "s/Warning/\x1b[34mWarning/"

all:
	@echo "make all    : ce message..."
	@echo "make syn    : lancement de la synthèse"
	@echo "make log    : affichage du fichier de log de la synthèse"
	@echo "make program: programmation du fpga, n'oubliez pas de brancher et d'allumer la carte..."
	@echo "make clean  : nettoyage du répertoire"

# Teste l'existance  de la base de donnée de synthèse de manière
# a préparer une variable d'environnement pour le script de synthèse
ifneq "$(wildcard db )" ""
  # if directory db exists:
  SYNDEP = db
  export make_assignment := 0
else
  # if it doesn't:
  SYNDEP =
  export make_assignment := 1
endif

# On forcera le script de synthèse a charger les définitions
# du projet si les scripts TCL ont été changés
db: *.tcl
	$(eval export make_assignment := 1)

# Synthèse
# On appele explicitement la synthèse. Avec ou non
# ordre de remettre a jour les definitions du projet.
# stdbuf -o0 : pour donner empecher le pipe d'être bufferisé
# tee : pour créer à la fois un fichier de log et une sortie console
# colorize : quartus supprime la colorisation s'il y a un pipe, donc on la fait nous même
syn:  $(SYNDEP) 
	@stdbuf -o0 quartus_sh -t syn_DE1-SoC_quartus.tcl | stdbuf -o0 tee syn.log | stdbuf -o0 $(colorize)

# Affichage colorisé du fichier de log
log: syn.log
	@cat $< | ${colorize} | less

program:
	quartus_pgm -c DE-SoC -m jtag  -o "p;${PROJET}.sof@2" -o "s;SOCVHPS@1"	

clean:
	@rm -rf !(*.tcl|Makefile|*.backup|*.sdc|*.gitignore)
