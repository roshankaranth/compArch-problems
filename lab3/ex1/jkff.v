module jkff(j,k,CLK,q);
    input wire j,k, CLK;
    output reg q;


    always @(posedge CLK) begin
        if(j==1'b0 && k==1'b1) q = 1'b0; 
        else if(j==1'b1 && k==1'b0) q = 1'b1; 
        else if(j==1'b1 && k==1'b1) q = ~q; 
    end
endmodule

module tb_jkff;
    reg j,k,CLK;
    wire q;

    jkff j1(j,k,CLK,q);

    initial
    $monitor("%0t, j=%b, k=%b, clk=%b, q=%b",$time,j,k,CLK,q);

    always begin
        CLK = 0; #5
        CLK = 1; #5
        CLK = 0; 
    end 

    initial begin
        j=0 ; k = 0; #10
        j=0 ; k = 1; #10
        j=1 ; k = 0; #10
        j=1 ; k = 1; #10
        $finish;
    end

endmodule