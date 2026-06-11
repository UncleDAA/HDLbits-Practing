module top_module (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);
    reg [7:0] last_in;
    always @(posedge clk) begin
        pedge<=in&~last_in;
        last_in<=in;
    end
        
endmodule

// 我對題目有一點誤解 總之output是在找edge本身 所以in從0->1的時候會被記錄下來
// in從0->1的時候:in = 1 且 last =0
