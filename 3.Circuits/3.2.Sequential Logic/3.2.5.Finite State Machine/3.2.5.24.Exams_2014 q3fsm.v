module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);
    parameter A=0,B=1,OUT=2;
    reg [1:0]state,next;
    reg [1:0] w_count,length;
    always @(*) begin
        case(state)
            A: begin
                if(s) next=B;
                else next=A;
            end
            B: begin
                if(length == 2'b10) next=OUT;
                else next=B;
            end
            OUT: begin
                next=B;
            end
        endcase
    end
    always @(posedge clk) begin
        if(reset) begin
            state<=A;
        	w_count<=0;
            length<=0;
        end
        else begin
            state<=next;
            case(state)
                B: begin
                    length<=length+1;
                    w_count<=w?w_count+1:w_count;
                end
                OUT: begin
                    length<=1;
                	w_count<=w?1:0;
                end
            endcase
        end
    end
    
    assign z=(state==OUT & w_count==2'b10);
            

endmodule
