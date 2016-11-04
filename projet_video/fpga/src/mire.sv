module mire (
  // mire interface
  wshb_if.master wshb_if_mire
  );

//parametres
parameter  HDISP = 640;
parameter  VDISP = 480;

localparam CPT_X_W = $clog2(HDISP);
localparam CPT_Y_W = $clog2(VDISP);

logic [CPT_X_W-1:0]CPT_X; //compteur de pixel dans une ligne
logic [CPT_Y_W-1:0]CPT_Y; //compteur de ligne dans une image

logic [5:0]fair_play; //compte de 0 à 63

assign wshb_if_mire.adr = 2*(HDISP*CPT_Y + CPT_X);
assign wshb_if_mire.stb = (fair_play == 0);
assign wshb_if_mire.cyc = (fair_play == 0);

assign wshb_if_mire.sel = 2'b11;
assign wshb_if_mire.we  = 1'b1; //1 = ecriture et 0 = lecture
assign wshb_if_mire.cti = 0;
assign wshb_if_mire.bte = 0;

//fair-play
always @(posedge wshb_if_mire.clk or posedge wshb_if_mire.rst)
if(wshb_if_mire.rst)  fair_play <= 1'b0;
else
  begin
  fair_play <= fair_play + 1'b1;
  if(fair_play == 64) fair_play <= 1'b0;
  end

//Génération d'une mire
always @(posedge wshb_if_mire.clk)
if(CPT_X %16 == 0 || CPT_Y %16 == 0) //ligne ou colone blanche
  wshb_if_mire.dat_ms <= 16'hFFFF;
else
  wshb_if_mire.dat_ms <= 16'h0000;

//signaux de synchronisation de la mire
always @(posedge wshb_if_mire.clk or posedge wshb_if_mire.rst)
if (wshb_if_mire.rst)
  begin
  CPT_X <= 0;
  CPT_Y <= 0;
  end
else
  begin
  //compteur x
  CPT_X <= CPT_X + 1'b1;
  if(CPT_X == HDISP-1)
    begin
    CPT_X <= 0;
    //compteur y
    CPT_Y <= CPT_Y + 1'b1; //fin de la ligne, on passe a la suivante
    if(CPT_Y == VDISP-1)
      begin
      CPT_Y <= 0;
      end
    end
  end

endmodule // mire
