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
	output logic fpga_SEL_CLK_AUX,
	// interface
	vga_if.master vga_ifm,
	sdram_if.master sdram_ifm
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

parameter HDISP = 640;
parameter VDISP = 480;

//signaux
logic [CPT_50_W-1:0]CPT_50;
logic [CPT_27_W-1:0]CPT_27;
logic n_rst;

// Instanciation de la PLL pour générer la clock wishbone et la clock sdram
logic wshb_clk ;
logic wshb_rst ;
logic sdram_clk;
logic locked ;

//modules
reset I_reset
(
	.CLK(fpga_CLK), 
	.NRST(fpga_NRST), 
	.n_rst(n_rst)
);

vga #(.vga_HDISP(HDISP), .vga_VDISP(VDISP)) I_vga
(
	.CLK(fpga_CLK_AUX), 
	.NRST(fpga_NRST), 
	.vga_ifm(vga_ifm)
);

wshb_pll pll
(
	.refclk(fpga_CLK),
	.rst(!fpga_NRST),
	.outclk_0(wshb_clk),
	.outclk_1(sdram_clk),
	.locked(locked)
);

reset I_reset_wshb
(
        .CLK(wshb_clk), 
        .NRST(fpga_NRST), 
        .n_rst(wshb_rst)
);

// Instanciation d'un bush Wishbone 16 bits
wshb_if #(.DATA_BYTES(2)) wshb_if_0
(
	wshb_clk,wshb_rst
);

// Instanciation du controleur de sdram
wb16_sdram16 u_sdram_ctrl
(
	// Wishbone 16 bits slave interface
	.wb_s(wshb_if_0.slave),
	// SDRAM master interface
	.sdram_m(sdram_ifm),
	// SDRAM clock
	.sdram_clk(sdram_clk)
);

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
