module top_module (
    input clk,
    input reset,
    output [3:0] q);
    reg [3:0] current=4'h1;
    always @(posedge clk) begin
        if(current[3:0]==4'ha || reset)
            current<=4'h1;
        else
            current<=current+1;
    end
    assign q=current;
endmodule
