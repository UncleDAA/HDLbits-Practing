module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //
    // Modify FSM and datapath from Fsm_serialdata
    reg [1:0] state,next;
    reg [3:0] bit_num;
    reg [8:0] output_buffer;
    reg odd;
    parameter IDLE=2'b00,DATA=2'b01,OUT=2'b10,ERROR=2'b11;
    always @(*) begin
        case(state)
            IDLE: begin
                if(!in) next=DATA;
                else next=IDLE;
            end
            DATA: begin
                if(bit_num<4'd9) next=DATA;
                else if(bit_num==4'd9) begin
                    if(in & odd) next=OUT;
                    else if(in & ~odd) next=IDLE;
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
            odd<=0;
        end
        else begin
            state<=next;
            case(state)
                IDLE: begin
                    bit_num<=0;
                    odd<=0;
                end
                DATA: begin
                    output_buffer[bit_num]<=in;
                    bit_num<=bit_num+1'b1;
                    if(in) odd<=~odd;
                end
                OUT: begin
                    bit_num<=0;
                    odd<=0;
                end
                ERROR: begin
                    bit_num<=0;
                    odd<=0;
                end
            endcase
        end
    end
    // New: Add parity checking.
    assign done=(state == OUT); 
    assign out_byte=(state == OUT)?output_buffer[7:0]:8'b0;

endmodule 
