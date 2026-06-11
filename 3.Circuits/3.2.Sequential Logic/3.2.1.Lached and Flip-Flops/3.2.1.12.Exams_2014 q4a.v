module top_module (
    input clk,
    input w, R, E, L,
    output Q
);
    wire multi1,multi2;
    assign multi1=E?w:Q;
    assign multi2=L?R:multi1;
    always @(posedge clk) begin
        Q=multi2;
    end
endmodule
