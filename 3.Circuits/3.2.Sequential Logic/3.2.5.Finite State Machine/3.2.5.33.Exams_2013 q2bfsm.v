module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 
	parameter A=0,B=1,X=2,Y=3,O=4,I=5;
    reg [2:0]state,next;
    reg [2:0]seqx;
    reg [1:0]county;
    always @(*) begin
        case(state)
            A: next=B;
            B: next=X;
            X: begin
                if({seqx[1:0],x}==3'b101) next=Y;
                else next=X;
            end
            Y: begin
                if(y) next=I;
                else if(county==2'b01 & ~y) next=O;
                else next=Y;
            end
            O: next=O;
            I: next=I;
                
        endcase
    end
    always @(posedge clk) begin
        if(~resetn) begin
            state<=A;
            seqx<=0;
            county<=0;
        end
        else begin
            state<=next;
            case(state)
                X: begin
                    seqx<={seqx[1:0],x};
                end
                Y: begin
                    county<=county+1;
                end
            endcase
        end
    end
	assign f= state==B;
    assign g= (state==Y || state==I);
               
endmodule

// REF //

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
