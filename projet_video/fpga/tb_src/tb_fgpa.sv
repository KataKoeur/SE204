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

// Horloges
always #10ns CLK = ~CLK; // 50MHz
always #18ns if(SEL_CLK_AUX) CLK_AUX = ~CLK_AUX; // 27MHz actifs sur condition

int FREQ = 1_000_000;
int EPSILON  = 100_000;

int NB_PIXEL = 90*18;
int NB_IMAGE = 3;
int TEMPS_AUX = 1/27e6;

logic freq1_done = 0;
logic freq2_done = 0;
logic vga_done   = 0;

wire freq_done = freq1_done & freq2_done;


//---------------------------------------------------------------------------
initial begin:Vga

//------------------- SW1 -> SEL_CLK_AUX -------------------
@(negedge CLK);
SW1 = 1'b1; //activation de CLK_AUX

@(posedge CLK);
if (SEL_CLK_AUX != 1)
	begin
	$display("Erreur : L'horloges auxiliaire ne s'active pas !!!");
	$stop;
	end

	#(NB_PIXEL*NB_IMAGE*TEMPS_AUX)
	vga_done = 1;
end

//---------------------------------------------------------------------------
initial begin:Fref_LED1
shortreal t;
	@(posedge LEDR1)
	t = $realtime();
	@(posedge LEDR1)
	t = $realtime() - t;
	$display("---> La fréquence de la led 1 est de %f Hz", t/1e6);
	@(posedge CLK);
	if (t < FREQ-EPSILON || t > FREQ+EPSILON)
		begin
		$display("Erreur : Frequence de LED1 inapproprié !!!");
		$stop;
		end

	freq1_done = 1;
end

//---------------------------------------------------------------------------
initial begin:Fref_LED2
shortreal t;
	@(posedge LEDR2)
	t = $realtime();
	@(posedge LEDR2)
	t = $realtime() - t;
	$display("---> La fréquence de la led 2 est de %f Hz", t/1e6);
	@(posedge CLK);
	if (t < FREQ-EPSILON || t > FREQ+EPSILON)
		begin
		$display("Erreur : Frequence de LED2 inapproprié !!!");
		$stop;
		end

	freq2_done = 1;
end

//---------------------------------------------------------------------------
initial begin: ENTREES

	CLK 	= 1'b0;
	CLK_AUX = 1'b0;
	SW0	= 1'b0;
	SW1	= 1'b0;
	NRST	= 1'b0;

	repeat(10) @(negedge CLK);

	//------------------- NRST -> LEDR3 -------------------
	@(posedge CLK);
	if (LEDR3 != 0)
		begin
		$display("Erreur : LED3 ne s'est pas éteinte !!!");
		$stop;
		end

	@(negedge CLK);
	NRST = 1'b1; //désactivation du reset

	@(posedge CLK);
	if (LEDR3 != 1)
		begin
		$display("Erreur : LED3 ne s'est pas allumé !!!");
		$stop;
		end

	//------------------- SW0 -> LEDR0 -------------------

	@(negedge CLK);
	SW0 = 1'b1; //allumage de la LED0

	@(posedge CLK);
	if (LEDR0 != 1)
		begin
		$display("Erreur : LED0 ne s'est pas allumé !!!");
		$stop;
		end

	@(negedge CLK);
	SW0 = 1'b0; //extinction de la LED0

	@(posedge CLK);
	if (LEDR0 != 0)
		begin
		$display("Erreur : LED0 ne s'est pas éteinte !!!");
		$stop;
		end

	//-------------------FIN-------------------
	wait(freq_done);
	wait(vga_done);
	$display("Aucune erreur détecté, SUPER TRAVAIL !!!");
	$display("--- Fin de la simulation ---");

	#1ms	$finish;

	end

endmodule
