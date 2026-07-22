module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state  );
	parameter OFF=0,ON=1;
    reg next;
    always @(*) begin
        if(a & b) next=ON;
        else if(~a & ~b) next=OFF;
        else next=state;
    end
    always @(posedge clk) begin
        state<=next;
    end
    assign q=state?~(a^b):a^b;
endmodule
