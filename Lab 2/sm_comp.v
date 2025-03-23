`timescale 1ns/1ps;

module num_sign(a,sign);
    input wire [3:0] a;
    output reg sign;

    always @(*) begin
        if(a[3] == 1) sign = 1;
        else sign = 0;
    end
endmodule

module bit4_comp(a,b,lt,gt,eq);
    input wire [3:0] a,b;
    output reg lt,gt,eq;

    wire signa, signb;

    num_sign uut1(a,signa);
    num_sign uut2(b,signb);

    always @(*) begin
        lt = 0;
        gt = 0;
        eq = 0;
        if(signa == 1 && signb == 0) lt = 1;
        else if(signa == 0 && signb == 1) gt = 1;
        else begin
            if(a>b) gt = 1;
            else if(a<b) lt = 1;
            else eq = 1;
        end
    end
endmodule

module testbench();
    reg [3:0] a,b;
    wire lt,gt,eq;

    bit4_comp uut1(a,b,lt,gt,eq);

    initial
        $monitor("time : %0t, a = %b, b = %b, lt = %b, gt = %b, eq = %b",$time,a,b,lt,gt,eq);

    initial begin
        a = 4'b0000; b = 4'b0000; #4
        a = 4'b0001; b = 4'b0011; #4
        a = 4'b1100; b = 4'b0110; #4
        a = 4'b0110; b = 4'b0000; #4
        a = 4'b1110; b = 4'b1101; #4
        a = 4'b1001; b = 4'b0110; #4
        a = 4'b0101; b = 4'b1010; #4
        a = 4'b1111; b = 4'b1110; #4
        $finish;
    end
endmodule