`timescale 1ns/1ps;

module bcd_to_gray(bcd,gray);
    input wire [3:0] bcd;
    output reg [3:0] gray;

    always @(*) begin
        gray[0] = bcd[0]^bcd[1];
        gray[1] = bcd[1]^bcd[2];
        gray[2] = bcd[2]^bcd[3];
        gray[3] = bcd[3];
    end

endmodule

module bcd_to_gray_df(bcd,gray);
    input wire [3:0] bcd;
    output wire [3:0] gray;

    assign gray[0] = bcd[0]^bcd[1];
    assign gray[1] = bcd[1]^bcd[2];
    assign gray[2] = bcd[2]^bcd[3];
    assign gray[3] = bcd[3];

endmodule

module testbench();
    reg [3:0] bcd;
    wire [3:0] gray;

    bcd_to_gray_df uut(bcd,gray);

    initial 
        $monitor("time = %0t, bcd = %b, gray = %b",$time, bcd, gray);

    initial begin
        bcd = 4'b0000;
        #5
        bcd = 4'b0001; #5;
        bcd = 4'b0010; #5;
        bcd = 4'b0100; #5;
        bcd = 4'b1000; #5;
        bcd = 4'b1010; #5;
        bcd = 4'b0101; #5;
        bcd = 4'b0111; #5;
        bcd = 4'b1101; #5;
        bcd = 4'b0110; #5;
        $finish;

    end
endmodule