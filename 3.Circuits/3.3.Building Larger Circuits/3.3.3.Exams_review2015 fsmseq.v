// 注意使用counter的原則
// 1.在next determine時納入上一個counter跟當下input的組合作判斷
// 2.在state flip-flop對counter進行更動
// 3.輸出由state決定 (個人習慣而已)
module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);
	parameter SEARCH=0,SHIFT=1;
    reg state,next;
    reg [3:0]buffer;
    always @(*) begin
        case(state)
            SEARCH: begin
              if({buffer[2:0],data}==4'b1101) next=SHIFT; // 原則1.
                else next=SEARCH;
            end
            SHIFT: next=SHIFT;
        endcase
    end
    always @(posedge clk) begin
        if(reset) begin
            state<=SEARCH;
            buffer<=0;
        end
        else begin
            state<=next;
          if(state==SEARCH) buffer<={buffer[2:0],data};// 原則2.
        end
    end
    assign start_shifting = (state == SHIFT) ;// 原則3.
            
endmodule
