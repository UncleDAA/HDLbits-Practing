module top_module (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);
    reg [7:0] last_in;
    
    always @(posedge clk) begin
        anyedge<=in^last_in;
        last_in<=in;
    end
endmodule
