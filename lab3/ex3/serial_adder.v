`timescale 1ns/1ps
module shft_register(inp, CLK, EN,Q);
    parameter n = 4;
    input CLK,EN,inp;
    output reg [n-1:0]Q;

    initial 
    Q = 0;

    always @(posedge CLK) begin
        if(EN)begin
            Q = {inp,Q[n-1:1]};
        end 
    end
endmodule

module dff_async(CLK,clr,Q,D);
    input wire CLK,D,clr;
    output reg Q;

    always @(posedge CLK or negedge clr) begin
        if(~clr) Q=0;
        else Q=D;
    end

endmodule

module Full_Adder(x,y,z,S,C);
    input wire x,y,z;
    output wire S,C;

    initial
    $display("%b %b %b", x, y, z );

    assign S = x^z^y;
    assign C = (x&y) | (y&z) | (z&x);

endmodule

module serial_adder_4bit(shft_ctrl,clk,Si2,clr);
    parameter n = 4;
    input shft_ctrl, clk, Si2, clr;
    wire [n-1:0]Q1;
    wire [n-1:0]Q2;
    wire clr, Q, Si1;
    wire sum,carry;

    shft_register sf1(Si1,clk,shft_ctrl,Q1);
    shft_register sf2(Si2,clk,shft_ctrl,Q2);
    Full_Adder f1(Q1[0],Q2[0],Q,Si1,carry);
    dff_async d1(shft_ctrl&clk,clr,Q,carry);
    
endmodule

module tb_Full_Adder;
    reg shft_ctrl, clk, clr, Si2;
    reg [19:0]sequence = 20'b0100_0011_0010_0001_0000;
    serial_adder_4bit sa(shft_ctrl,clk,Si2,clr);

    initial
    $monitor("%0t, sum = %b, carry = %b, Si1 = %b, Si2 = %b ", $time,sa.sum,sa.carry,sa.Q1, sa.Q2);

    initial begin
        clr = 1;
        shft_ctrl = 1;
        clk = 0;

        for(integer i = 0 ; i < 20 ; i++)begin
            Si2 = sequence[i];
            #5 clk = 1; 
            #5 clk = 0; 
        end
    end

endmodule