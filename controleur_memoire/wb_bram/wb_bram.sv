//-----------------------------------------------------------------
// Wishbone BlockRAM
//-----------------------------------------------------------------
//
// Le paramètre mem_adr_width doit permettre de déterminer le nombre 
// de mots de la mémoire : (2048 pour mem_adr_width=11)

module wb_bram #(parameter mem_adr_width = 11) (
      // Wishbone interface
      wshb_if.slave wb_s
      );

logic [3:0][7:0] memoire [0:mem_adr_width-1];
logic WE;

/*
//Initialisation du bus
always@(*)
if(wb_s.rst)
//A completer
*/

//Attente de la demande d'accès par le maître
always@(posedge wb_s.clk)
if(wb_s.cyc)
	if(wb_s.stb)
		if(wb_s.we) WE <= 1; //ecriture
		else 	    WE <= 0; //lecture

//Lecture
always@(*)
if (!WE)
	begin
	wb_s.dat_sm <= memoire[wb_s.adr];
	wb_s.ack <= 1;
	end
else 	wb_s.ack <= 0;

//Ecriture


endmodule

