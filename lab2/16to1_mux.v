`timescale 1ns/1ps;

module mux4to1(y,d,sel);
    input [1:0] sel;
    input [3:0] d;
    output reg y;

    always @(*) begin
       case(sel)
            2'b00: y=d[0];
            2'b01: y=d[1];
            2'b10: y=d[2];
            2'b11: y=d[3];
       endcase 
    end
endmodule

module mux16to1(d, sel, out);
    input [15:0] d;
    input [3:0] sel;
    wire [3:0] i;
    output reg out;

    mux4to1 uut0(.sel(sel[1:0]),
                      .d(d[3:0]),
                      .y(i[0]));
    mux4to1 uut1(.sel(sel[1:0]),
                      .d(d[7:4]),
                      .y(i[1]));
    mux4to1 uut2(.sel(sel[1:0]),
                      .d(d[11:8]),
                      .y(i[2]));
    mux4to1 uut3(.sel(sel[1:0]),
                      .d(d[15:12]),
                      .y(i[3]));

    always @(*) begin
        
        case(sel[3:2])
            2'b00: out = i[0];
            2'b01: out = i[1];
            2'b10: out = i[2];
            2'b11: out = i[3];
        endcase
    end
endmodule

module tb_mux16to1;
    reg[15:0] d_tb;
    reg[3:0] sel_tb;
    wire out_tb;

    mux16to1 uut(.d(d_tb),
                 .sel(sel_tb),
                 .out(out_tb));
    
    initial begin
        $monitor("At time %0t, d=%b, sel=%b, out=%b",$time,d_tb,sel_tb,out_tb);
    end

    initial begin

        d_tb = 16'b1010101010101010;

        sel_tb = 4'b0000; #10
        sel_tb = 4'b0001; #10
        sel_tb = 4'b0010; #10
        sel_tb = 4'b0011; #10
        sel_tb = 4'b0100; #10
        sel_tb = 4'b0101; #10
        sel_tb = 4'b0110; #10
        sel_tb = 4'b0111; #10
        sel_tb = 4'b1000; #10
        sel_tb = 4'b1001; #10
        sel_tb = 4'b1010; #10
        sel_tb = 4'b1011; #10
        sel_tb = 4'b1100; #10
        sel_tb = 4'b1101; #10
        sel_tb = 4'b1110; #10
        sel_tb = 4'b1111; #10
        $finish;
    end
endmodule



