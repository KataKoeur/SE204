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
wire [mem_adr_width-1:0] adresse_index = wb_s.adr[mem_adr_width+1:2];
integer i;

logic ack_read;

logic [mem_adr_width-1:0] adresse_cpt;


//Initialisation du bus
always@(*)
if(wb_s.rst)
	begin	
	//A completer
	end

//ACK         		      *ack write*       *ack read*
assign wb_s.ack = wb_s.stb && (wb_s.we || (!wb_s.we && ack_read));

//block lecture
always_ff@(posedge wb_s.clk)
begin
ack_read <= 0;
if(wb_s.stb && !wb_s.we) 
	begin
        ack_read <= 1;
        if(wb_s.cti[1] == wb_s.cti[2]) // mode classic
		if(!ack_read) wb_s.dat_sm <= memoire[adresse_index];
                else          ack_read <= 0;
        else if(wb_s.cti[2]) wb_s.dat_sm <= memoire[adresse_index]; // mode rafale adresse fix
        else // mode rafale adresse variable
		if(!ack_read)
			begin // start
                	wb_s.dat_sm <= memoire[adresse_index];
                	adresse_cpt <= adresse_index + 1;
                	end
            	else 
			begin // continue
       		        wb_s.dat_sm <= memoire[adresse_cpt];
                	adresse_cpt <= adresse_cpt + 1;
                	end
	end
end

//block ecriture
always_ff@(posedge wb_s.clk)
if(wb_s.stb && wb_s.we)
	begin
	for(i = 0; i<4; i = i+1)
		if(wb_s.sel[i])
			memoire[adresse_index][i] <= wb_s.dat_ms[(7+(i*8)) -:8];
	end

endmodule
