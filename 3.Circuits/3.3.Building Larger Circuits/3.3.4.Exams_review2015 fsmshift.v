module top_module (
    input clk,
    input reset,      // Synchronous reset
    output shift_ena);
	parameter IDLE=0,OUT=1;
    reg state,next;
    reg [2:0] counter;
    always @(*) begin
        case(state)
            IDLE: begin
                if(reset) next=OUT;
                else next=IDLE;
            end
            OUT: begin
                if(reset) next=OUT;
                else if(counter<3'b100) next=OUT;
                else next=IDLE;
            end
        endcase
    end
    always @(posedge clk) begin
        state<=next;
        if(next==IDLE) counter<=0;
        else counter<=counter+1;
    end
    assign shift_ena=(state == OUT);
endmodule
