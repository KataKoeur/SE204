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
integer k;

initial
begin
for (k = 0; k < 2**mem_adr_width - 1; k = k + 1)
begin
    memoire[k] = 1;
end
end

//Initialisation du bus
always@(*)
if(wb_s.rst)
	begin
	wb_s.ack <= 0;
	ack_reg <= 0;
	//A completer
	end


always@(*)
begin
wb_s.dat_sm <= memoire[wb_s.adr]; //lecture de la mémoire en sortie quoi qu'il arrive
memoire[wb_s.adr][wb_s.sel] <= (wb_s.cyc && wb_s.stb && wb_s.we)? wb_s.dat_ms : memoire[wb_s.adr][wb_s.sel]; //ecriture
end

always@(posedge wb_s.clk)
begin
wb_s.ack <= (wb_s.cyc && wb_s.stb && wb_s.we)?1 : ack_reg; //ecriture: ack=1 directement, lecture: ack=1 avec un cycle de retard
ack_reg <= (wb_s.cyc && wb_s.stb)? 1 : 0;
end

endmodule
