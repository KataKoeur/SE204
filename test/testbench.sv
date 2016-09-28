module testbench();

	logic a,b,s;
	wire o;

	mux21 dut(.a(a),.b(b),.s(s),.o(o));

	initial
	begin
		a=0;
		b=1;
		s=0;
		
		#10ns;

		s=1;

		#10ns;

		s=0;
	end

endmodule
