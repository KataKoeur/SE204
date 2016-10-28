# La liste des fichiers source à utiliser

set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/vga/src/vga_if.sv
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/vga/src/vga_pll.sv
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/vga/src/vga.sv

set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/fpga/src/reset.sv
set_global_assignment -name SYSTEMVERILOG_FILE ${TOPDIR}/fpga/src/fpga.sv
