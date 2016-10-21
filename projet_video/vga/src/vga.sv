module vga (
  // port d'entrée
  input CLK,
  input NRST,
  // VGA interface
  vga_if.vga_ifm
  );

//signaux
logic vga_CLK;
logic locked;
logic rst;

//modules
vga_pll I_vga_pll(.refclk(CLK), .rst(!NRST), .outclk_0(vga_CLK), .locked(locked));
reset #(.ETAT_ACTIF(1)) I_reset (.CLK(vga_CLK), .NRST(NRST), .n_rst(rst));



endmodule // vga
