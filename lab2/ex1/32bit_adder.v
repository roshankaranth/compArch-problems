`timescale 1ns/1ps 

module DECODER(d0,d1,d2,d3,d4,d5,d6,d7,x,y,z);
    input x,y,z;
    output d0,d1,d2,d3,d4,d5,d6,d7;
    wire x0,y0,z0;

    not n1(x0,x);
    not n2(y0,y);
    not n3(z0,z);
    and a0(d0,x0,y0,z0);
    and a1(d1,x0,y0,z);
    and a2(d2,x0,y,z0);
    and a3(d3,x0,y,z);
    and a4(d4,x,y0,z0);
    and a5(d5,x,y0,z);
    and a6(d6,x,y,z0);
    and a7(d7,x,y,z);
endmodule

module FADDER(a,b,c, sum, cout);
    input a,b,c;
    wire d0,d1,d2,d3,d4,d5,d6,d7;
    output sum,cout;

    DECODER d(d0,d1,d2,d3,d4,d5,d6,d7,a,b,c);

    assign sum = (d1| d2 | d4 | d7);
    assign cout = (d3 | d5 | d6 | d7);

endmodule

module adder_8bit(a,b,cin,sum,cout);
    input [7:0]a,b;
    output [7:0]sum;
    output cout;
    input cin;
    wire [6:0]d;

    FADDER f1(a[0],b[0],cin,sum[0],d[0]);
    FADDER f2(a[1],b[1],d[0],sum[1],d[1]);
    FADDER f3(a[2],b[2],d[1],sum[2],d[2]);
    FADDER f4(a[3],b[3],d[2],sum[3],d[3]);
    FADDER f5(a[4],b[4],d[3],sum[4],d[4]);
    FADDER f6(a[5],b[5],d[4],sum[5],d[5]);
    FADDER f7(a[6],b[6],d[5],sum[6],d[6]);
    FADDER f8(a[7],b[7],d[6],sum[7],cout);

endmodule

module adder_32bit(a,b,cin,sum,cout);
    input [31:0]a,b;
    output [31:0]sum;
    output cout;
    input cin;
    wire [2:0]d;

    adder_8bit f1(a[7:0],b[7:0],cin,sum[7:0],d[0]);
    adder_8bit f2(a[15:8],b[15:8],d[0],sum[15:8],d[1]);
    adder_8bit f3(a[23:16],b[23:16],d[1],sum[23:16],d[2]);
    adder_8bit f4(a[31:24],b[31:24],d[2],sum[31:24],cout);

endmodule

module tb_adder_32bit;
    reg [31:0]a,b;
    reg cin;
    wire [31:0]sum;
    wire cout;

    adder_32bit f1(a,b,cin,sum,cout);

    initial begin
        $monitor("a=%b, b=%b, cin=%b, sum=%b, cout=%b",a,b,cin,sum,cout);
    end

    initial begin
            a = 32'b00000000000000000000000000000000; b = 32'b00000000000000000000000000000000; cin = 0;
            #10 a = 32'b11111111111111111111111111111111; b = 32'b11111111111111111111111111111111; cin = 1;
            #10 a = 32'b11111111111111111111111111111110; b = 32'b11111111111111111111111111111111; cin = 0;
            #10 a = 32'b11111111111110111111111111111111; b = 32'b11111111111111111111111111111100; cin = 1;
            #10 a = 32'b00000000000000000000000000000000; b = 32'b11111111111111111111111111111111; cin = 1;
            #10 $finish;

    end
endmodule



