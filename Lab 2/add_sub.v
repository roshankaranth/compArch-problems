`timescale 1ns/1ps;

module FA(a,b,cin,cout,s);
    input wire a,b,cin;
    output wire cout,s;
        
    assign {cout,s} = a+b+cin;

endmodule

module AddSub(a,b,cin,m,s,v,cout);
    input wire [3:0] a,b;
    output wire [3:0] s;
    input wire cin,m;
    output wire v;
    output wire cout;
    wire [3:0] b_val;

    wire carry[2:0];

    assign b_val = (m==0) ? b : ~b;
    assign v = carry[2]^cout;

    FA uut1(a[0],b_val[0],(m==0)?cin:1'b1,carry[0],s[0]);
    FA uut2(a[1],b_val[1],carry[0],carry[1],s[1]);
    FA uut3(a[2],b_val[2],carry[1],carry[2],s[2]);
    FA uut4(a[3],b_val[3],carry[2],cout,s[3]);

endmodule

module testbench();
    reg [3:0] a,b;
    reg cin,m;
    wire [3:0] s;
    wire v,cout;

    AddSub uut1(a,b,cin,m,s,v,cout);

    initial
        $monitor("time : %0t, a = %b, b = %b, cin = %b, m = %b, s = %b, cout = %b, v = %b", $time,a,b,cin,m,s,cout,v);

    initial begin
        $display("addition");
        a = 4'b0000; b = 4'b0000; cin = 1'b0; m = 1'b0; #4
        a = 4'b0010; b = 4'b1000; cin = 1'b1; m = 1'b0; #4
        a = 4'b0110; b = 4'b1100; cin = 1'b1; m = 1'b0; #4
        a = 4'b0001; b = 4'b1110; cin = 1'b0; m = 1'b0; #4
        a = 4'b0111; b = 4'b1000; cin = 1'b1; m = 1'b0; #4
        a = 4'b0101; b = 4'b1010; cin = 1'b1; m = 1'b0; #4
        a = 4'b1111; b = 4'b1111; cin = 1'b0; m = 1'b0; #4

        $display("subtraction");
        a = 4'b0000; b = 4'b0000; cin = 1'b0; m = 1'b1; #4
        a = 4'b0010; b = 4'b1000; cin = 1'b1; m = 1'b1; #4
        a = 4'b0110; b = 4'b1100; cin = 1'b1; m = 1'b1; #4
        a = 4'b0001; b = 4'b1110; cin = 1'b0; m = 1'b1; #4
        a = 4'b0111; b = 4'b1000; cin = 1'b1; m = 1'b1; #4
        a = 4'b0101; b = 4'b1010; cin = 1'b1; m = 1'b1; #4
        a = 4'b1111; b = 4'b1111; cin = 1'b0; m = 1'b1; #4
        $finish;
    end
endmodule