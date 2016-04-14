`default_nettype none

module clusterip(
	// inputs:
	input logic  [1:0] address,
	input logic  chipselect,
	input logic  clk,
	input logic  reset_n,
	input logic  write_n,
	input logic  [31:0] writedata,
	input logic  [9:0] SW,
	//input logic  key,
	
	// outputs:
	output logic [31:0] readdata,
	output logic [9:0]	leds,
    output logic [6:0] HEX0,
    output logic [6:0] HEX1,
    output logic [6:0] HEX2,
    output logic [6:0] HEX3,
    output logic [6:0] HEX4,
    output logic [6:0] HEX5
);
logic [31:0] datareg[4];
logic [31:0] mydata;
logic my_write;
logic finishl,finishr;
logic sig_start;
logic [9:0] led_internal;

always @* begin
    sig_start <=datareg[1][0];
    leds[9:0]<=led_internal[9:0];
end 
SEG7_LUT_8 inst_SEG7_LUT_8(HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,datareg[2][23:0]);
K2000 K2000l(.clock_50(clk),.reset_n(reset_n),.ledr(led_internal),.finishl(finishl),.finishr(finishr),.start(sig_start));
assign my_write = 1'b0;

always@(*) 
	begin
	readdata <= datareg[address];
	end

    always @(posedge clk or negedge reset_n)
    if(!reset_n) 
    begin
 	    datareg[0]<=32'h00000000;
        datareg[1]<=32'h00000000;
        datareg[2]<=32'h00000000;
        datareg[3]<=32'h00000000;
	end
    else
        begin
            if(my_write)
                datareg[address]<=mydata;
            else if (chipselect && ~write_n)
                datareg[address]<=writedata;

		    if	(finishl==1'b1) 
                datareg[0]<=32'h00000001;
		    else if (finishr==1'b1) 
                datareg[0]<=32'h00000002;
            else
                datareg[0]<=32'h00000000;

	    datareg[3]<={22'd0,SW[9:0]};
        end

endmodule


