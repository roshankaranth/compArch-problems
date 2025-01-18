`timescale 1ns/1ps

module 4b_comparator_df (
    input [3:0] A,B;
    output A_greater_B, A_less_B, A_equal_B
);

    assign A_greater_B = (A>B);
    assign A_less_B = (A<B);
    assign A_equal_B = (A==B);
    
endmodule