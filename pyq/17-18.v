`timescale 1ns/1ps

module MUX_SMALL(in1, in2, sel, out);
    input in1,in2,sel;
    output out;

    assign out = (sel) ? in2 : in1;
endmodule

module MUX_BIG(data,sel,out);
    input wire [7:0] data;
    input wire [2:0] sel;
    output wire out;

    wire m1_out,m2_out,m3_out,m4_out,m5_out,m6_out,m7_out;

    MUX_SMALL m1(data[0], data[1], sel[0], m1_out);
    MUX_SMALL m2(data[2], data[3], sel[0], m2_out);
    MUX_SMALL m3(data[4], data[5], sel[0], m3_out);
    MUX_SMALL m4(data[6], data[7], sel[0], m4_out);

    MUX_SMALL m5(m1_out, m2_out, sel[1], m5_out);
    MUX_SMALL m6(m3_out, m4_out, sel[1], m6_out);

    MUX_SMALL m7(m5_out, m6_out, sel[2], out);

endmodule

module TFF(T,Q,clk,clear);
    input wire T,clk,clear;
    output reg Q;

    always @(posedge clk , posedge clear) begin
        if(clear) Q <= 1'b0;
        else Q <= (Q^T);
    end
endmodule

module Counter_4BIT(clear,clk,Q);
    input wire clk,clear;
    output wire [3:0] Q;

    TFF t1(1'b1,Q[0],clk,clear);
    TFF t2(Q[0],Q[1],clk,clear);
    TFF t3((Q[0]&Q[1]),Q[2],clk,clear);
    TFF t4(Q[0]&Q[1]&Q[2],Q[3],clk,clear);
    
endmodule

module Counter_3BIT(clear,clk,Q);
    input wire clk,clear;
    output wire [2:0] Q;

    TFF t1(1'b1,Q[0],clk,clear);
    TFF t2(Q[0],Q[1],clk,clear);
    TFF t3((Q[0]&Q[1]),Q[2],clk,clear);
    
endmodule

module MEMOERY(address, data);
    input wire [3:0] address;
    output wire [7:0] data;

    reg [7:0] mem [15:0];

    initial begin
        mem[0] = 8'hCC;
        mem[1] = 8'hAA;
        mem[2] = 8'hCC;
        mem[3] = 8'hAA;
        mem[4] = 8'hCC;
        mem[5] = 8'hAA;
        mem[6] = 8'hCC;
        mem[7] = 8'hAA;
        mem[8] = 8'hCC;
        mem[9] = 8'hAA;
        mem[10] = 8'hCC;
        mem[11] = 8'hAA;
        mem[12] = 8'hCC;
        mem[13] = 8'hAA;
        mem[14] = 8'hCC;
        mem[15] = 8'hAA;
    end

    assign data = mem[address]; 
endmodule

module INTG(clear,clk,op,Q2,Q,data,clk2);
    input wire clear,clk;
    output wire op;

    output wire clk2;
    output wire [3:0] Q;
    output wire [2:0] Q2;
    output wire [7:0] data;

    assign clk2 = Q2[0]&Q2[1]&Q2[2];

    Counter_4BIT cnt1(clear,clk2,Q);
    MEMOERY m(Q, data);
    MUX_BIG mux(data,Q2,op);
    Counter_3BIT cnt2(clear,clk,Q2);

endmodule

module testbench();
    reg clear,clk;
    wire op;
    wire [2:0] temp;
    wire [3:0] temp2;
    wire [7:0] temp3;
    wire clk2;

    INTG uut(clear,clk,op,temp,temp2,temp3,clk2);

    initial
        $monitor("time : %0t, clear : %b , clk : %b, op : %b, temp: %b, temp2 : %b, temp3 : %b, clk2 : %b", $time,clear,clk,op,temp,temp2,temp3,clk2);

    always 
        #5 clk = ~clk;

    initial begin
        clk = 0; clear = 1;
        #2 clear = 0;
        #200 $finish;
    end
endmodule