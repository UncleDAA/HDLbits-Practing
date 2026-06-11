module top_module (
    input d, 
    input ena,
    output q);
    always @(*) begin
        if(ena)
            q<=d;
    end
endmodule

// 此為 D latch邏輯:值改變時根據ena決定是否更新
// D flip flop邏輯:當clk tick的時候更新
