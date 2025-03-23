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

module mux_16to1(out,in,sel);
    input wire [15:0] in;
    output wire out;
    input wire [3:0] sel;

    wire [3:0] temp;

    mux_4to1 uut1(temp[0],in[3:0],sel[1:0]);
    mux_4to1 uut2(temp[1],in[7:4],sel[1:0]);
    mux_4to1 uut3(temp[2],in[11:8],sel[1:0]);
    mux_4to1 uut4(temp[3],in[15:12],sel[1:0]);
    mux_4to1 uut5(out,temp,sel[3:2]);
endmodule

module testbench();
    reg [15:0] in;
    wire out;
    reg [3:0] sel;

    mux_16to1 uut(out,in,sel);

    initial 
        $monitor("time : %0t, input : %b, sel : %b, out: %b", $time,in,sel,out);

    initial begin
           in=16'b1000000000000000; sel=4'b0000;
        #3 in=16'b0100000000000000; sel=4'b0001;
        #3 in=16'b0010000000000000; sel=4'b0010;
        #3 in=16'b0001000000000000; sel=4'b0011;
        #3 in=16'b0000100000000000; sel=4'b0100;
        #3 in=16'b0000010000000000; sel=4'b0101;
        #3 in=16'b0000001000000000; sel=4'b0110;
        #3 in=16'b0000000100000000; sel=4'b0111;
        #3 in=16'b0000000010000000; sel=4'b1000;
        #3 in=16'b0000000001000000; sel=4'b1001;
        #3 in=16'b0000000000100000; sel=4'b1010;
        #3 in=16'b0000000000010000; sel=4'b1011;
        #3 in=16'b0001111100001000; sel=4'b1100;
        #3 in=16'b0010000000000100; sel=4'b1101;
        #3 in=16'b0100000000000010; sel=4'b1110;
        #3 in=16'b1000000000000001; sel=4'b1111;
        #3 $finish;
    end
endmodule
