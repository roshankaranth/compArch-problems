`timescale 1ns/1ps

module fullAdder(input a, b, c, output reg sum, carry);
    always @(*) begin
        sum = a ^ b ^ c;
        carry = (a & b) | (b & c) | (c & a);
    end
endmodule

module AddSub(input [3:0] a, b, input M, output reg V, output [3:0] sum);
    wire [3:0] carry;
    wire [3:0] b_xor;

    assign b_xor = b ^ {4{M}}; // XOR each bit of B with M for subtraction

    // Instantiate 4 Full Adders
    fullAdder fa1(a[0], b_xor[0], M, sum[0], carry[0]);
    fullAdder fa2(a[1], b_xor[1], carry[0], sum[1], carry[1]);
    fullAdder fa3(a[2], b_xor[2], carry[1], sum[2], carry[2]);
    fullAdder fa4(a[3], b_xor[3], carry[2], sum[3], carry[3]);

    always @(*) begin
        V = carry[3] ^ carry[2]; // Overflow detection
    end
endmodule


module AddSub_tb;
    reg [3:0] a, b;
    reg M; // Control signal: 0 for add, 1 for subtract
    wire [3:0] sum;
    wire V;

    // Instantiate the AddSub module
    AddSub uut (.a(a), .b(b), .M(M), .sum(sum), .V(V));

    initial begin
        // Monitor changes
        $monitor("Time=%0t | a=%b, b=%b, M=%b | sum=%b, V=%b", $time, a, b, M, sum, V);

        // Test Case 1: Addition (3 + 2)
        a = 4'b0011;  // 3
        b = 4'b0010;  // 2
        M = 0;        // Addition
        #10;

        // Test Case 2: Subtraction (5 - 2)
        a = 4'b0101;  // 5
        b = 4'b0010;  // 2
        M = 1;        // Subtraction
        #10;

        // Test Case 3: Overflow (8 + 8)
        a = 4'b1000;  // 8
        b = 4'b1000;  // 8
        M = 0;        // Addition
        #10;

        // Test Case 4: Overflow in Subtraction (-8 - 1)
        a = 4'b1000;  // -8 (in 2's complement)
        b = 4'b0001;  // 1
        M = 1;        // Subtraction
        #10;

        // Test Case 5: Edge Case (0 - 1)
        a = 4'b0000;  // 0
        b = 4'b0001;  // 1
        M = 1;        // Subtraction
        #10;

        // End Simulation
        $finish;
    end
endmodule
