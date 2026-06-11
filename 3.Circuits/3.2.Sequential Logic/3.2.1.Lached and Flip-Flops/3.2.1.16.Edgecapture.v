module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);
    reg [31:0] last_in;
    reg [31:0] edged;
    always @(posedge clk) begin
        for(int i=0;i<32;i++) begin
            if(~in[i] & last_in[i] & ~edged[i]) begin
                edged[i]<=1;
            end
        end
        // 1->0的瞬間且edged原本為0需要動作
        if(reset) begin
            edged <= 32'b0;   
        end        
        last_in <= in;
    end
    assign out=edged; //沒有變動的edge維持原樣 所以要多一個reg紀錄之前的edge
endmodule
// 有趣的事情是因為reset的優先級更高 所以應該最後確認更新
