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
integer i;

logic ack_read;
logic ack_write;

logic [31:0]adr_cpt;

//Initialisation du bus
always@(*)
if(wb_s.rst)
	begin	
	//A completer
	end

//ack read
always_ff@(posedge wb_s.clk)
begin
ack_read <= 0;
ack_read <= wb_s.stb && !wb_s.we && !wb_s.ack;
end

//ack write
always_comb
ack_write = wb_s.stb && wb_s.we;

//ACK
always_comb
if(!wb_s.cti) wb_s.ack = ack_read || ack_write; //mode classique
else 	      wb_s.ack = wb_s.stb;		//mode rafale


//block lecture
always_ff@(posedge wb_s.clk)
begin
if(!wb_s.cti) //mode classique
	wb_s.dat_sm <= memoire[wb_s.adr[mem_adr_width+1:2]];
else	      //mode rafale
	wb_s.dat_sm <= memoire[adr_cpt[mem_adr_width+1:2]];
end

//block ecriture
always_ff@(posedge wb_s.clk)
if(!wb_s.cti) //mode classique
	if(wb_s.stb && wb_s.we)
		begin
		for(i = 0; i<4; i = i+1)
			if(wb_s.sel[i])
				memoire[wb_s.adr[mem_adr_width+1:2]][i] <= wb_s.dat_ms[(7+(i*8)) -:8];
		end

//Gestion compteur d'adresse
always_ff@(posedge wb_s.clk)
if(!wb_s.cti) adr_cpt <= wb_s.adr;
else 	      adr_cpt <= adr_cpt +4;

endmodule
