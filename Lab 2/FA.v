`timescale 1ns/1ps

module DECODER(in,out);
    input wire [2:0] in;
    output reg [7:0] out;

    always @(*) begin
        if(in == 0) out = 8'b00000001;
        else if(in == 1) out = 8'b00000010;
        else if(in == 2) out = 8'b00000100;
        else if(in == 3) out = 8'b00001000;
        else if(in == 4) out = 8'b00010000;
        else if(in == 5) out = 8'b00100000;
        else if(in == 6) out = 8'b01000000;
        else if(in == 7) out = 8'b10000000;
    end
endmodule

module FA(a,b,cin,cout,s);
    input wire a,b,cin;
    output wire cout,s;

    wire [7:0] out;

    DECODER uut1({a,b,cin},out);

    assign s = out[1] | out[2] | out[4] | out[7];
    assign cout = out[3] | out[5] | out[6] | out[7]; 
endmodule

module testbench();
    reg a,b,cin;
    wire cout,s;

    FA uut(a,b,cin,cout,s);

    initial
        $monitor("time : %0t, a = %b, b = %b, cin = %b, s = %b, cout = %b", $time,a,b,cin,s,cout);

    initial begin
        #0 a=1'b0;b=1'b0;cin=1'b0;
        #4 a=1'b1;b=1'b0;cin=1'b0;
        #4 a=1'b0;b=1'b1;cin=1'b0;
        #4 a=1'b1;b=1'b1;cin=1'b0;
        #4 a=1'b0;b=1'b0;cin=1'b1;
        #4 a=1'b1;b=1'b0;cin=1'b1;
        #4 a=1'b0;b=1'b1;cin=1'b1;
        #4 a=1'b1;b=1'b1;cin=1'b1;
        #4 $finish;
    end
endmodule