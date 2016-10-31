#============================================================
# SDRAM
#============================================================

# Paramètres électriques des ports
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL"  -to sdram_ifm.*
#set_instance_assignment -name CURRENT_STRENGTH_NEW "8MA" -to sdram_ifm.*
#set_instance_assignment -name SLEW_RATE 1 -to  sdram_ifm.*

# Positions des pins
set_location_assignment PIN_AH12 -to sdram_ifm.clk
set_location_assignment PIN_AK13 -to sdram_ifm.cke
set_location_assignment PIN_AG11 -to sdram_ifm.cs_n
set_location_assignment PIN_AE13 -to sdram_ifm.ras_n
set_location_assignment PIN_AF11 -to sdram_ifm.cas_n
set_location_assignment PIN_AA13 -to sdram_ifm.we_n
set_location_assignment PIN_AJ12 -to sdram_ifm.ba[1]
set_location_assignment PIN_AF13 -to sdram_ifm.ba[0]
set_location_assignment PIN_AJ14 -to sdram_ifm.sAddr[12]
set_location_assignment PIN_AH13 -to sdram_ifm.sAddr[11]
set_location_assignment PIN_AG12 -to sdram_ifm.sAddr[10]
set_location_assignment PIN_AG13 -to sdram_ifm.sAddr[9]
set_location_assignment PIN_AH15 -to sdram_ifm.sAddr[8]
set_location_assignment PIN_AF15 -to sdram_ifm.sAddr[7]
set_location_assignment PIN_AD14 -to sdram_ifm.sAddr[6]
set_location_assignment PIN_AC14 -to sdram_ifm.sAddr[5]
set_location_assignment PIN_AB15 -to sdram_ifm.sAddr[4]
set_location_assignment PIN_AE14 -to sdram_ifm.sAddr[3]
set_location_assignment PIN_AG15 -to sdram_ifm.sAddr[2]
set_location_assignment PIN_AH14 -to sdram_ifm.sAddr[1]
set_location_assignment PIN_AK14 -to sdram_ifm.sAddr[0]
set_location_assignment PIN_AJ5  -to sdram_ifm.sDQ[15]
set_location_assignment PIN_AJ6  -to sdram_ifm.sDQ[14]
set_location_assignment PIN_AH7  -to sdram_ifm.sDQ[13]
set_location_assignment PIN_AH8  -to sdram_ifm.sDQ[12]
set_location_assignment PIN_AH9  -to sdram_ifm.sDQ[11]
set_location_assignment PIN_AJ9  -to sdram_ifm.sDQ[10]
set_location_assignment PIN_AJ10 -to sdram_ifm.sDQ[9]
set_location_assignment PIN_AH10 -to sdram_ifm.sDQ[8]
set_location_assignment PIN_AJ11 -to sdram_ifm.sDQ[7]
set_location_assignment PIN_AK11 -to sdram_ifm.sDQ[6]
set_location_assignment PIN_AG10 -to sdram_ifm.sDQ[5]
set_location_assignment PIN_AK9  -to sdram_ifm.sDQ[4]
set_location_assignment PIN_AK8  -to sdram_ifm.sDQ[3]
set_location_assignment PIN_AK7  -to sdram_ifm.sDQ[2]
set_location_assignment PIN_AJ7  -to sdram_ifm.sDQ[1]
set_location_assignment PIN_AK6  -to sdram_ifm.sDQ[0]
set_location_assignment PIN_AK12 -to sdram_ifm.dqm[1]
set_location_assignment PIN_AB13 -to sdram_ifm.dqm[0]

