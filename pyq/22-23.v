`timescale 1ns/1ps

module REG_8BIT(reg_out,num_in,clock,reset);
    input wire clock,reset;
    input wire [7:0] num_in;
    output reg [7:0] reg_out;

    always @(posedge clock) begin
        if(reset) reg_out <= 7'b0000000;
        else reg_out <= num_in;
    end
endmodule

module EXPANSION_BOX(in,out);
    input wire [3:0] in;
    output wire [7:0] out;

    assign out = {in[3],in[0],in[1],in[2],in[1],in[3],in[2],in[0]};
endmodule

module XOR_8BIT(xout_8, xin1_8, xin2_8);
    output wire [7:0] xout_8;
    input wire [7:0] xin1_8, xin2_8;

    assign xout_8 = (xin1_8^xin2_8);
endmodule

module XOR_4BIT(xout_4, xin1_4, xin2_4);
    output wire [3:0] xout_4;
    input wire [3:0] xin1_4, xin2_4;

    assign xout_4 = (xin1_4^xin2_4);
endmodule

module FA_1bit(intA, intB, cin, out, cout);
    input intA, intB, cin;
    output cout,out;

    assign {cout,out} = intA + intB + cin;
endmodule

module FA_4bit(intA, intB, cin, out, cout);
    input wire [3:0] intA,intB;
    input wire cin;
    output wire cout;
    output wire [3:0] out;

    wire [2:0] temp;

    FA_1bit fa1(intA[0], intB[0], cin, out[0], temp[0]);
    FA_1bit fa2(intA[1], intB[1], temp[0], out[1], temp[1]);
    FA_1bit fa3(intA[2], intB[2], temp[1], out[2], temp[2]);
    FA_1bit fa4(intA[3], intB[3], temp[2], out[3], cout);
    
endmodule

module mux_2to1(in1, in2, sel,out);
    input wire in1,in2,sel;
    output wire out;

    assign out = (sel) ? in2 : in1;

endmodule

module mux_2to1_4bit(in1, in2, sel,out);
    input wire [3:0] in1,in2;
    output wire [3:0] out;
    input wire sel;

    assign out = (sel) ? in2 : in1;

endmodule

module CSA_4BIT(cin, intA, intB, cout, out);
    input wire [3:0] intA, intB;
    output wire [3:0] out;
    input wire cin;
    output wire cout;

    wire [3:0] out1,out2;
    wire cout1,cout2;
    FA_4bit fa1(intA, intB, 1'b1, out1, cout1);
    FA_4bit fa2(intA, intB, 1'b0, out2, cout2);

    mux_2to1 m1(cout1, cout2, cin,cout);
    mux_2to1_4bit m2(out1, out2, cin,out);

endmodule

module CONCAT(concat_out, concat_in1, concat_in2);
    output wire [7:0] concat_out;
    input wire [3:0] concat_in1, concat_in2;

    assign concat_out = {concat_in1,concat_in2};
endmodule

module ENCRYPT(number, key, clock, reset, enc_number);
    input wire [7:0] number,key;
    input wire clock,reset;
    output wire [7:0] enc_number;

    wire [7:0] reg_out1, reg_out2;
    wire [7:0] eout;
    wire [7:0] xout_8;
    wire [3:0] out;
    wire cout;
    wire [3:0] xout_4;

    REG_8BIT r1(reg_out1,number,clock,reset);
    REG_8BIT r2(reg_out2,key,clock,reset);

    EXPANSION_BOX e1(reg_out1[3:0],eout);
    XOR_8BIT x1(xout_8, eout, reg_out2);
    CSA_4BIT c1(reg_out2[0], xout_8[7:4], xout_8[3:0], cout, out);
    XOR_4BIT x2(xout_4, out, reg_out1[7:4]);
    CONCAT c2(enc_number, xout_4, reg_out1[3:0]);

endmodule

module testbench();
    reg [7:0] number,key;
    reg clock,reset;
    wire [7:0] enc_number;

    ENCRYPT uut(number,key,clock,reset,enc_number);

    always
        #5 clock = ~clock;

    initial
        $monitor("time : %0t, number : %b, key : %b, enc_number : %b", $time, number, key, enc_number);

    initial begin
        clock = 0; reset = 1;
        #15 reset = 0; number = 8'b0100_0110; key = 8'b1001_0011;
        #10 number = 8'b1100_1001; key = 8'b1010_1100;
        #10 number = 8'b1010_0101; key = 8'b0101_1010;
        #10 number = 8'b1111_0000; key = 8'b1011_0001;
        #10 $finish;
    end
endmodule


