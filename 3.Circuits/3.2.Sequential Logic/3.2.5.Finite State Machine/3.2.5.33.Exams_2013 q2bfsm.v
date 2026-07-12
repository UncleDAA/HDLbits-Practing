module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 
	parameter A=0,B=1,X1=2,X2=3,X3=4,Y1=5,Y2=6,O=7,I=8;
    reg [3:0]state,next;

    always @(*) begin
        case(state)
            A: next=B;
            B: next=X1;
            X1: begin
                if(x) next=X2;
                else next=X1;
            end
            X2: begin
                if(~x) next=X3;
                else next=X2;
            end
            X3: begin
                if(x) next=Y1;
                else next=X1;
            end
            Y1: next=y?I:Y2;
            Y2: next=y?I:O;
            I: next=I;
            O: next=O;           
        endcase
    end
    always @(posedge clk) begin
        if(~resetn) state<=A;
        else state<=next;
    end
	assign f= state==B;
    assign g= (state==Y1 || state==Y2 || state==I);
               
endmodule
