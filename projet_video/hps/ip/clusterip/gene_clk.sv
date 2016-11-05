`default_nettype none
  module gene_clk(clk_50,
                  clk_out);

   input logic  clk_50;
   output logic clk_out;

   // Compteur de division de l'horloge à 50MHz
   logic [25:0] cpt;

   always_ff @(posedge clk_50)
     if (cpt == 25_000_000-1)
       cpt <= 0;
     else
       cpt <= cpt + 1;

   always_ff @(posedge clk_50)
     clk_out <= cpt < 12_500_000;

endmodule // gene_clk
