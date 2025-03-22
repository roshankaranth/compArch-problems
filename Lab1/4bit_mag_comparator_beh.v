`timescale 1ns/1ps

module bit4_mag_comparator(a,b,lt,gt,eq);

    input wire [3:0] a,b;
    output reg lt,gt,eq;

    always @(*) begin
        lt = 0;
        gt = 0;
        eq = 0;

        if(a>b) gt = 1;
        else if(a<b) lt = 1;
        else eq = 1;
    end

endmodule

module testbench();

    reg [3:0] a,b;
    wire lt,gt,eq;

    bit4_mag_comparator uut(a,b,lt,gt,eq);

    initial
    $monitor("time = %0t, a = %b, b = %b, lt = %b, eq = %b, gt = %b",$time,a,b,lt,eq,gt);

    initial begin
    a = 4'b0000;
    b = 4'b0000;
    #5;
    a = 4'b0000; b = 4'b0000; #5;
    a = 4'b0001; b = 4'b0000; #5;
    a = 4'b0011; b = 4'b0100; #5;
    a = 4'b1100; b = 4'b1000; #5;
    a = 4'b1100; b = 4'b1100; #5;
    a = 4'b1010; b = 4'b1011; #5;
    a = 4'b1011; b = 4'b1011; #5;
    $finish;
    
    end

endmodule