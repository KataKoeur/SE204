// Définition de l'interface vers une SDRAM
interface sdram_if #(
        parameter int unsigned DATA_BYTES           =  2,       // host & SDRAM data width
        parameter int unsigned SADDR_WIDTH          =  13,      // SDRAM-side address width
        parameter int unsigned BA_WIDTH             =  2        // Bank address width
) () ;

// Signals
wire  clk                       ; // clock for SDRAM
wire  cke                       ; // clock-enable to SDRAM
wire  cs_n                      ; // chip-select to SDRAM
wire  ras_n                     ; // SDRAM row address strobe
wire  cas_n                     ; // SDRAM column address strobe
wire  we_n                      ; // SDRAM write enable
wire  [BA_WIDTH-1:0]  ba        ; // SDRAM bank address
wire  [SADDR_WIDTH-1:0] sAddr   ; // SDRAM row/column address
wire  [8*DATA_BYTES-1:0] sDQ    ; // data to and from DRAM
wire  [DATA_BYTES-1:0]  dqm     ; // enable bytes of SDRAM databus

modport master   (
                 output  clk    , // clock for SDRAM
                 output  cke    , // clock-enable to SDRAM
                 output  cs_n   , // chip-select to SDRAM
                 output  ras_n  , // SDRAM row address strobe
                 output  cas_n  , // SDRAM column address strobe
                 output  we_n   , // SDRAM write enable
                 output  ba     , // SDRAM bank address
                 output  sAddr  , // SDRAM row/column address
                 inout   sDQ    , // data to and from DRAM
                 output  dqm      // enable bytes of SDRAM databus
                 );

modport slave     (
                  input  clk    , // clock for SDRAM
                  input  cke    , // clock-enable to SDRAM
                  input  cs_n   , // chip-select to SDRAM
                  input  ras_n  , // SDRAM row address strobe
                  input  cas_n  , // SDRAM column address strobe
                  input  we_n   , // SDRAM write enable
                  input  ba     , // SDRAM bank address
                  input  sAddr  , // SDRAM row/column address
                  inout  sDQ    , // data to and from DRAM
                  input  dqm      // enable bytes of SDRAM databus
                  );
endinterface
