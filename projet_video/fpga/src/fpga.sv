//-----------------------------------------------------------------
// FPGA - Afficheur Vidéo
//-----------------------------------------------------------------

module fpga(// port d'entrée
	input  fpga_CLK,
	input  fpga_CLK_AUX,
	input  fpga_SW0,
	input  fpga_SW1,
	input  fpga_NRST,
	// port de sortie
	output logic fpga_LEDR0,
	output logic fpga_LEDR1,
	output logic fpga_LEDR2,
	output logic fpga_LEDR3,
	output logic fpga_SEL_CLK_AUX
	);

`ifdef SIMULATION
parameter MAX_CPT_50 = 50_000_000;
parameter MAX_CPT_27 = 27_000_000;
`else
parameter MAX_CPT_50 = 50_000_000;
parameter MAX_CPT_27 = 27_000_000;
`endif

localparam CPT_50_W  = $clog2(MAX_CPT_50);
localparam CPT_27_W  = $clog2(MAX_CPT_27);

logic [CPT_50_W-1:0]CPT_50;
logic [CPT_27_W-1:0]CPT_27;

// Assignation des switchs
assign fpga_LEDR0 = fpga_SW0;
assign fpga_SEL_CLK_AUX = fpga_SW1;

// Assignaton du reset
assign fpga_LEDR3 = fpga_NRST;

// Assignation des compteur au LED
assign fpga_LEDR1 = (CPT_27 < MAX_CPT_50/2);
assign fpga_LEDR2 = (CPT_50 < MAX_CPT_27/2);

// Compteur 27MHz -> 1Hz
always_ff@(posedge fpga_CLK_AUX or negedge fpga_NRST)
if(!fpga_NRST) CPT_27 <= 0;
else
begin
  CPT_27 <= CPT_27 +1;
	if(CPT_27 == MAX_CPT_27 -1 ) CPT_27 <= 0;
end

// Compteur 50MHz -> 1Hz
always_ff@(posedge fpga_CLK or negedge fpga_NRST)
if(!fpga_NRST) CPT_50 <= 0;
else
begin
	CPT_50 <= CPT_50 +1;
  if(CPT_50 == MAX_CPT_50 -1 ) CPT_50 <= 0;
end

endmodule
