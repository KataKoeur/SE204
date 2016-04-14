`ifndef AVALON_IF__SV
`define AVALON_IF__SV


interface avalon_if #(AW=32,DW=64,TW=2)(input bit clk,rst_n);
  logic  [AW-1:0]   	address;
  logic  [DW/8-1:0] 	byteenable;
  logic           	chipselect;
  logic           	read;
  logic           	write;
  logic  [DW-1:0] 	readdata;
  logic  [DW-1:0] 	writedata;
  logic           	waitrequest;
  logic           	readdatavalid;
//  logic  [3:0]   	burstcount;
//  logic           	beginbursttransfer;
//  // Clocking block
  modport m_cb (
    output address,
    output byteenable,
    output chipselect,
    output read,
    output write,
    output writedata,
//    output burstcount,
//    output beginbursttransfer,
    input  readdata,
    input  waitrequest,
    input  readdatavalid
  );
//  // Slave Clocking block
  modport s_cb(
    input address,
    input byteenable,
    input chipselect,
    input read,
    input write,
    input writedata,
//    input burstcount,
//    input beginbursttransfer,
    output  readdata,
    output  waitrequest,
    output  readdatavalid
  );
endinterface

`endif
