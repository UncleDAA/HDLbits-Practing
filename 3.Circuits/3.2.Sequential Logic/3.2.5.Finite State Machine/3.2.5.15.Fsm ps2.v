module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done
); //
    reg [1:0] state, next;
	parameter bit1=2'b00,bit2=2'b01,bit3=2'b10,out=2'b11;
    // State transition logic (combinational)
    always @(*) begin
        case(state)
            bit1: begin
                if(in[3]) next=bit2;
                else next=bit1;
            end
            bit2:next=bit3;
            bit3:next=out;
            out: begin
                if(in[3]) next=bit2;
                else next=bit1;
            end
        endcase
    end
                   
    // State flip-flops (sequential)
    always @(posedge clk) begin
        if(reset) state<=bit1;
        else state<=next;
    end
            
    // Output logic
    assign done=(state==out);
    
endmodule
