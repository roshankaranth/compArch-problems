`timescale 1ns/1ps

module signa(neg,A);
    input [3:0] A;
    output reg neg;

    always @(*) begin
        if(A[3] == 1) begin
            neg = 1;
        end
        else begin
            neg = 0;
        end 
    end
endmodule

module comp_4bit(a,b,gt,eq,lt);
    input [3:0] a,b;
    output reg gt,eq,lt;
    wire negA, negB;

    signa signa1(negA,a);
    signa signa2(negB,b);

    always @(*) begin
        if (negA == 1 && negB == 0) begin
            gt = 1;
            eq = 0;
            lt = 0;
        end
        else if (negA == 0 && negB == 1) begin
            gt = 0;
            eq = 0;
            lt = 1;
        end
        else if (negA == negB) begin
            if (a > b) begin
                gt = 1;
                eq = 0;
                lt = 0;
            end
            else if (a == b) begin
                gt = 0;
                eq = 1;
                lt = 0;
            end
            else begin
                gt = 0;
                eq = 0;
                lt = 1;
            end
        end
    end
endmodule

module tb_comp_4bit;
    reg [3:0] a,b;
    wire gt,eq,lt;

    comp_4bit uut(.a(a),
                  .b(b),
                  .gt(gt),
                  .eq(eq),
                  .lt(lt));

    initial begin
        $monitor("a=%b, b=%b, gt=%b, eq=%b, lt=%b", a, b, gt, eq, lt);
    end

    initial begin
        a = 4'b0000; b = 4'b0000; #10;
        a = 4'b0000; b = 4'b0001; #10;
        a = 4'b0100; b = 4'b0010; #10;
        a = 4'b1000; b = 4'b0011; #10;
        a = 4'b0010; b = 4'b0100; #10;
        a = 4'b0001; b = 4'b0101; #10;
        a = 4'b0100; b = 4'b0110; #10;
        a = 4'b1100; b = 4'b0111; #10;
        a = 4'b0000; b = 4'b1000; #10;
        a = 4'b0000; b = 4'b1001; #10;
        a = 4'b0000; b = 4'b1010; #10;
        a = 4'b0000; b = 4'b1011; #10;
        a = 4'b0000; b = 4'b1100; #10;
        a = 4'b0000; b = 4'b1101; #10;
        a = 4'b0000; b = 4'b1110; #10;
        a = 4'b0000; b = 4'b1111; #10;
        $finish;
    end
endmodule

