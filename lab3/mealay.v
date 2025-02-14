`timescale 1ns/1ps

module mealy(clk,rst,inp,outp);
    input wire clk,rst,inp;
    output reg outp;
    reg [1:0] state;

    always @(posedge clk, posedge rst) begin
        if(rst) begin 
            state <= 2'b00;
            outp <= 0;
        end
        else begin 
            case (state)
                2'b00 : begin
                if(inp)begin
                    state <= 2'b01;
                    outp <= 0;
                end
                else begin
                    state <= 2'b10;
                    outp <= 0;
                end
                end
                2'b01: begin
                if( inp ) begin
                state <= 2'b00;
                outp <= 1;
                end
                else begin
                state <= 2'b10;
                outp <= 0;
                end
                end
                2'b10: begin
                if( inp ) begin
                state <= 2'b01;
                outp <= 0;
                end
                else begin
                state <= 2'b00;
                outp <= 1;
                end
                end
                default: begin
                state <= 2'b00;
                outp <= 0;
                end
            endcase
        end
    end
endmodule

module mealy_test;
    reg clk, rst, inp;
    wire outp;
    reg[15:0] sequence;
    integer i;

    mealy duty( clk, rst, inp, outp);
    
    initial begin
    clk = 0;
    rst = 1;
    sequence = 16'b0101011101110010;
    #5 rst = 0;
    $display("%b",sequence);
    for( i = 0; i <= 15; i = i + 1) begin
        inp = sequence[i];
        #2 clk = 1;
        #2 clk = 0;
        $display("State = ", duty.state, " Input = ", inp, ", Output = ",outp);
    end
    
    testing;
    end

    task testing;
        for( i = 0; i <= 15; i = i + 1)
        begin
        inp = $random % 2;
        #2 clk = 1;
        #2 clk = 0;
        $display("State = ", duty.state, " Input = ", inp, ", Output = ", outp);
        end
    endtask
endmodule

