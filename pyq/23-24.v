`timescale 1ns/1ps;

module jk_ff(j,k,CLK,Q);
    input wire j,k,CLK;
    output reg Q;

    initial
        Q = 1'b0;

    always @(negedge CLK) begin
        case ({j,k})
            2'b00 : Q <= Q;
            2'b01 : Q <= 1'b0;
            2'b10 : Q <= 1'b1;
            2'b11 : Q <= ~Q;
        endcase
    end
endmodule

module BCD_Counter(Q_out,CLK);
    input wire CLK;
    output wire [3:0] Q_out;

    jk_ff ff1(1'b1,1'b1,CLK,Q_out[0]);
    jk_ff ff2(~Q_out[3],1'b1,Q_out[0],Q_out[1]);
    jk_ff ff3(1'b1,1'b1,Q_out[1],Q_out[2]);
    and ad(k,Q_out[1],Q_out[2]);
    jk_ff ff4(k,1'b1,Q_out[0],Q_out[3]);

endmodule

module MEM_16(D_16,A_4);
    input wire [3:0] A_4;
    output reg [15:0] D_16;

    reg [15:0] mem [15:0];

    initial begin
        mem[0] = 16'h0001;
        mem[1] = 16'h0002;
        mem[2] = 16'h0004;
        mem[3] = 16'h0008;
        mem[4] = 16'h0010;
        mem[5] = 16'h0020;
        mem[6] = 16'h0000;
        mem[7] = 16'h0000;
        mem[8] = 16'h0000;
        mem[9] = 16'h0000;
        mem[10] = 16'h0400;
        mem[11] = 16'h0800;
        mem[12] = 16'h1000;
        mem[13] = 16'h0000;
        mem[14] = 16'h0000;
        mem[15] = 16'h0000;
    end 

    always @(*) begin
        D_16 <= mem[A_4];
    end
endmodule

module MUX_16(O,I_16,S_4);
    output wire O;
    input wire [15:0] I_16;
    input wire [3:0] S_4;

    assign O = I_16[S_4];
endmodule

module INTG(OUT,CLK,Q_out,D_16);
    input wire CLK;
    output wire OUT;

    output wire [3:0] Q_out;
    output wire [15:0] D_16;

    BCD_Counter cnt(Q_out,CLK);
    MEM_16 mem(D_16,Q_out);
    MUX_16 mux(OUT,D_16,Q_out);

endmodule

module testbench();
    reg CLK;
    wire OUT;

    wire [3:0] Q_out;
    wire [15:0] D_16;

    INTG uut(OUT,CLK,Q_out,D_16);

    initial
        $monitor("time : %0t, OUT : %b, Q_out : %b,D_16 : %b , CLK : %b", $time,OUT,Q_out,D_16,CLK);

    
    always #5 CLK = ~CLK;
    

    initial begin
        CLK = 0;
        #204 $finish;
    end
endmodule