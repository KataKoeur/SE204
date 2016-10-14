#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3 


#**************************************************************
# Create Clocks
#**************************************************************

# L'horloge externe à 50Mhz
create_clock -name {fpga_CLK} -period 20.0 -waveform { 0.0 10.0 } [get_ports {fpga_CLK}]

# L'horloge externe à 27Mhz
create_clock -name {fpga_CLK_AUX} -period 37.037  [get_ports {fpga_CLK_AUX}]

# Les horloges sont indépendantes
set_clock_groups -exclusive \
		 -group {fpga_CLK} \
		 -group {fpga_CLK_AUX} 
# -----------------------------------------------------------------
# Cut timing paths
# -----------------------------------------------------------------
#
# The timing for the I/Os in this design is arbitrary, so cut all
# paths to the I/Os, even the ones that are used in the design,
# i.e., the LEDs, switches, and hex displays.
#

# Les entrées manuelles
set_false_path -from [get_ports fpga_NRST] -to *
set_false_path -from [get_ports fpga_SW*] -to *

# Les afficheurs
set_false_path -from * -to [get_ports {fpga_LEDR*}]


