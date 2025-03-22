`timescale 1ns/1ps;

module bit_FA(a,b,cin,out,cout);
    input wire a,b,cin;
    output reg out,cout;

    always @(*) begin
        {cout,out} = a + b + cin;
    end

endmodule

module bit_FA_df(a,b,cin,out,cout);
    input wire a,b,cin;
    output wire out,cout;

    assign {cout,out} = a+b+cin;
endmodule

module testbench();
    reg a,b,cin;
    wire out,cout;

    bit_FA_df uut(a,b,cin,out,cout);

    initial
        $monitor("time : %0t, a = %b , b = %b, cin = %b, out = %b, cout = %b", $time,a,b,cin,out,cout);

    initial begin
        a = 1'b0;
        b = 1'b0;
        cin = 1'b0;
        #5
        a = 1'b0; b=1'b1; cin=1'b0; #5;
        a = 1'b1; b=1'b1; cin=1'b0; #5;
        a = 1'b1; b=1'b1; cin=1'b1; #5;
        a = 1'b1; b=1'b0; cin=1'b1; #5;
        a = 1'b0; b=1'b1; cin=1'b1; #5;
        $finish;

    end 
endmodule

