`default_nettype none

interface vga_if() ;

logic VGA_CLK;
logic VGA_HS;
logic VGA_VS;
logic VGA_BLANK;
logic VGA_SYNC;
logic [7:0] VGA_R;
logic [7:0] VGA_G;
logic [7:0] VGA_B;

modport master (
         output VGA_CLK,
         output VGA_HS,
         output VGA_VS,
         output VGA_BLANK,
         output VGA_SYNC,
         output VGA_R,
         output VGA_G,
         output VGA_B
) ;

modport slave (
         input VGA_CLK,
         input VGA_HS,
         input VGA_VS,
         input VGA_BLANK,
         input VGA_SYNC,
         input VGA_R,
         input VGA_G,
         input VGA_B
) ;

endinterface
