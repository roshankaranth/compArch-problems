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

module tb_FADDER;
    reg a,b,c;
    wire sum,cout;

    FADDER f1(a,b,c,sum,cout);

    initial begin
        $monitor("a=%b, b=%b, c=%b, sum=%b, cout=%b",a,b,c,sum,cout);
    end

    initial begin
        a = 0; b = 0; c = 0;
        #10 a = 1; b = 1; c = 1;
        #10 a = 1; b = 1; c = 0;
        #10 a = 1; b = 0; c = 1;
        #10 a = 0; b = 1; c = 1;
        #10 $finish;
    end

endmodule
