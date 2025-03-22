`timescale 1ns/1ps;

module bit_FA(a,b,cin,out,cout);
    input wire a,b,cin;
    output reg out,cout;

    always @(*) begin
        {cout,out} = a + b + cin;
    end

endmodule

module bit4_FA(a,b,cin,out,cout);
    input wire [3:0] a,b;
    input wire cin;
    output wire [3:0] out;
    output wire cout;

    wire [2:0] carry;

    bit_FA uut1(a[0],b[0],cin,out[0],carry[0]);
    bit_FA uut2(a[1],b[1],carry[0],out[1],carry[1]);
    bit_FA uut3(a[2],b[2],carry[1],out[2],carry[2]);
    bit_FA uut4(a[3],b[3],carry[2],out[3],cout);
endmodule

module testbench();
    reg [3:0] a,b;
    reg cin;
    wire [3:0] out;
    wire cout;

    bit4_FA uut(a,b,cin,out,cout);

    initial
        $monitor("time : %0t, a = %b, b = %b, cin = %b, out = %b, cout = %b", $time,a,b,cin,out,cout);

    initial begin
        a = 4'b0000; b = 4'b0000; cin = 1'b0; #5
        a = 4'b0000; b = 4'b0000; cin = 1'b1; #5;
        a = 4'b0001; b = 4'b0000; cin = 1'b0;#5;
        a = 4'b0011; b = 4'b0100; cin = 1'b1;#5;
        a = 4'b1100; b = 4'b1000; cin = 1'b0;#5;
        a = 4'b1100; b = 4'b1100; cin = 1'b1;#5;
        a = 4'b1010; b = 4'b1011; cin = 1'b0;#5;
        a = 4'b1011; b = 4'b1011; cin = 1'b1;#5;
    end

endmodule