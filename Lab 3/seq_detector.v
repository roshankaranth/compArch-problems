`timescale 1ns/1ps;

module seq_detector(in,clk,rst,op);
    input wire in,clk,rst;
    output reg op;

    reg [2:0] state;

    always @(posedge clk or posedge rst) begin
        if(rst == 1) state <= 3'b000;
        else begin
            case (state)
                3'b000 : begin
                    if(in == 0) begin
                        state <= 3'b000;
                        op <= 1'b0;
                    end else if(in == 1) begin
                        state <= 3'b001;
                        op <= 1'b0;
                    end
                end
                3'b001 : begin
                    if(in == 1) begin
                        state <= 3'b001;
                        op <= 1'b0;
                    end else if(in == 0) begin
                        state <= 3'b010;
                        op <= 0;
                    end
                end
                3'b010 : begin
                    if(in==1) begin
                        state <= 3'b011;
                        op <= 1'b0;
                    end else if(in==0) begin
                        state <= 3'b000;
                        op <= 1'b0;
                    end
                end
                3'b011 : begin
                    if(in == 1) begin
                        state <= 3'b100;
                        op <= 1'b0;
                    end else if(in == 0) begin
                        state <= 3'b010;
                        op <= 1'b0;
                        end
                    end
                3'b100 : begin
                    if(in == 1) begin
                        state <= 3'b001;
                        op <= 1'b0;;
                    end else if(in == 0) begin
                        state<= 3'b010;
                        op <= 1'b1;
                    end
                end
                default : begin
                    state <= 3'b000;
                    op <= 1'b0;
                end
            endcase
            end
        end
endmodule

module testbench();
    reg in,clk,rst;
    wire outp;
    reg [15:0] seq = 16'b0101_1101_1011_0110;
    integer i;

    seq_detector uut(in,clk,rst,outp);


    initial begin
        clk = 0; rst = 1; #5
        rst = 0;
        for(i=0 ; i<=15 ; i = i+1) begin
            in = seq[i];
            #2 clk = 1;
            #2 clk = 0;
            $display("time : %0t, in = %b op = %b", $time,in,outp);
        end
        testing;
        $finish;
    end

    task testing;
    begin
        $display("randome sequence");
        for(i = 0 ; i <= 15; i = i+1) begin
            in = $random %2;
            #2 clk = 1;
            #2 clk = 0;
            $display("time : %0t, in = %b op = %b", $time,in,outp);
        end
    end
    endtask
endmodule