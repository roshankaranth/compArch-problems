`timescale 1ns/1ps

module D_ff(d,clk,q);
    input wire d,clk;
    output reg q;

    initial 
        q = 0;

    always @(posedge clk) begin
        q <= d;
    end
endmodule

module ControlLogic(s,z,x,clk, T);
    input wire z,x,clk,s;
    output wire [2:0] T;

    D_ff d1(((T[0]&(~s)) | (T[2]&z)),clk,T[0]);
    D_ff d2(((T[0]&(s)) | (T[2]&(~x)&(~z)) | (T[1]&(~x))),clk,T[1]);
    D_ff d3(((T[0]&x) | (T[2]&(~z)&x)),clk,T[2]);

endmodule

module T_FF(T,Q,clear,clk,enable);
    input wire T,clear,clk,enable;
    output reg Q;

    initial
        Q=0;
    always @(posedge clk) begin
        if(clear) Q <= 1'b0;
        else if(enable) Q <= (Q^T);
    end
endmodule

module COUNTER_4BIT(clk,Q,clear,enable);
    input wire clk,clear,enable;
    output wire [3:0] Q;

    T_FF t1(1'b1,Q[0],clear,clk,enable);
    T_FF t2(Q[0],Q[1],clear,clk,enable);
    T_FF t3((Q[0]&Q[1]),Q[2],clear,clk,enable);
    T_FF t4((Q[0]&Q[1]&Q[2]),Q[3],clear,clk,enable);
    
endmodule

module INTG(s,clk,Q,G,x,T);
    input wire s,clk,x;
    output wire [3:0] Q;
    output wire G;
    wire z;
    output wire [2:0] T;

    assign z = Q[0]&Q[1]&Q[2]&Q[3];

    ControlLogic c(s,z,x,clk, T);
    COUNTER_4BIT cnt(clk,Q,T[0]&s,((T[1]&x) | (T[2]&(x)&(~z))));
    D_ff d(z&T[2],clk,G);
endmodule

module Testbench();
    reg clk,s,x;
    wire [3:0] Q;
    wire G;
    wire [2:0] T;

    INTG uut(s,clk,Q,G,x,T);

    initial
        $monitor("time : %0t, Q : %b, G : %b, T : %b", $time,Q,G,T);

    always 
        #5 clk = ~clk;

    initial begin
        clk = 0; s= 0;
        #6 s=1;
        #6 x = 0;
        #6 x = 0;
        #6 x = 0;
        #6 x = 0;
        #6 x = 0;
        #6 x = 1;
        #120 $finish;
    end

endmodule