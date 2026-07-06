module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //
    // FSM from fsm_ps2  
    reg [1:0] state, next;
    reg [23:0] out_buffer;
    parameter bit1=2'b00,bit2=2'b01,bit3=2'b10,out=2'b11;
    always @(*) begin
        case(state)
            bit1: begin
                if(in[3]) next=bit2;
                else next=bit1;
            end
            bit2: begin
                next=bit3;
            end
            bit3: begin
                next=out;
            end
            out: begin
                if(in[3]) next=bit2;
                else next=bit1;
            end
        endcase
    end
    always @(posedge clk) begin
        if(reset) begin
            state<=bit1;
        end
        else begin
            state<=next;
            case(state)
                bit1:out_buffer[23:16]<=in;
                bit2:out_buffer[15:8]<=in;
                bit3:out_buffer[7:0]<=in;
                out: begin
                    if(in[3]) out_buffer[23:16]<=in;
                end
            endcase
        end
    end
    
    assign done=(state==out);
    // New: Datapath to store incoming bytes.
    assign out_bytes=(state==out?out_buffer:24'b0);

endmodule
