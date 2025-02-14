module fsm(rst,inp,CLK,state,match);
    input wire rst,inp,CLK;
    output reg [2:0] state;
    output reg match;

    always @(posedge CLK,posedge rst) begin
        if(rst) begin
            state = 3'b000;
            match = 0;
        end
        else begin
            case (state) 
                3'b000 : begin
                    if(inp) state = 3'b001;
                    else state = state;
                end
                3'b001 : begin
                    if(inp) state = state;
                    else state = 3'b010;
                end
                3'b010 : begin
                    match = 0;
                    if(inp) state = 3'b011;
                    else state = 3'b000;
                end
                3'b011 : begin 
                    if(inp) state = 3'b100;
                    else state = 3'b010;
                end
                3'b100 : begin
                    if(inp) state = 3'b001;
                    else begin 
                        state = 3'b010;
                        match = 1;
                    end
                end
                default : begin
                    state = 3'b000;
                end
            endcase
        end
    end
endmodule

module tb_fsm;
    reg CLK,rst,inp;
    wire [2:0] state;
    wire match;
    reg[15:0] sequence;

    fsm uui(rst,inp,CLK,state,match);

    initial begin
        rst = 1;
        CLK = 0;
        sequence = 16'b1011_0000_0101_1000;
        #5 rst = 0;
        for(integer i = 16 ; i >= 0 ; i--) begin
            inp = sequence[i];
            #2 CLK = 1;
            #2 CLK = 0;
            $display("%0t, inp = %b, state=%b, match=%b",$time,inp,state,match);
        end
    end
endmodule


