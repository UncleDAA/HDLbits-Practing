module top_module (
    input clk,
    input reset,   // Synchronous reset
    input x,
    output z
);
    parameter OOO=0,OOI=1,OIO=2,OII=3,IOO=4;
    reg [2:0] state,next;
    always @(*) begin
        case(state)
            OOO: next=x?OOI:OOO;
            OOI: next=x?IOO:OOI;
            OIO: next=x?OOI:OIO;
            OII: next=x?OIO:OOI;
            IOO: next=x?IOO:OII;
        endcase
    end
    always @(posedge clk) begin
        if(reset) state<=OOO;
    	else state<=next;
    end
    assign z=(state==OII | state==IOO);

endmodule
