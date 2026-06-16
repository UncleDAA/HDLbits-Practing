module top_module(clk, reset, in, out);
    input clk, reset, in;
    output reg out;
  // 依循:決定下一個state -> 處理不同state行為(flip-flops) -> 決定輸出
    parameter B=1, A=0;
    reg present_state,next_state;
    always @(*) begin
        case(present_state)
            A:next_state<=in? A:B;
            B:next_state<=in? B:A;
        endcase
    end
    always @(posedge clk) begin
        if(reset) begin
            present_state<=B;
        end else begin
            present_state<=next_state;
        end
    end
    assign out=present_state;
endmodule

// REF //

//參考解答雖然可以compile success但是
//其內容混淆了reg/wire的行為 我認為這是比較糟糕的設計風格
//因為這樣思考reg的行為會搞不清楚取值的時間點
module top_module(clk, reset, in, out);
    input clk;
    input reset;    // Synchronous reset to state B
    input in;
    output out;//  
    reg out;

    // Fill in state name declarations
    parameter A=0, B=1;

    reg present_state, next_state;

    always @(posedge clk) begin
        if (reset) begin  
            // Fill in reset logic
            present_state <= B;
            out = 1;
        end else begin
            case (present_state)
                // Fill in state transition logic
                A: next_state = (in)? A : B;
                B: next_state = (in)? B : A;
            endcase

            // State flip-flops
            present_state = next_state;   

            case (present_state)
                // Fill in output logic
                A: out = 0;
                B: out = 1;
            endcase
        end
    end

endmodule

// REF2 //
// 這個寫法跟REF1非常像 但是嚴格遵守REF的寫法
// 所以可以預期到在always中 present_state更新為上一個next_state -> 同理out會根據上一個present_state更新 不符核對其運作的預期
// 所以跟正解assign out=present_state相當於直接拉一條線把當次的present_state直接拉出來給out使用
// 避免掉delay的問題
module top_module(clk, reset, in, out);
    input clk;
    input reset;    // Synchronous reset to state B
    input in;
    output out;//  
    reg out;

    // Fill in state name declarations
    parameter A=0, B=1;

    reg present_state, next_state;

    always @(posedge clk) begin
        if (reset) begin  
            // Fill in reset logic
            present_state <= B;
            out <= 1;
        end else begin
            case (present_state)
                // Fill in state transition logic
                A: next_state <= (in)? A : B;
                B: next_state <= (in)? B : A;
            endcase

            // State flip-flops
            present_state <= next_state;   
            out<=present_state;
        end
    end

endmodule
