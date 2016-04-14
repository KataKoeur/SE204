module av2wb #(AW=32,DW=64,TW=2,MAX_OUTSTANDING=2) (
  input logic clk,rst_n,

  input logic  [AW-1:0]   	av_address,
  input logic  [DW/8-1:0] 	av_byteenable,
  input logic           	av_chipselect,
  input logic           	av_read,
  input logic           	av_write,
  output logic  [DW-1:0] 	av_readdata,
  input logic  [DW-1:0] 	av_writedata,
  output logic           	av_waitrequest,
  output logic           	av_readdatavalid,

  /// common signals ///
  input logic [DW-1:0] 	wb_dat_i,  
  output logic [DW-1:0] wb_dat_o,  
  input logic           wb_rst_i,  
  input logic [TW-1:0] 	wb_tgd_i,  
  output logic [TW-1:0] wb_tgd_o,  
  
  
  input logic           	wb_ack,  
  output logic [AW-1:0] 	wb_adr,  
  output logic          	wb_cyc,  
  input logic           	wb_err,  
  output logic          	wb_lock, 
  input logic           	wb_rty,  
  output logic [DW/8-1:0] 	wb_sel,  
  output logic             	wb_stb,  
  output logic [TW-1:0] 	wb_tga,  
  output logic [TW-1:0] 	wb_tgc,  
  output logic             	wb_we   
  //put logic 	      stall, //signal added in wishbone B4, equivalet to AXI ready.
);
logic av_valid,wb_ready,wb_stall;
logic [1:0] count,n_count; //max outstanding 4
always @* av_valid = av_chipselect && (av_read || av_write);
//see p.84 WB B4 spec, wayto connect pipelined master to simple slave
always @* wb_stall=!wb_cyc?1'b0:!wb_ack;
always @* wb_ready = !wb_stall;


always_comb begin
//always @(av_valid,av_address,av_read,av_write) begin
	
	wb_dat_o=av_writedata;
	wb_tgd_o='0;
	wb_adr=av_address;
	if(!rst_n|| count==0) wb_cyc=av_valid; else wb_cyc=1'b1;
	wb_lock=1'b0;
	wb_sel=av_byteenable;
        wb_stb=av_valid;
        wb_tga='0;
        wb_tgc='0;
	if(av_read) wb_we=1'b0;
	else	    wb_we=1'b1;
	//av_waitrequest=(wb_stall);
	av_waitrequest=!wb_cyc?1'b0:!wb_ack;
	
end
//need to delay the readdatavalid by one cycle as avalon doesn't expect combinatorial 
//response 
always_ff @(posedge clk) 
	if(!rst_n) begin
		count<=0;
		av_readdatavalid<=1'b0;
		av_readdata<='0;
	end else begin
		count<=n_count;
		if(av_read) begin 
				av_readdatavalid<=wb_ack;
				av_readdata<=wb_dat_i;
		end else begin 
			av_readdatavalid<=1'b0;
			av_readdata<='0;
		end
	end
always_comb
	begin
	n_count=count;
		if(!wb_stall) 
			case({wb_stb,wb_ack})
				2'b10: n_count=count+1;
				2'b01: n_count=count-1;
				default: n_count=count;
			endcase
		else if (wb_stall)
			case({wb_stb,wb_ack})
				2'b01: n_count=count-1;
				2'b11: n_count=count-1;
				default: n_count=count;
			endcase
	end
endmodule
//task do_stall(avalon_if av, wishbone_b3_if  wb);
