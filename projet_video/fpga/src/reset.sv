module reset (
  // port d'entrée
  input CLK,
  input NRST,
  // port de sortie
  output logic n_rst
  );

parameter logic ETAT_ACTIF = 0;

logic retard;

always @(posedge CLK or negedge NRST)
if (!NRST)
  begin
  retard <= ETAT_ACTIF;
  n_rst  <= ETAT_ACTIF;
  end
else
  begin
  retard <= !ETAT_ACTIF;
  n_rst  <= retard;
  end

endmodule // reset
