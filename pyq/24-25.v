`timescale 1ns/1ps;

module SEQ_DET(Z1,X,CLK,RST,state);
    output reg Z1;
    input wire CLK,RST,X;

    output reg [2:0] state;

    always @(posedge CLK) begin
        Z1 = 1'b0;
        if(RST) state <= 3'b000;
        else begin
            case (state) 
                3'b000 : begin
                    if(X) state <= 3'b001;
                    else state <= 3'b000;
                end
                3'b001 : begin
                    if(X) state <= 3'b001;
                    else state <= 3'b010;
                end
                3'b010 : begin
                    if(X) state <= 3'b001;
                    else state <= 3'b011;
                end
                3'b011 : begin
                    if(X) begin
                        state <= 3'b100;
                        Z1 = 1'b1;
                    end else state <= 3'b000;
                end
                3'b100 : begin
                    if(X) state <= 3'b001;
                    else state <= 3'b010;
                end
            endcase
        end
    end
endmodule

module BIN_COUNTER(Q_out,CLR1,CLR2,CLK);
    input wire CLK,CLR1,CLR2;
    output reg [2:0] Q_out;

    initial begin
        Q_out = 3'b000;
    end

    always @(posedge CLK) begin
        if(CLR1 | CLR2) Q_out = 3'b000;
        else if(Q_out < 7) Q_out = Q_out + 1; 
    end
endmodule

module DEC_8(O_8,S_3);
    output reg [7:0] O_8;
    input wire [2:0] S_3;

     always @(*) begin
        case(S_3)
            0 : O_8 = 8'b00000001;
            1 : O_8 = 8'b00000010;
            2 : O_8 = 8'b00000100;
            3 : O_8 = 8'b00001000;
            4 : O_8 = 8'b00010000;
            5 : O_8 = 8'b00100000;
            6 : O_8 = 8'b01000000;
            7 : O_8 = 8'b10000000;
        endcase
     end
endmodule

module INTG(Z2,Z1,X1,CLK,RESET,state, Q_out);  
    input wire CLK,RESET,X1;
    output wire Z1,Z2;
    output wire [2:0] state;
    output wire [2:0] Q_out;
    wire [7:0] O_8;

    assign Z2 = O_8[3];

    SEQ_DET sd(Z1,X1,CLK,RESET,state);
    BIN_COUNTER cnt(Q_out,RST,Z2,Z1);
    DEC_8 d(O_8,Q_out);
endmodule

module testbench();
    reg clk,RESET,X1;
    wire Z1,Z2;
    reg [24:0] seq = 25'b1001001100100001001001001;
    wire [2:0] state;
    wire [2:0] Q_out;

    INTG uut(Z2,Z1,X1,clk,RESET,state,Q_out);
       
    initial begin
        clk = 0; RESET = 1;
        #2 clk = 1;
        #2 clk = 0;
        RESET = 0;

        for(integer j = 24 ; j>=0 ; j=j-1) begin
            X1 = seq[j];
            clk = 1;
            #2 clk = 0;
            $display("time : %0t, X1 : %b, Z1 : %b, Z2 : %b, state : %b, cntr : %b",$time,X1,Z1,Z2,state, Q_out);
        end

        #2 $finish;
    end
endmodule