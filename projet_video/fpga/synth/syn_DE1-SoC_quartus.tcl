# Script de Synthèse en langage Tcl.


# Chargement des  paquets Quartus II
package require ::quartus::project
package require ::quartus::flow

# Le nom du module top sera celui du projet
set PROJET  $env(PROJET)

# On récupère le nom du répertoire principal du projet
# Utile dans le script de chargement des sources
set TOPDIR  $env(TOPDIR)

# N'ouvre un nouveau projet que s'il n'existe pas déjà
if {[project_exists ${PROJET}]} {
	project_open -revision ${PROJET} ${PROJET}
} else {
	project_new -revision ${PROJET} ${PROJET}
    set make_assignment 1
}

# On récupère le flag de configuration du Makefile
if [info exists env(make_assignment)] {
  set make_assignment $env(make_assignment)
  #puts "make_assignment $make_assignment"
}


# Compile un peu plus lentement mais optimise bien le design 
set fast_compile 0

# On utilise les processeurs ARM... ou non
set enable_hps 0
if {$enable_hps} {
	set_global_assignment -name VERILOG_MACRO "ENABLE_HPS"
}

# On récupère les contraintes et définitions
if {$make_assignment} {
        # Contraintes sur le FPGA choisi
        source "device_assignment.tcl"
        # Contraintes sur les entrées sorties
        source "pins_assignment.tcl"
        # Contraintes sur les timings
        set_global_assignment -name SDC_FILE timing_constraints.sdc
        # Liste des fichiers à compiler
        source "file_list.tcl"
        # Contraintes spécifiques au projet (comment synthétiser,..)
        source "project_assignment.tcl"
        # Commit assignments
        export_assignments
}
    #close stdout 
    fconfigure stdout -buffering none
	execute_flow -compile

	# Close project
	project_close

	exit
