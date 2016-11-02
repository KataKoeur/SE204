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

localparam  vga_DATA_WIDTH = 16;

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

//signaux FIFO
logic read, rempty, write, wfull;
logic [vga_DATA_WIDTH-1:0] wdata, rdata;
logic lecture_done;

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
fifo_async #(.DATA_WIDTH(vga_DATA_WIDTH), .DEPTH_WIDTH(8)) I_fifo_async
(
  .rst(rst),
  .rclk(vga_CLK),
  .read(read),
  .rdata(rdata),
  .rempty(rempty),
  .wclk(wshb_ifm.clk),
  .wdata(wdata),
  .write(write),
  .wfull(wfull)
);

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

//ecriture dans la FIFO
always @(posedge wshb_ifm.clk)
if(wfull)
  begin
  write <= 1'b0;
  lecture_done <= 1'b1;
  wshb_ifm.stb <= 1'b0;
  end
else
  begin
  write <= 1'b1; //ordre d'écrire dans la fifo
  wdata <= wshb_ifm.dat_sm;
  wshb_ifm.stb <= 1'b1; //demande de données à la SDRAM
  end

//signaux de synchronisation lecture SDRAM (ecriture FIFO)
always @(posedge wshb_ifm.ack or posedge rst)
if (rst)
  begin
  CPT_X <= 0;
  CPT_Y <= 0;
  end
else
  begin
  //compteur x
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
if(lecture_done)
  if(vga_ifm.VGA_BLANK && read)
    begin
    vga_ifm.VGA_R <= rdata[4:0]   << 3; //5-bit
    vga_ifm.VGA_G <= rdata[10:5]  << 2; //6-bit
    vga_ifm.VGA_B <= rdata[15:11] << 3; //5-bit
    end

//lecture de la FIFO
always @(posedge vga_CLK)
if(rempty) read <= 1'b0;
else
  begin
  read <= 1'b1; //ordre de lire la fifo
  wdata <= wshb_ifm.dat_sm;
  end

//signaux de synchronisation Affichage (lecture FIFO)
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
  if(CPT_PIXEL == vga_HDISP-1) blank_pixel <= 0;
  if(CPT_PIXEL == vga_HDISP + vga_HFP-1) vga_ifm.VGA_HS <= 0;
  if(CPT_PIXEL == vga_HDISP + vga_HFP + vga_HPULSE-1) vga_ifm.VGA_HS <= 1;
  if(CPT_PIXEL == vga_HDISP + vga_HFP + vga_HPULSE + vga_HBP-1)
    begin
    blank_pixel <= 1;
    CPT_PIXEL   <= 0;
    CPT_LIGNE   <= CPT_LIGNE + 1'b1; //fin de la ligne, on passe a la suivante
    end
  //compteur ligne
  if(CPT_LIGNE == vga_VDISP-1) blank_ligne <= 0;
  if(CPT_LIGNE == vga_VDISP + vga_VFP-1) vga_ifm.VGA_VS <= 0;
  if(CPT_LIGNE == vga_VDISP + vga_VFP + vga_VPULSE-1) vga_ifm.VGA_VS <= 1;
  if(CPT_LIGNE == vga_VDISP + vga_VFP + vga_VPULSE + vga_VBP-1)
    begin
    blank_ligne <= 1;
    CPT_LIGNE   <= 0;
    end
  end

endmodule // vga
