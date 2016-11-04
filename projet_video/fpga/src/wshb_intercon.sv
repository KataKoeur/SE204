module wshb_intercon (
  // interface
  wshb_if.slave  wshb_if_mire,
  wshb_if.slave  wshb_if_vga,
  wshb_if.master wshb_if_0
  );

wire clk = wshb_if_0.clk;
wire rst = wshb_if_0.rst;

typedef enum {IDLE, START, GO, END} state_t;
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
      n_state = START;
      end

    START :
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
      end

    START :
      begin
      end

    default :
      begin
      end
  endcase
end

endmodule // wshb_intercon
