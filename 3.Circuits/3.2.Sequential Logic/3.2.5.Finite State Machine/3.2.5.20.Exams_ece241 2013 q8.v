module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 
	parameter first=0,second=1,third=2;
    reg [1:0]state,next;
    always @(*) begin
        case(state)
            first: begin
                if(x) next=second;
                else next=first;
            end
            second: begin
                if(!x) next=third;
                else next=second;
            end
            third: begin
                if(x) next=second;
                else next=first;
            end
        endcase
    end
    always @(posedge clk,negedge aresetn) begin
        if(!aresetn) state<=first;
        else state<=next;
    end
    assign z=(state==third)&x;
endmodule
