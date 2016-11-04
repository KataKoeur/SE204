module wshb_intercon (
  // interface
  wshb_if.slave  wshb_if_mire,
  wshb_if.slave  wshb_if_vga,
  wshb_if.master wshb_if_0
  );

wire clk = wshb_if_0.clk;
wire rst = wshb_if_0.rst;

assign wshb_if_0.dat_ms = wshb_if_mire.dat_ms; //la mire ecrit dans la sdram
assign wshb_if_vga.dat_sm = wshb_if_0.dat_sm;  //le vga lit la sdram

typedef enum {IDLE, priorite_MIRE, priorite_VGA} state_t;
state_t state, n_state;

//changement d'état cadencé par clk
always @(posedge clk or posedge rst) begin
  if (rst) state <= IDLE;   // Initial state
  else     state <= n_state;
end

//gestion des changement d'état
always @(*) begin
  case (state)
    IDLE :
      begin
      n_state = priorite_MIRE;
      end

    priorite_MIRE :
      begin
      if(!wshb_if_mire.cyc)     n_state = priorite_VGA; //donne la main au vga
      else if(wshb_if_vga.cyc)  n_state = priorite_VGA; //vga impose la main
      end

    priorite_VGA :
      begin
      if(!wshb_if_vga.cyc) n_state = priorite_MIRE; //donne la main à la mire
      end

    default :
      begin
      n_state = state;
      end
  endcase
end

//gestion des des états
always @(*) begin
  case (state)
    IDLE :
      begin
      //mire
      wshb_if_mire.ack <= 1'b0;
      //vga
      wshb_if_vga.ack <= 1'b0;
      //sdram
      wshb_if_0.adr = 0;
      wshb_if_0.we  = 1'b0; //1 = ecriture et 0 = lecture
      wshb_if_0.cyc = 1'b1;
      wshb_if_0.sel = 2'b11;
      wshb_if_0.cti = 0;
      wshb_if_0.bte = 0;
      wshb_if_0.stb = 0;
      end

    priorite_MIRE :
      begin
      //mire
      wshb_if_mire.ack <= wshb_if_0.ack;
      //vga
      wshb_if_vga.ack <= 1'b0;
      //sdram
      wshb_if_0.adr = wshb_if_mire.adr;
      wshb_if_0.we  = wshb_if_mire.we;
      wshb_if_0.cyc = wshb_if_mire.cyc;
      wshb_if_0.sel = wshb_if_mire.sel;
      wshb_if_0.cti = wshb_if_mire.cti;
      wshb_if_0.bte = wshb_if_mire.bte;
      wshb_if_0.stb = wshb_if_mire.stb;
      end

    priorite_VGA :
      begin
      //mire
      wshb_if_mire.ack <= 1'b0;
      //vga
      wshb_if_vga.ack <= wshb_if_0.ack;
      //sdram
      wshb_if_0.adr = wshb_if_vga.adr;
      wshb_if_0.we  = wshb_if_vga.we;
      wshb_if_0.cyc = wshb_if_vga.cyc;
      wshb_if_0.sel = wshb_if_vga.sel;
      wshb_if_0.cti = wshb_if_vga.cti;
      wshb_if_0.bte = wshb_if_vga.bte;
      wshb_if_0.stb = wshb_if_vga.stb;
      end

    default :
      begin
      end
  endcase
end

endmodule // wshb_intercon
