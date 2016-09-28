module foo();

initial
begin
	// $display est une tache système
	$display("hello world");
end

endmodule


module mux21(
	input s,
	input a, b,
	output logic o
	);

always@(s,a,b)
	if(s) o<=a;
	else  o<=b;

endmodule
