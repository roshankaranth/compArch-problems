`timescale 1ns/1ps

module mux4to1(y,d,sel);
    input [0:1] sel;
    input [0:3] d;
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

module tb_mux4to1;
    reg[1:0] sel_tb;
    reg[3:0] d_tb;
    wire y_tb;

    mux4to1 uut(.sel(sel_tb),
                .d(d_tb),
                .y(y_tb));
    //uut: unit under test

    initial begin
        $monitor("At time %0t, sel=%b, d=%b, y=%b",$time,sel_tb,d_tb,y_tb);
    end

    initial begin
        d_tb = 4'b1010;

        sel_tb = 2'b00; #10
        sel_tb = 2'b01; #10
        sel_tb = 2'b10; #10
        sel_tb = 2'b11; #10
        $finish;
    end
endmodule

//initial block runs only once dusring execution.
//$finish stops the execution
//#10 is delay statment. waits 10 time units in this case 10 ns.
//.sel(sel) is port mapping. 