module top_module (
    input clk,
    input areset,
    input x,
    output z
); 
    parameter ONE=1,ZERO_CARRY=2,ZERO_NO=3;
    reg [1:0] state,next;
    always@(*) begin
        case(state)
            ONE: begin
                if(x) next=ZERO_NO;
                else next=ONE;
            end
            ZERO_CARRY: begin
                if(x) next=ONE;
                else next=ZERO_CARRY;
            end
            ZERO_NO: begin
                if(x) next=ZERO_NO;
                else next=ONE;
            end
        endcase
    end
    always @(posedge clk,posedge areset) begin
        if(areset) begin
            // 題目提到:The conversion begins when Reset is released and stops when Reset is asserted.
            // 所以不用考慮overlapping問題
            // 以硬體思維來說 reset也不應該考慮overlapping(那是前面sequence中stop bit會出現的問題)
            state<=ZERO_CARRY;
        end
        else state<=next;
    end
    assign z=(state==ONE);
        
endmodule
