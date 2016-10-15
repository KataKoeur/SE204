module tb_fpga;

// entrées
logic CLK, CLK_AUX;
logic SW0, SW1;
logic NRST;
// sorties
wire LEDR0, LEDR1, LEDR2, LEDR3;
wire SEL_CLK_AUX;


fpga I_fpga(.fpga_CLK(CLK), .fpga_CLK_AUX(CLK_AUX), .fpga_SW0(SW0), .fpga_SW1(SW1), .fpga_NRST(NRST), 
		.fpga_LEDR0(LEDR0), .fpga_LEDR1(LEDR1), .fpga_LEDR2(LEDR2), .fpga_LEDR3(LEDR3), 
		.fpga_SEL_CLK_AUX(SEL_CLK_AUX)); // On instancie le module a tester.

// Horloges
always #10ns CLK = ~CLK; // 50MHz
always #18ns if(SEL_CLK_AUX) CLK_AUX = ~CLK_AUX; // 27MHz actifs sur condition

initial begin: ENTREES

	CLK 	= 1'b0;
	CLK_AUX = 1'b0;
	SW0	= 1'b0;
	SW1	= 1'b0;
	NRST	= 1'b0;

	@(negedge CLK);
	NRST = 1'b1;

	#1; //attente d'une unité de temps

	//-------------------SW0-------------------

        @(negedge CLK);
        SW0 = 1'b1; //allumage de la LED0

        #10;

        @(negedge CLK);
        SW0 = 1'b0; //extinction de la LED0

	@(negedge CLK);
	SW0 = 1'b1; //allumage de la LED0

	#10;	

	@(negedge CLK);
	SW0 = 1'b0; //extinction de la LED0

	#10;

	@(negedge CLK);
	SW0 = 1'b1; //allumage de la LED0

	#10;

	@(negedge CLK);
	SW0 = 1'b0; //extinction de la LED0

	//-------------------SW1-------------------

	@(negedge CLK);
	SW1 = 1'b1; //activation de CLK_AUX

	#200;
	$display("Fin de la simulation");
	$finish;

	end

endmodule
