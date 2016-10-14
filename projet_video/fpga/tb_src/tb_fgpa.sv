module tb_fpga;

// entrées
logic CLK, CLK_AUX;
logic SW0, SW1;
logic NRST;
// sorties
logic LEDR0, LEDR1, LEDR2, LEDR3;
logic SEL_CLK_AUX;


fpga I_fpga(.fpga_CLK(CLK), .fpga_CLK_AUX(CLK_AUX), .fpga_SW0(SW0), .fpga_SW1(SW1), .fpga_NRST(NRST), 
		.fpga_LEDR0(LEDR0), .fpga_LEDR1(LEDR1), .fpga_LEDR2(LEDR2), .fpga_LEDR3(LEDR3), 
		.fpga_SEL_CLK_AUX(SEL_CLK_AUX)); // On instancie le module a tester.

// Horloges
always #10ns CLK = ~CLK; // 50MHz
always #18ns if(SEL_CLK_AUX) CLK_AUX = ~CLK_AUX; // 27MHz actifs sur condition

//A completer...

endmodule
