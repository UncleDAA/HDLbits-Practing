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
                if({buffer[2:0],data}==4'b1101) next=SHIFT;
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
            if(state==SEARCH) buffer<={buffer[2:0],data};
        end
    end
    assign start_shifting = (state == SHIFT) ;
            
endmodule
