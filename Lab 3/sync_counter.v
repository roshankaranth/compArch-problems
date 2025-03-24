`timescale 1ns/1ps;

module jk_ff(j,k,CLK,clearb,Q);
    input wire j,k,CLK,clearb;
    output reg Q;

    // initial
    //     Q=1'b0;

    always @(posedge CLK) begin
        if(!clearb) Q <= 1'b0;
        else begin
            case ({j,k})
                2'b00 : Q<=Q;
                2'b01 : Q<=1'b0;
                2'b10 : Q<=1'b1;
                2'b11 : Q<=~Q;
            endcase
        end
    end
endmodule

module counter(CLK,in,q,clearb);
    input wire CLK,in,clearb;
    output wire [3:0] q;
    wire c,d;

    assign c = q[0]&q[1];
    assign d = c&q[2];

    jk_ff uut1(in,in,CLK,clearb,q[0]);
    jk_ff uut2(q[0],q[0],CLK,clearb,q[1]);
    jk_ff uut3(c,c,CLK,clearb,q[2]);
    jk_ff uut4(d,d,CLK,clearb,q[3]);

endmodule

module testbench();
    reg CLK,in,clearb;
    wire [3:0] q;

    counter uut(CLK,in,q,clearb);

    initial
        $monitor("time : %0t, in = %b , clearb = %b, q = %b, CLK = %b", $time,in,clearb,q,CLK);

    initial begin
        forever 
            #5 CLK = ~CLK;
    end

    initial begin
        in = 1; clearb = 1; CLK = 0; #1
        clearb = 0; #5
        clearb = 1; #100
        clearb = 0; #10
        clearb = 1; #50
        $finish;
    end
endmodule