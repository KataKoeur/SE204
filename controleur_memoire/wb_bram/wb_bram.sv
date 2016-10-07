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

logic [3:0][7:0] memoire [0:2**mem_adr_width-1];
logic ack_reg;

//Initialisation du bus
always@(*)
if(wb_s.rst)
	begin
	wb_s.ack <= 0;
	ack_reg <= 0;
	//A completer
	end

//Lecture
always@(posedge wb_s.clk)
begin
wb_s.dat_sm <= memoire[wb_s.adr]; //lecture de la mémoire en sortie quoi qu'il arrive
wb_s.ack <= ack_reg; //registre à décalage permettant de mettre ack à 1 avec 1 cycle de retard
ack_reg <= (wb_s.cyc && wb_s.stb && !wb_s.we)? 1 : 0;
end

endmodule

