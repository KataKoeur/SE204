# Ajout du hps
if {$enable_hps} {
  set_global_assignment -name QIP_FILE     ${TOPDIR}/hps/hps/synthesis/hps.qip
  set_global_assignment -name VERILOG_FILE ${TOPDIR}/hps/hps/synthesis/hps.v
  set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/hps/src/hps_block.sv
}

# La liste des fichiers source à utiliser
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/vga/src/vga_if.sv
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/vga/src/vga_pll.sv
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/vga/src/vga.sv

set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/fpga/src/reset.sv
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/fpga/src/fpga.sv

# Ajout du bus wishbone et de la sdram
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/fpga/src/wshb_if.sv
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/fpga/src/wshb_pll.sv
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/wb16_sdram16/src/sdram_if.sv
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/wb16_sdram16/src/xess_sdramcntl.sv
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/wb16_sdram16/src/wb_bridge_xess.sv
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/wb16_sdram16/src/wb16_sdram16.sv
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/fifo_async/src/fifo_async.sv

set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/fpga/src/wshb_intercon.sv
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/fpga/src/mire.sv
