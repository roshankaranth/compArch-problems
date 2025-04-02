`timescale 1ns/1ps

module RSFF(s, r, q, clk, reset);
    input wire s,r,clk,reset;
    output reg q;

    always @(posedge clk) begin
        if(reset) q <= 0;
        else begin
            case ({s,r})
                2'b01 : q<= 1'b0;
                2'b10 : q<= 1'b1;
                2'b11 : q<= 1'b1;
            endcase
        end
    end

endmodule

module DFF(d,q,clk,reset);
    input wire d,clk,reset;
    output wire q;

    RSFF rs(d,~d,q,clk,reset);
endmodule

module Ripple_Counter(clk, reset, q);
    input wire clk,reset;
    output wire [3:0] q;

    DFF d1(~q[0],q[0],clk,reset);
    DFF d2(~q[1],q[1],~q[0],reset);
    DFF d3(~q[2],q[2],~q[1],reset);
    DFF d4(~q[3],q[3],~q[2],reset);
    
endmodule

module MEM1(address, data, parity);
    input wire [2:0] address;
    output wire [7:0] data;
    output wire parity;

    reg [8:0] mem [7:0];

    initial begin
        mem[0] = 9'b0001_1111_1;
        mem[1] = 9'b0011_0001_1;
        mem[2] = 9'b0101_0011_1;
        mem[3] = 9'b0111_0101_1;
        mem[4] = 9'b1001_0111_1;
        mem[5] = 9'b1011_1001_1;
        mem[6] = 9'b1101_1011_1;
        mem[7] = 9'b1111_1101_1;
    end

    assign {data,parity} = mem[address]; 

endmodule

module MEM2(address, data, parity);
    input wire [2:0] address;
    output wire [7:0] data;
    output wire parity;

    reg [8:0] mem [7:0];

    initial begin
        mem[0] = 9'b0000_0000_0;
        mem[1] = 9'b0010_0010_0;
        mem[2] = 9'b0100_0100_0;
        mem[3] = 9'b0110_0110_0;
        mem[4] = 9'b1000_1000_0;
        mem[5] = 9'b1010_1010_0;
        mem[6] = 9'b1100_1100_0;
        mem[7] = 9'b1110_1101_0;
    end

    assign {data,parity} = mem[address]; 

endmodule

module MUX2TO1(in1, in2, sel, out);
    input in1,in2,sel;
    output out;

    assign out = (sel) ? in2 : in1;

endmodule

module MUX16TO8(in1,in2,sel,out);
    input wire [7:0] in1,in2;
    input sel;
    output [7:0] out;

    MUX2TO1 m1(in1[0], in2[0], sel, out[0]);
    MUX2TO1 m2(in1[1], in2[1], sel, out[1]);
    MUX2TO1 m3(in1[2], in2[2], sel, out[2]);
    MUX2TO1 m4(in1[3], in2[3], sel, out[3]);
    MUX2TO1 m5(in1[4], in2[4], sel, out[4]);
    MUX2TO1 m6(in1[5], in2[5], sel, out[5]);
    MUX2TO1 m7(in1[6], in2[6], sel, out[6]);
    MUX2TO1 m8(in1[7], in2[7], sel, out[7]);

endmodule

module Fetch_data(q,data,parity);
    input wire [3:0] q;
    output wire [7:0] data;
    output wire parity;

    wire [7:0] data1, data2;
    wire parity1, parity2;

    MEM1 m1(q[2:0], data1, parity1);
    MEM2 m2(q[2:0], data2, parity2);

    MUX16TO8 mux1(data1,data2,q[3],data);
    MUX2TO1 mux2(parity1,parity2,q[3],parity);

endmodule

module parity_checker(data, parity, out);
    input wire [7:0] data;
    input wire parity;
    output wire out;

    assign out = (((data[0]^data[1]^data[2]^data[3]^data[4]^data[5]^data[6]^data[7])) == parity) ? 1 : 0;
endmodule

module DESIGN(clk,reset,out, q, data, parity);
    input wire clk,reset;
    output wire out;

    output wire [3:0] q;
    output wire [7:0] data;
    output wire parity;


    Ripple_Counter c(clk, reset, q);
    Fetch_data f(q,data,parity);
    parity_checker pc(data, parity, out);

endmodule

module testbench();
    reg clk,reset;
    wire out;
    wire [3:0] q;
    wire [7:0] data;
    wire parity;

    DESIGN uut(clk,reset,out, q, data, parity);

    initial
        $monitor("time : %0t, out : %b, q : %b, data : %b, parity : %b ", $time,out, q, data, parity);

    always 
        #5 clk = ~clk;

    initial begin
        clk = 0 ; reset = 1;
        #6 reset = 0;
        #155 $finish;
    end
endmodule