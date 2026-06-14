module top_module (
    input clk,
    input enable,
    input S,
    input A, B, C,
    output Z ); 
    reg [7:0] Q;
    always @(posedge clk) begin
        if(enable) begin
            Q <= {Q[6:0],S};
        end
    end
    always @(*) begin
        case({A,B,C})
            3'b000:Z<=Q[0];
            3'b001:Z<=Q[1];
            3'b010:Z<=Q[2];
            3'b011:Z<=Q[3];
            3'b100:Z<=Q[4];
            3'b101:Z<=Q[5];
            3'b110:Z<=Q[6];
            3'b111:Z<=Q[7];
        endcase
    end
  // REF //簡潔的寫法
  assign Z = q[ {A, B, C} ]; 
endmodule

// 這是一個8 D-type flip-flops配合multiplexers的電路
// 應該注意後者本來就不受clk影響
// always@(*) 表示只要變數改變就會啟動
