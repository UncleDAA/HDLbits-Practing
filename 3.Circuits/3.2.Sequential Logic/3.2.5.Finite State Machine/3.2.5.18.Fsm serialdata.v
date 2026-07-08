module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    // Use FSM from Fsm_serial
    reg [1:0] state,next;
    reg [3:0] bit_num;
    reg [7:0] output_buffer;
    parameter IDLE=2'b00,DATA=2'b01,OUT=2'b10,ERROR=2'b11;
    always @(*) begin
        case(state)
            IDLE: begin
                if(!in) next=DATA;
                else next=IDLE;
            end
            DATA: begin
                if(bit_num<4'd8) next=DATA;
                else if(bit_num==4'd8) begin
                    if(in) next=OUT;
                    else next=ERROR;
                end
            end
            OUT: begin
                if(!in) next=DATA;
                else next=IDLE;
            end
            ERROR: begin
                if(in) next=IDLE;
                else next=ERROR;
            end
        endcase
    end
    always @(posedge clk) begin
        if(reset) begin
            state<=IDLE;
            bit_num<=0;
        end
        else begin
            state<=next;
            case(state)
                IDLE:bit_num<=0;
                DATA: begin
                    output_buffer[bit_num]<=in;
                    bit_num<=bit_num+1'b1;
                end
                OUT:bit_num<=0;
                ERROR:bit_num<=0;
            endcase
        end
    end
    assign done=(state == OUT); 
    // New: Datapath to latch input bits.
    assign out_byte=(state == OUT?output_buffer:8'b0);
endmodule
