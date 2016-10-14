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

endmodule
