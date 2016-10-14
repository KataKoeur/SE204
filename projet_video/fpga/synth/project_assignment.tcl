# Contraintes globales du projet
# Ici on autorise l'outil à optimiser les recompilations lorsqu'on
# a juste modifier quelques lignes dans les sources existants...
set_global_assignment -name AUTO_ENABLE_SMART_COMPILE ON
set_global_assignment -name SMART_RECOMPILE ON
set_global_assignment -name INCREMENTAL_COMPILATION INCREMENTAL_SYNTHESIS
set_global_assignment -name INCREMENTAL_COMPILATION FULL_INCREMENTAL_COMPILATION
# je ne sais pas si c'est vraiment utile...
set_global_assignment -name EDA_DESIGN_ENTRY_SYNTHESIS_TOOL "<None>"

#=================================================================================
#For Fast compilation, disable them if you can't fit/ can't achieve timing closure
#=================================================================================
set_global_assignment -name PROJECT_IP_REGENERATION_POLICY ALWAYS_REGENERATE_IP
if {$fast_compile} {
	set_global_assignment -name ROUTER_TIMING_OPTIMIZATION_LEVEL MINIMUM
	set_global_assignment -name PLACEMENT_EFFORT_MULTIPLIER 0.01
	set_global_assignment -name OPTIMIZE_HOLD_TIMING OFF
	set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING OFF
	set_global_assignment -name BLOCK_RAM_TO_MLAB_CELL_CONVERSION OFF
	set_global_assignment -name BLOCK_RAM_AND_MLAB_EQUIVALENT_POWER_UP_CONDITIONS "DONT CARE"
	set_global_assignment -name BLOCK_RAM_AND_MLAB_EQUIVALENT_PAUSED_READ_CAPABILITIES "DONT CARE"
	set_global_assignment -name OPTIMIZE_POWER_DURING_FITTING OFF
	set_global_assignment -name OPTIMIZE_TIMING OFF
	set_global_assignment -name OPTIMIZE_IOC_REGISTER_PLACEMENT_FOR_TIMING OFF
	set_global_assignment -name FINAL_PLACEMENT_OPTIMIZATION NEVER
	set_global_assignment -name FITTER_AGGRESSIVE_ROUTABILITY_OPTIMIZATION NEVER
	set_global_assignment -name QII_AUTO_PACKED_REGISTERS OFF
	set_global_assignment -name AUTO_DELAY_CHAINS OFF
	set_global_assignment -name IO_PLACEMENT_OPTIMIZATION OFF
	set_global_assignment -name FITTER_EFFORT "FAST FIT"
	set_global_assignment -name PHYSICAL_SYNTHESIS_EFFORT FAST
	set_global_assignment -name ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION OFF
	set_global_assignment -name ROUTER_REGISTER_DUPLICATION OFF
	set_global_assignment -name AUTO_GLOBAL_CLOCK OFF
	set_global_assignment -name ENABLE_BENEFICIAL_SKEW_OPTIMIZATION OFF
	set_global_assignment -name OPTIMIZE_FOR_METASTABILITY OFF
	set_global_assignment -name ALM_REGISTER_PACKING_EFFORT LOW
	set_global_assignment -name ADVANCED_PHYSICAL_OPTIMIZATION OFF
	set_global_assignment -name DSP_BLOCK_BALANCING OFF
	set_global_assignment -name ALLOW_SHIFT_REGISTER_MERGING_ACROSS_HIERARCHIES OFF
	set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS OFF
	set_global_assignment -name SYNTH_MESSAGE_LEVEL LOW
	set_global_assignment -name DISABLE_REGISTER_MERGING_ACROSS_HIERARCHIES OFF
	set_global_assignment -name ALLOW_REGISTER_MERGING OFF
	set_global_assignment -name ALLOW_REGISTER_DUPLICATION OFF
	set_global_assignment -name ALLOW_REGISTER_RETIMING OFF
	set_global_assignment -name FLOW_DISABLE_ASSEMBLER OFF
	set_global_assignment -name TIMEQUEST_MULTICORNER_ANALYSIS ON
	set_global_assignment -name ENABLE_REDUCED_MEMORY_MODE ON
}
