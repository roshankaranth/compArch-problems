`timescale 1ns/1ps

module 4b_comparator_b(
    input [3:0] A,B;
    output reg A_greater_B, A_less_B, A_equal_B
);

    always @(*) begin 
        if(A>B) begin
            A_greater_B = 1;
            A_equal_B = 0;
            A_equal_B = 0;
        end else if (A < B) begin
            A_greater_B = 0;
            A_less_B = 1;
            A_equal_B = 0;
        end else if (A==B) begin
            A_greater_B = 0;
            A_less_B = 0;
            A_equal_B = 1;
        end
    end

endmodule