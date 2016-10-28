module vga (
  // port d'entrée
  input CLK,
  input NRST,
  // VGA interface
  vga_if.master vga_ifm
  );

//parametres
parameter  vga_HDISP = 640;
parameter  vga_VDISP = 480;

localparam  vga_Fpix   = 25.17;
localparam  vga_Fdisp  = 60;
localparam  vga_HFP    = 16;
localparam  vga_HPULSE = 96;
localparam  vga_HBP    = 48;
localparam  vga_VFP    = 11;
localparam  vga_VPULSE = 2;
localparam  vga_VBP    = 31;

localparam CPT_PIXEL_W  = $clog2(vga_HDISP + vga_HFP + vga_HPULSE + vga_HBP);
localparam CPT_LIGNE_W  = $clog2(vga_VDISP + vga_VFP + vga_VPULSE + vga_VBP);

//compteur
logic [CPT_PIXEL_W-1:0]CPT_PIXEL; //compteur de pixel dans une ligne
logic [CPT_LIGNE_W-1:0]CPT_LIGNE; //compteur de ligne dans une image

//signaux
logic vga_CLK;  //synchronise tous les signaux du module vga
logic locked;
logic rst;      //signal de reset

logic blank_pixel;
logic blank_ligne;

//modules
vga_pll I_vga_pll(.refclk(CLK), .rst(!NRST), .outclk_0(vga_CLK), .locked(locked));
reset #(.ETAT_ACTIF(1)) I_reset (.CLK(vga_CLK), .NRST(NRST), .n_rst(rst));

//signal de sortie
assign vga_ifm.VGA_SYNC  = 0;
assign vga_ifm.VGA_CLK   = !vga_CLK;
assign vga_ifm.VGA_BLANK = blank_pixel & blank_ligne;

//signaux de synchronisation PIXEL
always @(posedge vga_CLK)
if (rst)
  begin
  CPT_PIXEL <= 0;
  CPT_LIGNE <= 0;
  vga_ifm.VGA_HS <= 1;
  vga_ifm.VGA_VS <= 1;
  blank_pixel <= 1;
  blank_ligne <= 1;
  end
else
  begin
  //compteur pixel
  CPT_PIXEL <= CPT_PIXEL + 1'b1;
  if(CPT_PIXEL == vga_HDISP) blank_pixel <= 0;
  if(CPT_PIXEL == vga_HDISP + vga_HFP) vga_ifm.VGA_HS <= 0;
  if(CPT_PIXEL == vga_HDISP + vga_HFP + vga_HPULSE) vga_ifm.VGA_HS <= 1;
  if(CPT_PIXEL == vga_HDISP + vga_HFP + vga_HPULSE + vga_HBP)
    begin
    blank_pixel <= 1;
    CPT_PIXEL <= 0;
    CPT_LIGNE <= CPT_LIGNE + 1'b1; //fin de la ligne, on passe a la suivante
    end
  //compteur ligne
  if(CPT_LIGNE == vga_VDISP) blank_ligne <= 0;
  if(CPT_LIGNE == vga_VDISP + vga_VFP) vga_ifm.VGA_VS <= 0;
  if(CPT_LIGNE == vga_VDISP + vga_VFP + vga_VPULSE) vga_ifm.VGA_VS <= 1;
  if(CPT_LIGNE == vga_VDISP + vga_VFP + vga_VPULSE + vga_VBP) CPT_LIGNE <= 0;
  end

  //Génération d'une mire
  always @(posedge vga_CLK)
  if(CPT_LIGNE %16 == 0 || CPT_PIXEL %16 == 0) //ligne ou colone blanche
    begin
    vga_ifm.VGA_R <= 255;
    vga_ifm.VGA_G <= 255;
    vga_ifm.VGA_B <= 255;
    end
  else
    begin
    vga_ifm.VGA_R <= 0;
    vga_ifm.VGA_G <= 0;
    vga_ifm.VGA_B <= 0;
    end

endmodule // vga
