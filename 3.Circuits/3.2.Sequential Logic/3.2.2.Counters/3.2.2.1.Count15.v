module top_module (
    input clk,
    input reset,      // Synchronous active-high reset
    output [3:0] q);
    reg [3:0] current = 4'b0;
    always @(posedge clk) begin
        if(reset)
            current<=0;
    	else
            current<=current+1;
    end
    assign q=current;
endmodule
