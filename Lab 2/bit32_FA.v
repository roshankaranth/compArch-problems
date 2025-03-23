`timescale 1ns/1ps;

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

module bit8_FA(a,b,cin,cout,s);
    input wire [7:0] a,b;
    input wire cin;
    output wire [7:0] s;
    output wire cout;

    wire [6:0] carry;

    FA uut1(a[0],b[0],cin,carry[0],s[0]);
    FA uut2(a[1],b[1],carry[0],carry[1],s[1]);
    FA uut3(a[2],b[2],carry[1],carry[2],s[2]);
    FA uut4(a[3],b[3],carry[2],carry[3],s[3]);
    FA uut5(a[4],b[4],carry[3],carry[4],s[4]);
    FA uut6(a[5],b[5],carry[4],carry[5],s[5]);
    FA uut7(a[6],b[6],carry[5],carry[6],s[6]);
    FA uut8(a[7],b[7],carry[6],cout,s[7]);

endmodule

module bit32_FA(a,b,cin,cout,s);
    input wire [31:0] a,b;
    input wire cin;
    output wire cout;
    output wire [31:0] s;

    wire [2:0] carry;

    bit8_FA uut1(a[7:0],b[7:0],cin,carry[0],s[7:0]);
    bit8_FA uut2(a[15:8],b[15:8],carry[0],carry[1],s[15:8]);
    bit8_FA uut3(a[23:16],b[23:16],carry[1],carry[2],s[23:16]);
    bit8_FA uut4(a[31:24],b[31:24],carry[2],cout,s[31:24]);

endmodule

module testbench();
    reg [31:0] a,b;
    reg cin;
    wire [31:0] s;
    wire cout;

    bit32_FA uut(a,b,cin,cout,s);

    initial
        $monitor("time : %0t, a = %b, b = %b, cin = %b, s = %b, cout = %b", $time,a,b,cin,s,cout);

    initial begin
           a=32'b00000000000000000000000000000000; b=32'b00000000000000000000000000000000; cin=1'b0;
        #4 a=32'b00000000000000000000000000000000; b=32'b00000000000000000000000000000001; cin=1'b0;
        #4 a=32'b00000000000000000000000000000000; b=32'b00000000000000000000000000000001; cin=1'b1;
        #4 a=32'b00000000000000000000000000000000; b=32'b00000000000000000000000000000010; cin=1'b0;
        #4 a=32'b00000000000000000000000000000000; b=32'b00000000000000000000000000000010; cin=1'b1;
        #4 a=32'b00000000000000000000000000000000; b=32'b00000000000000000000000000000011; cin=1'b0;
        #4 a=32'b00000000000000000000000000000000; b=32'b00000000000000000000000000000011; cin=1'b1;
        #4 a=32'b00000000000000000000000000000000; b=32'b00000000000000000000000000000100; cin=1'b0;
        #4 a=32'b00000000000000000000000000000000; b=32'b00000000000000000000000000000100; cin=1'b1;
        #4 a=32'b00000000000000000000000000000000; b=32'b00000000000000000000000000000101; cin=1'b0;
        #4 a=32'b00000000000000000000000000000000; b=32'b00000000000000000000000000000101; cin=1'b1;
        #4 $finish;
    end
endmodule