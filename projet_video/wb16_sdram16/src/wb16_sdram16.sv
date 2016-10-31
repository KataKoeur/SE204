//-----------------------------------------------------------------------------
// Wishbone SDRAM Controller
// YM/TPT
//-----------------------------------------------------------------------------
// PREDICTION_WIDTH :
// Burst prediction width (length of burst is 2**PREDICTION_WIDTH)

module wb16_sdram16 #(
        parameter       PREDICTION_WIDTH = 4,
        parameter       OP_FREQ_KHZ =  100_000
) (
   // Whishbone connection
   wshb_if.slave wb_s,
   // SDRAM connection
   sdram_if.master sdram_m,
   input wire sdram_clk
);


// SDRAM constants for the DE1_soc SDRAM
// 32Mx16 parameters
localparam ADDR_BITS        =      13; // Set this parameter to control how many Address bits are used
localparam ROW_BITS         =      13; // Set this parameter to control how many Row bits are used
localparam COL_BITS         =      10; // Set this parameter to control how many Column bits are used
localparam DQ_BITS          =      16; // Set this parameter to control how many Data bits are used
localparam DM_BITS          =       2; // Set this parameter to control how many DM bits are used
localparam BA_BITS          =       2; // Bank bits

// Address SIZE for controller
localparam HADDR_BITS = BA_BITS+ROW_BITS+COL_BITS  ; // host-side address width

// synthesis translate_off 
// Check if Whisbone parameters match the SDRAM controller parameters
initial
  assert (wb_s.DATA_BYTES == DM_BITS)  else $fatal(1,"Wishbone bus data size doesn't match SDRAM data size") ;
// synthesis translate_on


//----------------------------------------------------------------------------
// Instantiate a WB16 to Xess cntl adapter
//----------------------------------------------------------------------------

logic   cntl_rd;
logic   cntl_wr;
logic   cntl_opBegun;
logic   cntl_earlyOpBegun;
logic   cntl_rdPending;
logic   cntl_done;
logic   cntl_rdDone;
logic   [HADDR_BITS-1:0] cntl_hAddr;
logic   [DQ_BITS-1:0] cntl_hDIn ;
logic   [DQ_BITS-1:0] cntl_hDOut;
logic   [DM_BITS-1:0]   cntl_hSel;
logic   [3:0] cntl_status ;

wb_bridge_xess #(.PREDICTION_WIDTH(PREDICTION_WIDTH),      // Burst prediction width (length of burst is 2**PREDICTION_WIDTH)
                 .DATA_BYTES(DM_BITS) ,            // DATA width
                 .HADDR_WIDTH(HADDR_BITS)   // host-side address width
) wb_bridge_xess0 (
   // Wishbone interface
   .wb_s(wb_s),
   // Xess Controller connection
   .cntl_rd(cntl_rd),
   .cntl_wr(cntl_wr),
   .cntl_opBegun(cntl_opBegun),
   .cntl_earlyOpBegun(cntl_earlyOpBegun),
   .cntl_rdPending(cntl_rdPending),
   .cntl_done(cntl_done),
   .cntl_rdDone(cntl_rdDone),
   .cntl_hAddr(cntl_hAddr),
   .cntl_hDIn(cntl_hDIn),
   .cntl_hDOut(cntl_hDOut),
   .cntl_hSel(cntl_hSel),
   .cntl_status(cntl_status)
);

//----------------------------------------------------------------------------
// Instantiate the Xess SDRAM controller
//----------------------------------------------------------------------------

logic cntl_lock ;
logic [DQ_BITS-1:0] cntl_sD                ; // data from SDRAM
logic [DQ_BITS-1:0] cntl_sQ                ; // data to SDRAM

xess_sdramcntl #(
    .FREQ(OP_FREQ_KHZ)           , // operating frequency in KHz
    .IN_PHASE(1'b1)              , // SDRAM and controller work on same or opposite clock edge
    .PIPE_EN(1'b1)               , // if true, enable pipelined read operations
    .MAX_NOP(100000000)          , // number of NOPs before entering self-refresh (no need to refresh a framebuffer)
    .MULTIPLE_ACTIVE_ROWS(1'b1)  , // if true, allow an active row in each bank
    .DATA_BYTES(DM_BITS)         , // host & SDRAM data width
    .BA_WIDTH(2)                 , // Bank address width
    .CAS_CYCLES(2)               , // Cas LATENCY  (2 or 3)
    .NROWS(2**ROW_BITS)          , // number of rows in SDRAM array
    .NCOLS(2**COL_BITS)          , // number of columns in SDRAM array
    .HADDR_WIDTH(HADDR_BITS)     , // host-side address width
    .SADDR_WIDTH(ADDR_BITS)      , // SDRAM-side address width
    .BANK_INTERLEAVE(1)            // Bank/row interleave
    )

    xess_sdram_cntl0 (
    .clk(wb_s.clk),
    .lock(cntl_lock),
    .rst(wb_s.rst),
    // cntl interface
    .rd(cntl_rd),
    .wr(cntl_wr),
    .earlyOpBegun(cntl_earlyOpBegun),
    .opBegun(cntl_opBegun),
    .rdPending(cntl_rdPending),
    .done(cntl_done),
    .rdDone(cntl_rdDone),
    .hAddr(cntl_hAddr),
    .hDIn(cntl_hDIn),
    .hSel(cntl_hSel),
    .hDOut(cntl_hDOut),
    .status(cntl_status),
    // sdram interface
    .cke(sdram_m.cke),
    .cs_n(sdram_m.cs_n),
    .ras_n(sdram_m.ras_n),
    .cas_n(sdram_m.cas_n),
    .we_n(sdram_m.we_n),
    .ba(sdram_m.ba),
    .sAddr(sdram_m.sAddr),
    .sD(cntl_sD),
    .sQ(cntl_sQ),
    .dqm(sdram_m.dqm)
) ;

//----------------------------------------------------------------------------
// Generate global signals for the SDRAM
//----------------------------------------------------------------------------

// Choose to let the SDRAM operate on opposite clock edges
// Should be coeherent with the sdramcntl parameters
//assign sdram_clk = ~wb_s.clk ;

// The sdramcntl wait for PLL to be locked via the "lock" signal"
// here we simply consider that the PLL is always locked....
// should be updated in real life...
assign cntl_lock = ~wb_s.rst ;

// Generate the DATA bus signals
assign cntl_sD = sdram_m.sDQ ;
assign sdram_m.sDQ = (!sdram_m.we_n && !sdram_m.cs_n) ? cntl_sQ : 'Z ;
// Propagate sdram_clk 
assign sdram_m.clk = sdram_clk ;

endmodule
