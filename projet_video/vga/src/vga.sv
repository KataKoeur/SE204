module vga (
  // port d'entrée
  input CLK,
  input NRST,
  // VGA interface
  vga_if.master vga_ifm
  );

//parametres
localparam  vga_Fpix   = 25.17;
localparam  vga_Fdisp  = 60;
localparam  vga_HDISP  = 640;
localparam  vga_VDISP  = 480;
localparam  vga_HFP    = 16;
localparam  vga_HPULSE = 96;
localparam  vga_HBP    = 48;
localparam  vga_VFP    = 11;
localparam  vga_VPULSE = 2;
localparam  vga_VBP    = 31;

localparam CPT_PIXEL_W  = $clog2(vga_HDISP); //nb bit du compteur de pixel
localparam CPT_LIGNE_W  = $clog2(vga_VDISP); //nb bit du compteur de ligne

//compteur
logic [CPT_PIXEL_W-1:0]CPT_PIXEL; //compteur de pixel dans une ligne
logic [CPT_LIGNE_W-1:0]CPT_LIGNE; //compteur de ligne dans une image

//signaux
logic vga_CLK;  //synchronise tous les signaux du module vga
logic locked;
logic rst;      //signal de reset

//modules
vga_pll I_vga_pll(.refclk(CLK), .rst(!NRST), .outclk_0(vga_CLK), .locked(locked));
reset #(.ETAT_ACTIF(1)) I_reset (.CLK(vga_CLK), .NRST(NRST), .n_rst(rst));



endmodule // vga
