`timescale 1ns/1ps;

module shft_reg(EN,in,CLK,Q);
    input wire EN,in,CLK;
    output reg [3:0] Q;

    initial 
        Q = 4'b000;

    always @(negedge CLK) begin
        if(EN) begin
            Q <= {in,Q[3:1]};
        end
    end
endmodule

module testbench();
    reg EN,in,CLK;
    wire [3:0] Q;

    shft_reg uut(EN,in,CLK,Q);

    initial
        $monitor("time : %0t, in = %b, EN = %b, CLK = %b, Q = %b", $time,in,EN,CLK,Q);

    initial begin
        forever
            #5 CLK = ~CLK;
    end

    initial begin
        EN = 0; CLK = 1; in = 0; #4
        EN = 1; #4
        in = 0; #4
        in = 1; #4
        in = 1; EN = 0; #4
        in = 0; EN = 1; #4
        in = 0; #4
        in = 1; #4
        $finish;
    end

endmodule