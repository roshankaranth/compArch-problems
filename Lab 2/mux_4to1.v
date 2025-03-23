`timescale 1ns/1ps

module mux_4to1(out,in,sel);
    input wire [3:0] in;
    output reg out;
    input wire [1:0] sel;

    always @(*) begin
        case (sel)
            2'b00 : out = in[0];
            2'b01 : out = in[1];
            2'b10 : out = in[2];
            2'b11 : out = in[3];
        endcase
    end

endmodule

module testbench();
    reg [3:0] in;
    wire out;
    reg [1:0] sel;

    mux_4to1 uut(out,in,sel);

    initial 
        $monitor("time : %0t, input : %b, sel : %b, out: %b", $time,in,sel,out);

    initial begin
        in = 4'b0000; sel = 2'b00; #5
        in = 4'b1010; sel = 2'b01; #5
        in = 4'b0101; sel = 2'b10; #5
        in = 4'b0110; sel = 2'b11; #5
        in = 4'b1001; sel = 2'b00; #5
        $finish;
    end
endmodule
