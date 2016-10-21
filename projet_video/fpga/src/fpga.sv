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

//parametres
`ifdef SIMULATION
parameter MAX_CPT_50 = 50/2;
parameter MAX_CPT_27 = 27/2;
`else
parameter MAX_CPT_50 = 50_000_000/2;
parameter MAX_CPT_27 = 27_000_000/2;
`endif

localparam CPT_50_W  = $clog2(MAX_CPT_50);
localparam CPT_27_W  = $clog2(MAX_CPT_27);

//signaux
logic [CPT_50_W-1:0]CPT_50;
logic [CPT_27_W-1:0]CPT_27;
logic n_rst;

//modules
reset I_reset(.CLK(fpga_CLK), .NRST(fpga_NRST), .n_rst(n_rst));

// Assignation des switchs
assign fpga_LEDR0 = fpga_SW0;
assign fpga_SEL_CLK_AUX = fpga_SW1;

// Assignaton du reset
assign fpga_LEDR3 = fpga_NRST;

// Compteur 27MHz -> 1Hz
always_ff@(posedge fpga_CLK_AUX or negedge n_rst)
if(!n_rst)
	begin
	CPT_27 <= 0;
	fpga_LEDR1 <= 0;
	end
else
	begin
	  CPT_27 <= CPT_27 +1'b1;
		if(CPT_27 == MAX_CPT_27 -1 )
		begin
		CPT_27 <= 0;
		fpga_LEDR1 <= !fpga_LEDR1; // changement d'état de la LED1
		end
	end

// Compteur 50MHz -> 1Hz
always_ff@(posedge fpga_CLK or negedge n_rst)
if(!n_rst)
	begin
	CPT_50 <= 0;
	fpga_LEDR2 <= 0;
	end
else
	begin
		CPT_50 <= CPT_50 +1'b1;
	  if(CPT_50 == MAX_CPT_50 -1 )
			begin
			CPT_50 <= 0;
			fpga_LEDR2 <= !fpga_LEDR2; // changement d'état de la LED2
			end
	end

endmodule
