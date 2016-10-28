module tb_fpga;

// entrées
logic CLK, CLK_AUX;
logic SW0, SW1;
logic NRST;
// sorties
wire LEDR0, LEDR1, LEDR2, LEDR3;
wire SEL_CLK_AUX;
// interface
vga_if vga_if0();


// Instance le module a tester.
fpga #(.HDISP(160), .VDISP(90)) I_fpga(.fpga_CLK(CLK), .fpga_CLK_AUX(CLK_AUX),
		.fpga_SW0(SW0), .fpga_SW1(SW1), .fpga_NRST(NRST), .fpga_LEDR0(LEDR0),
		.fpga_LEDR1(LEDR1), .fpga_LEDR2(LEDR2), .fpga_LEDR3(LEDR3),
		.fpga_SEL_CLK_AUX(SEL_CLK_AUX), .vga_ifm(vga_if0));

screen #(.mode(0),.X(160),.Y(90)) screen0(.vga_ifs(vga_if0));

// Horloges
always #10ns CLK = ~CLK; // 50MHz
always #18ns if(SEL_CLK_AUX) CLK_AUX = ~CLK_AUX; // 27MHz actifs sur condition

//---------------------------------------------------------------------------
initial begin:vga

CLK     = 1'b0;
CLK_AUX = 1'b0;
SW0     = 1'b0;
SW1     = 1'b0;
NRST    = 1'b0;

#1; //attente d'une unité de temps

@(negedge CLK);
NRST= 1'b1;
SW1 = 1'b1; //activation de CLK_AUX

#10ms
$display("Fin de la simulation");
$finish;
end

endmodule
