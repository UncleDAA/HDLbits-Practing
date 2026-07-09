module top_module (
    input clk,
    input areset,
    input x,
    output z
); 
	parameter CARRY=0,NOCARRY=1;
    reg state,next;
    always @(*) begin
        case(state) 
            CARRY: begin
                if(x) next=NOCARRY;
                else next=CARRY;
            end
            NOCARRY: next=NOCARRY;
        endcase
    end
    always @(posedge clk,posedge areset) begin
        if(areset) state<=CARRY;
        else state<=next;
    end
    assign z=(state==CARRY & x) || (state==NOCARRY & ~x);
endmodule

// REF // one-hot
module top_module (
    input clk,
    input areset,
    input x,
    output z
); 
    // 1. One-Hot Encoding: 2 個狀態需要 2 個 bits
    parameter A = 2'b01, B = 2'b10; 
    reg [1:0] state, next;

    always @(*) begin
        case(state) 
            A: begin
                if(x) next = B;
                else  next = A;
            end
            B: begin
                next = B; // 只要到了 B 狀態，不管是 0 或 1 都留在 B
            end
            default: next = A; // 2 bits 有 4 種組合，補上 default 防止 Illegal State
        endcase
    end

    always @(posedge clk, posedge areset) begin
        if(areset) state <= A;
        else state <= next;
    end

    // 2. 您的 Mealy 邏輯推導非常精準！直接套用新的狀態名稱即可
    assign z = (state == A & x) || (state == B & ~x);
    
    /* 💡 業界進階技巧 (One-Hot 的真正優勢)：
       既然是 One-Hot，我們甚至不需要去比較 (state == A)，
       只要抽出特定 bit 來看就好，這能省下更多邏輯閘！
       assign z = (state[0] & x) || (state[1] & ~x);
    */

endmodule
