`timescale 1ns/1ps

module MUX_2TO1(in1,in2,sel,out);
    input wire in1,in2,sel;
    output wire out;

    assign out = (sel) ? in2 : in1;
endmodule

module MUX_8TO1(in,sel,out);
    input wire [7:0] in;
    input wire [2:0] sel;
    output wire out;

    assign out = (sel == 0) ? in[0] : ((sel==1) ? in[1] : ((sel==2) ? in[2] :((sel==3) ? in[3] : ((sel==4) ? in[4] : ((sel==5) ? in[5] : ((sel==6) ? in[6] : ((sel==7) ? in[7] : 1'bx)))))));
endmodule

module MUX_ARRAY(in,sel,out);
    input wire [7:0] in;
    input wire [7:0] sel;
    output wire [7:0] out;
    genvar j;

    generate
        for(j = 0; j < 8 ; j = j + 1) begin
            MUX_2TO1 m(1'b0,in[j],sel[j],out[j]);
        end
    endgenerate

endmodule

module Counter_3bit(clk,reset,q);
    input wire clk,reset;
    output reg [2:0] q;
    

    always @(posedge clk, posedge reset) begin
        if(reset) q <= 3'b000;
        else q = q + 1;
    end
endmodule

module DECODER(in,out,enable);
    input wire [2:0] in;
    output reg [7:0] out;
    input wire enable;

    always @(*) begin
        if(enable) begin
            case (in) 
            3'b000 : out <= 8'b00000001;
            3'b001 : out <= 8'b00000010;
            3'b010 : out <= 8'b00000100;
            3'b011 : out <= 8'b00001000;
            3'b100 : out <= 8'b00010000;
            3'b101 : out <= 8'b00100000;
            3'b110 : out <= 8'b01000000;
            3'b111 : out <= 8'b10000000;
        endcase
        end
    end
endmodule

module Memory(address, data);
    input wire [2:0] address;
    output wire [7:0] data;

    reg [7:0] mem [7:0];

    initial begin
        mem[0] = 8'h01;
        mem[1] = 8'h03;
        mem[2] = 8'h07;
        mem[3] = 8'h0F;
        mem[4] = 8'h1F;
        mem[5] = 8'h3F;
        mem[6] = 8'h7F;
        mem[7] = 8'hFF;
    end

    assign data = mem[address];

endmodule

module TOP_MODULE(clk,reset,address,out, q, dout, data, mout);
    input wire clk,reset;
    input wire [2:0] address;
    output wire out;

    output wire [2:0] q;
    output wire [7:0] dout;
    output wire [7:0] data;
    output wire [7:0] mout;

    Counter_3bit c(clk,reset,q);
    DECODER d(q,dout,1'b1);
    Memory m(address, data);
    MUX_ARRAY ma(dout,data,mout);
    MUX_8TO1 m2(mout,q,out);

endmodule
    
module testbech();
    reg clk,reset;
    reg [2:0] address;
    wire out;
    wire [2:0] q;
    wire [7:0] dout,data,mout;

    TOP_MODULE uut(clk,reset,address,out,q, dout, data, mout);

    initial begin
        clk = 0; reset = 1; address = 3'b000;
        #2 clk = 1;
        #2 clk = 0; reset = 0;

        for(integer i = 0; i < 8 ; i = i + 1) begin
            $display("time : %0t, address : %b, out : %b, q : %b, dout : %b, data : %b, mout : %b", $time, address,out, q, dout, data, mout);
            address = address + 1;
            #2 clk = 1;
            #2 clk = 0;
           
         end

         #10 $finish;
        
    end

endmodule