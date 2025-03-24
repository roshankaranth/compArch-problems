`timescale 1ns/1ps

module dff_sync_clear(d,clearb,clock,q);
    input wire d,clearb,clock;
    output reg q;

    always @(posedge clock) begin
        if(!clearb) q <= 1'b0;
        else q <= d;
    end
endmodule 

//Even if clock is not posedge, the ff will be cleared if clearb is negative edge. async.

module dff_async_clear(d,clearb,clock,q);
    input wire d,clearb,clock;
    output reg q;

    always @(posedge clock or negedge clearb) begin
        if(!clearb) q <= 1'b0;
        else q <= d;
    end
endmodule 

module testbench();
    reg d,clearb,clock;
    wire q;

    dff_sync_clear uut(d,clearb,clock,q);

    initial
        $monitor("time : %0t, d = %b, clearb = %b, q = %b, clock = %b", $time,d,clearb,q,clock);

    initial begin
    forever 
        #5 clock = ~clock;
    end

    
    initial begin
        d = 1'b0; clock = 1'b0; clearb = 1'b1; #4
        d = 1'b1; clearb = 1'b0; #8
        clearb = 1'b1; #16
        d = 1'b1; clearb = 1'b0; #4
        $finish;
    end

endmodule