module MCE #(parameter SIZE = 8)(
	input [SIZE-1:0]A,
	input [SIZE-1:0]B,
	output [SIZE-1:0]MAX,
	output [SIZE-1:0]MIN
	);

assign MAX = (A>B)?A:B;
assign MIN = (A<B)?A:B;

endmodule
