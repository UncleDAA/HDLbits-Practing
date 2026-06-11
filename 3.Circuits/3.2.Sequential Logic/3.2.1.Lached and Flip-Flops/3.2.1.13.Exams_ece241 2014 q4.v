module top_module (
    input clk,
    input x,
    output z
); 
	reg f1,f2,f3;
    always @(posedge clk) begin
        f1<=f1^x;
        f2<=~f2&x;
        f3<=~f3|x;
    end
    assign z=~(f1|f2|f3);
endmodule
