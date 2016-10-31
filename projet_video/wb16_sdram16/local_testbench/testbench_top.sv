/*
Copyright (C) 2009 SysWip

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

`timescale 1ns/10ps

module testbench_top;
  // Clock generator
  bit clk;
  bit reset ;
  initial begin
    forever #5 clk = ~clk;
  end
  initial
  begin
     reset = 1 ;
     #20 ;
     reset = 0 ;
  end
  //

  // Wishbone 16 bits interface with a master testbench
  wshb_if #(.DATA_BYTES(2), .TB_MASTER(1))  wshb_if_0(clk,reset);
  // Virtual tb_master modport  for the testbench
  typedef virtual wshb_if #(.DATA_BYTES(2), .TB_MASTER(1)).tb_master  virtual_master_t ;

  // SDRAM interface 16 bits for DE1
  sdram_if #(.DATA_BYTES(2), .SADDR_WIDTH(13),.BA_WIDTH(2)) sdram_if_0() ; 

  // Test
  test #(virtual_master_t) u_test();


  // Pour le testbench on se contente de cela pour l'horloge
  assign dram_clk = ~clk ;


  wb16_sdram16 u_sdram_ctrl
  (
   // Wishbone 16 bits slave interface
   .wb_s(wshb_if_0.slave),
   // SDRAM
   .sdram_m(sdram_if_0.master),
   .sdram_clk(dram_clk) 
  );

// sdram

  sdr #(.Debug(0)) SDRAM
  (
                  .Clk    (sdram_if_0.clk     ),
                  .Cke    (sdram_if_0.cke     ),
                  .Cs_n   (sdram_if_0.cs_n    ),
                  .Ras_n  (sdram_if_0.ras_n   ),
                  .Cas_n  (sdram_if_0.cas_n   ),
                  .We_n   (sdram_if_0.we_n    ),
                  .Addr   (sdram_if_0.sAddr   ),
                  .Ba     (sdram_if_0.ba      ),
                  .Dq     (sdram_if_0.sDQ     ),
                  .Dqm    (sdram_if_0.dqm     )
 ) ;


endmodule
