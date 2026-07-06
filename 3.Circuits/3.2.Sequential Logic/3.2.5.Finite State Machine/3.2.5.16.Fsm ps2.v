module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done
); //
    reg [1:0] state, next;
	parameter empty=2'b00,bit1=2'b01,bit2=2'b10,bit3=2'b11;
    // State transition logic (combinational)
    always @(*) begin
        case(state)
            empty: begin
                if(in[3]) next=bit1;
                else next=empty;
            end
            bit1:next=bit2;
            bit2:next=bit3;
            bit3: begin
                if(in[3]) next=bit1;
                else next=empty;
            end
        endcase
    end
                   
    // State flip-flops (sequential)
    always @(posedge clk) begin
        if(reset) state<=empty;
        else state<=next;
    end
            
    // Output logic
    assign done=(state==bit3);

endmodule
