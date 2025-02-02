`timescale 1ns/1ps

module mux2to1_beh(a,b,s,f);
	input a,b,s;
	output f;
	reg f;
	always@(s or a or b)
		if (s==1) f = a;
		else f = b;

endmodule

module testbench;
	
	reg a,b,s;
	wire f;
	mux2to1_beh mux_beh (a,b,s,f);
	initial
		begin
			$dumpfile("mux2to1_gate.vcd");
			$dumpvars;
			$monitor("time = %0t a=%b, b=%b, s=%b, f=%b", $time, a, b, s, f);
			
			#0 a=1'b0;b=1'b1; s=1'b1;
			#5 s=1'b0;
			#10 a=1'b1;b=1'b0;
			#15 s=1'b1;
			#20 s=1'b0;
			#100 $finish;

		end
endmodule