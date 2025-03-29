`timescale 1ns/1ps

module encoder(func,opcode);
    input wire [7:0] func;
    output reg [2:0] opcode;
    input wire clk;

    always @(func,opcode) begin
        case(func)
            8'b00000001:opcode = 3'b000;
            8'b00000010:opcode = 3'b001;
            8'b00000100:opcode = 3'b010;
            8'b00001000:opcode = 3'b011;
            8'b00010000:opcode = 3'b100;
            8'b00100000:opcode = 3'b101;
            8'b01000000:opcode = 3'b110;
            8'b10000000:opcode = 3'b111;
            default : opcode = 3'bx;
        endcase
    end
endmodule

module ALU(opcode, a, b, out);
    input wire [2:0] opcode;
    input wire [3:0] a,b;
    output wire [3:0] out;
    
    assign out = (opcode == 3'b000) ? a + b :
                 (opcode == 3'b001) ? a - b :  
                 (opcode == 3'b010) ? a ^ b :
                 (opcode == 3'b011) ? a | b :
                 (opcode == 3'b100) ? a & b :
                 (opcode == 3'b101) ? ~(a | b) :
                 (opcode == 3'b110) ? ~(a & b) :
                 (opcode == 3'b111) ? (a & b) | (~a & ~b) :
                 4'b0000;  
endmodule

module parity_generator(in, out);
    input wire [3:0] in;
    output wire out;

    assign out = (in[0]^in[1]^in[2]^in[3]);
endmodule

module pipeline(a,b,func,parity);
    input wire [3:0] a,b;
    input wire [7:0] func;
    output wire parity;

    wire [10:0] if_reg;
    wire [3:0] ex_reg;

    assign if_reg[3:0] = a;
    assign if_reg[7:4] = b;

    encoder e1(func,if_reg[10:8]);
    ALU a1(if_reg[10:8],if_reg[3:0],if_reg[7:4],ex_reg);
    parity_generator p1(ex_reg,parity);
endmodule

module testbench();
    reg [3:0] a,b;
    reg [7:0] func;
    wire parity;
    reg x;

    pipeline uut(a,b,func,parity);

    initial	
        $monitor("time: %0t, a = %b, b = %b, func = %b, parity = %b",$time,a,b,func,parity);
    
    initial begin
        func = 8'b00000001; a = 4'b0001; b = 4'b0001;
        #10	func = 8'b00000010;
        #10	func = 8'b00000100;
        #10	func = 8'b00001000;
        #10	func = 8'b00010000;
        #10	func = 8'b00100000;
        #10	func = 8'b01000000;
        #10	func = 8'b10000000;
        #10	$display("");
        #10	func = 8'b00000001; a = 4'b0101; b = 4'b1010;
        #10	func = 8'b00000010;
        #10	func = 8'b00000100;
        #10	func = 8'b00001000;
        #10	func = 8'b00010000;
        #10	func = 8'b00100000;
        #10	func = 8'b01000000;
        #10	func = 8'b10000000;
        #10	$finish;
    end
endmodule