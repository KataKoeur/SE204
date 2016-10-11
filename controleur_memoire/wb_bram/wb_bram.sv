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
integer i;


//Initialisation du bus
always@(*)
if(wb_s.rst)
	begin	
	//A completer
	end

always_comb
begin
wb_s.ack = 0;
wb_s.ack = (wb_s.stb)? 1 : 0; //ecriture: ack=1 directement
wb_s.ack = (wb_s.stb && wb_s.we)? 1 : ack_reg; //lecture: ack=1 avec un cycle de retard
end

//block lecture et registre à décalage ack
always_ff@(posedge wb_s.clk)
begin
wb_s.dat_sm <= memoire[wb_s.adr[mem_adr_width+1:2]];
ack_reg <= (wb_s.we)? 1 : 0; //registre à décalage pour la lecture
end

//block ecriture
always_ff@(posedge wb_s.clk)
if(wb_s.stb && wb_s.we)
	for(i = 0; i<4; i = i+1)
		if(wb_s.sel[i])
			begin
			memoire[wb_s.adr[mem_adr_width+1:2]][i] <= wb_s.dat_ms[(7+(i*8)) -:8];
			end

endmodule
