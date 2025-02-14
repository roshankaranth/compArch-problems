module jkff(j,k,CLK,q);
    input wire j,k;
    input wire CLK;
    output reg q;

    initial 
        q = 0;

    always @(posedge CLK) begin
        if(j==1'b0 && k==1'b1) q = 1'b0; 
        else if(j==1'b1 && k==1'b0) q = 1'b1; 
        else if(j==1'b1 && k==1'b1) q = ~q; 
    end
endmodule

module sync_counter(CLK, count);
    parameter n = 4;
    input wire CLK;
    output wire [n-1:0]count;

    jkff ff1(1'b1,1'b1,CLK,count[0]);
    jkff ff2(count[0],count[0],CLK,count[1]);
    jkff ff3(count[0]&count[1],count[0]&count[1],CLK,count[2]);
    jkff ff4(count[0]&count[1]&count[2],count[0]&count[1]&count[2],CLK,count[3]);


endmodule

module tb_sync_counter;
    parameter n = 4; 
    reg CLK;
    wire [n-1:0]count;

    sync_counter s1(CLK,count);

    always begin
        CLK = 0; #5
        CLK = 1; #5
        CLK = 0;
    end

    initial begin
    $monitor("%0t, %b", $time,count);
    #320;
    $finish;
    end
endmodule

//can't connect two reg. one has to be wire.