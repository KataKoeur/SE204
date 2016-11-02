module vga (
  // port d'entrée
  input CLK,
  input NRST,
  // VGA interface
  vga_if.master vga_ifm,
  wshb_if.master wshb_ifm
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

localparam CPT_PIXEL_W = $clog2(vga_HDISP + vga_HFP + vga_HPULSE + vga_HBP);
localparam CPT_LIGNE_W = $clog2(vga_VDISP + vga_VFP + vga_VPULSE + vga_VBP);

localparam CPT_X_W = $clog2(vga_HDISP);
localparam CPT_Y_W = $clog2(vga_VDISP);

//compteur
logic [CPT_PIXEL_W-1:0]CPT_PIXEL; //compteur de pixel dans une ligne
logic [CPT_LIGNE_W-1:0]CPT_LIGNE; //compteur de ligne dans une image

logic [CPT_X_W-1:0]CPT_X; //compteur de pixel dans une ligne
logic [CPT_Y_W-1:0]CPT_Y; //compteur de ligne dans une image

//signaux
logic vga_CLK;  //synchronise tous les signaux du module vga
logic locked;
logic rst;      //signal de reset

logic blank_pixel;
logic blank_ligne;

logic rclk;
logic read;
logic rdata;
logic rempty;
logic wclk;
logic wdata;
logic write;
logic wfull;

//modules
vga_pll I_vga_pll
(
  .refclk(CLK),
  .rst(!NRST),
  .outclk_0(vga_CLK),
  .locked(locked)
);

reset #(.ETAT_ACTIF(1)) I_reset
(
  .CLK(vga_CLK),
  .NRST(NRST),
  .n_rst(rst)
);

//fifo de 256 données de 16 bits
fifo_async #(.DATA_WIDTH(16), .DEPTH_WIDTH(8)) I_fifo_async
(
  .rst(rst),
  .rclk(rclk),
  .read(read),
  .rdata(rdata),
  .rempty(rempty),
  .wclk(wclk),
  .wdata(wdata),
  .write(write),
  .wfull(wfull)
);

//gestion FIFO
assign wclk = wshb_ifm.clk;
assign wdata = wshb_ifm.dat_sm;

//signal de sortie
assign vga_ifm.VGA_SYNC  = 0;
assign vga_ifm.VGA_CLK   = !vga_CLK;
assign vga_ifm.VGA_BLANK = blank_pixel & blank_ligne;

//lecture en SDRAM (controleur)
assign wshb_ifm.adr = 2*(vga_HDISP*CPT_Y + CPT_X);
assign wshb_ifm.cyc = 1'b1; //maintenue à 1
assign wshb_ifm.sel = 2'b11;
assign wshb_ifm.we  = 1'b0; //1 = ecriture et 0 = lecture
assign wshb_ifm.cti = 0;
assign wshb_ifm.bte = 0;

//signaux de synchronisation lecture SDRAM
always @(*)
if (rst)
  begin
  CPT_X <= 0;
  CPT_Y <= 0;
  end
else if(wfull)
  begin
  wshb_ifm.stb <= 1'b0;
  end
else if(wshb_ifm.ack)
  begin
  //compteur x
  write <= 1'b1; //ordre d'écrire dans la fifo
  wshb_ifm.stb <= 1'b1;
  CPT_X <= CPT_X + 1'b1;
  if(CPT_X == vga_HDISP-1)
    begin
    CPT_X <= 0;
    CPT_Y <= CPT_Y + 1'b1; //fin de la ligne, on passe a la suivante
    end
  //compteur y
  if(CPT_Y == vga_VDISP-1)
    begin
    CPT_Y <= 0;
    end
  end

//décodeur RGB565
always_comb
if(CPT_PIXEL < vga_HDISP && CPT_LIGNE < vga_VDISP)
  begin
  vga_ifm.VGA_R <= wshb_ifm.dat_sm[4:0];   //5-bit
  vga_ifm.VGA_G <= wshb_ifm.dat_sm[10:5];  //6-bit
  vga_ifm.VGA_B <= wshb_ifm.dat_sm[15:11]; //5-bit
  end

//signaux de synchronisation Affichage
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
  if(CPT_LIGNE == vga_VDISP + vga_VFP + vga_VPULSE + vga_VBP)
    begin
    blank_ligne <= 1;
    CPT_LIGNE <= 0;
    end
  end

endmodule // vga
