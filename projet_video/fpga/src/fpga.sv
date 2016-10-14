//-----------------------------------------------------------------
// FPGA - Afficheur Vidéo
//-----------------------------------------------------------------

module(	// port d'entrée
	input logic fpga_CLK,
	input logic fpga_CLK_AUX,
	input logic fpga_SW0,
	input logic fpga_SW1,
	input logic fpga_NRST,
	// port de sortie
	output logic fpga_LEDR0,
	output logic fpga_LEDR1,
	output logic fpga_LEDR2,
	output logic fpga_LEDR3,
	output logic fpga_SEL_CLK_AUX
	);

logic [25:0]cpt_clk;
logic [24:0]cpt_clk_aux;

// Assignation des switchs
assign fpga_LEDR0 = fpga_SW0;
assign fpga_SEL_CLK_AUX = fpga_SW1;

// Assignaton du reset
assign fpga_LEDR3 = fpga_NRST;

// Assignation des compteur au LED
assign fpga_LEDR1 = (cpt_clk_aux < 25'd13_500_000);
assign fpga_LEDR2 = (cpt_clk_aux < 26'd25_000_000);

// Compteur 27MHz -> 1Hz
always_ff@(posedge fpga_CLK)
if(!fpga_NRST) cpt_clk_aux <= 0;
else
	if(cpt_clk_aux < 25'd27_000_000 ) cpt_clk_aux <= 0;
	else 				  cpt_clk_aux <= cpt_clk_aux +1;

// Compteur 50MHz -> 1Hz
always_ff@(posedge fpga_CLK)
if(!fpga_NRST) cpt_clk <= 0;
else    
        if(cpt_clk < 26'd50_000_000 ) cpt_clk <= 0;
        else                          cpt_clk <= cpt_clk +1;


endmodule
