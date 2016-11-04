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

//lecture en SDRAM (controleur)
assign wshb_if_0.cyc = 1'b1;
assign wshb_if_0.sel = 2'b11;
assign wshb_if_0.cti = 0;
assign wshb_if_0.bte = 0;

typedef enum {IDLE, priorite_MIRE, priorite_VGA} state_t;
state_t state, n_state;

//changement d'état cadencé par clk
always @(posedge clk) begin
  if (rst) state <= IDLE;   // Initial state
  else     state <= n_state;
end

//gestion des changement d'état
always @(*) begin
  case (state)
    IDLE :
      begin
      n_state = state;
      end

    priorite_MIRE :
      begin
      n_state = state;
      end

    priorite_VGA :
      begin
      n_state = state;
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
      end

    priorite_MIRE :
      begin
      //mire
      wshb_if_mire.ack <= 1'b1;
      //vga
      wshb_if_vga.ack <= 1'b0;
      //sdram
      wshb_if_0.adr = wshb_if_mire.adr;
      assign wshb_if_0.we  = 1'b1; //ecriture dans la sdram
      end

    priorite_VGA :
      begin
      //mire
      wshb_if_mire.ack <= 1'b0;
      //vga
      wshb_if_vga.ack <= 1'b1;
      //sdram
      wshb_if_0.adr = wshb_if_vga.adr;
      wshb_if_0.we  = 1'b0; //lecture dans la sdram
      end

    default :
      begin
      end
  endcase
end

endmodule // wshb_intercon
