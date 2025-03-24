`timescale 1ns/1ps;

module shft_reg(EN,in,CLK,Q);
    input wire EN,in,CLK;
    output reg [3:0] Q;

    initial 
        Q = 4'b0000;

    always @(negedge CLK) begin
        if(EN) begin
            Q <= {in,Q[3:1]};
        end
    end
endmodule

module dff_async_clear(d,clearb,clock,q);
    input wire d,clearb,clock;
    output reg q;

    always @(negedge clock or negedge clearb) begin
        if(!clearb) q <= 1'b0;
        else q <= d;
    end
endmodule 

module full_adder(x,y,z,s,c);
    input wire x,y,z;
    output wire s,c;

    assign {c,s} = x+y+z;
    
endmodule

module bit4_SA(in,clk,EN,Q1,Q2,clearb,Q,s,c);
    input wire in,clk,EN,clearb;
    output wire [3:0] Q1,Q2;
    output wire Q,s,c;
    wire d_clock;

    full_adder f1(Q1[0],Q2[0],Q,s,c);
    shft_reg s1(EN,s,clk,Q1);
    shft_reg s2(EN,in,clk,Q2);

    assign d_clock = clk & EN;
    dff_async_clear d1(c,clearb,d_clock,Q);

endmodule

module testbench();
    reg in,clk,EN,clearb;
    wire Q,s,c;
    wire [3:0] Q1,Q2;
    reg [15:0] seq = 16'b0101_1101_1011_0110;
    integer i;

    bit4_SA uut(in,clk,EN,Q1,Q2,clearb,Q,s,c);

    initial begin
        clk = 1; EN = 1; clearb = 0;
        #2 clearb = 1;
        for(i=0 ; i<16 ; i = i+1) begin
            in = seq[i];
            #2 clk = 0;
            #2 clk = 1;
            $display("time : %0t, in = %b, Q1 = %b, Q2 = %b, Q = %b, s = %b, c = %b", $time,in,Q1,Q2,Q,s,c);
        end
        testing;
        $finish;
    end

    task testing;
        begin
            $display("random sequence");
            clk = 1; EN = 1; clearb = 0;
            #2 clearb = 1;
            for(i=0 ; i<16 ; i = i+1) begin
                in = $random %2;
                #2 clk = 0;
                #2 clk = 1;
                $display("time : %0t, in = %b, Q1 = %b, Q2 = %b, Q = %b, s = %b, c = %b", $time,in,Q1,Q2,Q,s,c);
            end
        end
    endtask
endmodule