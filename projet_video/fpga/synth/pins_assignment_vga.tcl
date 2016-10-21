#============================================================
# VGA
#============================================================

# Standard électrique
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL"  -to vga_ifm.VGA*
set_instance_assignment -name CURRENT_STRENGTH_NEW "8MA" -to vga_ifm.VGA*
set_instance_assignment -name SLEW_RATE 1 -to  vga_ifm.VGA*


# Position des pins
set_location_assignment PIN_B13 -to vga_ifm.VGA_B[0]
set_location_assignment PIN_G13 -to vga_ifm.VGA_B[1]
set_location_assignment PIN_H13 -to vga_ifm.VGA_B[2]
set_location_assignment PIN_F14 -to vga_ifm.VGA_B[3]
set_location_assignment PIN_H14 -to vga_ifm.VGA_B[4]
set_location_assignment PIN_F15 -to vga_ifm.VGA_B[5]
set_location_assignment PIN_G15 -to vga_ifm.VGA_B[6]
set_location_assignment PIN_J14 -to vga_ifm.VGA_B[7]
set_location_assignment PIN_F10 -to vga_ifm.VGA_BLANK
set_location_assignment PIN_A11 -to vga_ifm.VGA_CLK
set_location_assignment PIN_J9 -to vga_ifm.VGA_G[0]
set_location_assignment PIN_J10 -to vga_ifm.VGA_G[1]
set_location_assignment PIN_H12 -to vga_ifm.VGA_G[2]
set_location_assignment PIN_G10 -to vga_ifm.VGA_G[3]
set_location_assignment PIN_G11 -to vga_ifm.VGA_G[4]
set_location_assignment PIN_G12 -to vga_ifm.VGA_G[5]
set_location_assignment PIN_F11 -to vga_ifm.VGA_G[6]
set_location_assignment PIN_E11 -to vga_ifm.VGA_G[7]
set_location_assignment PIN_B11 -to vga_ifm.VGA_HS
set_location_assignment PIN_A13 -to vga_ifm.VGA_R[0]
set_location_assignment PIN_C13 -to vga_ifm.VGA_R[1]
set_location_assignment PIN_E13 -to vga_ifm.VGA_R[2]
set_location_assignment PIN_B12 -to vga_ifm.VGA_R[3]
set_location_assignment PIN_C12 -to vga_ifm.VGA_R[4]
set_location_assignment PIN_D12 -to vga_ifm.VGA_R[5]
set_location_assignment PIN_E12 -to vga_ifm.VGA_R[6]
set_location_assignment PIN_F13 -to vga_ifm.VGA_R[7]
set_location_assignment PIN_C10 -to vga_ifm.VGA_SYNC
set_location_assignment PIN_D11 -to vga_ifm.VGA_VS
