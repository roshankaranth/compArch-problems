module dff_sync(d,clearb,clock,q);
    input wire d, clearb, clock;
    output reg q;
    

    always @(posedge clock) begin
        if(!clearb) q <= 1'b0;
        else q<= d;
    end
endmodule

module tb_dff;
    reg d,clearb,clock;
    wire q;

    dff_aync d1(d,clearb,clock,q);

    always @(posedge clock)begin
        $display("d=%b, clk=%b, rst=%b, q=%b\n", d, clock, clearb, q);
    end

    initial begin
        forever begin
            clock=0; #5
            clock=1; #5
            clock=0; 
        end
    end

    initial begin
        d=0;clearb=1;#4
        d=1;clearb=0;#50
        d=1;clearb=1;#20
        d=0;clearb=0;#20
        $finish;
    end

endmodule