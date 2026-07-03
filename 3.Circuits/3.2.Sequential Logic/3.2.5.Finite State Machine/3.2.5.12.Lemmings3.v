module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging );
    reg [2:0]state, next_state;
	parameter LEFT=3'b000,RIGHT=3'b001,AAAH_R=3'b010,AAAH_L=3'b011,DIG_R=3'b100,DIG_L=3'b101;
	always @(*) begin
        if(!ground) begin
            // falling
            case(state)
                LEFT:next_state=AAAH_L;
                DIG_L:next_state=AAAH_L;
                RIGHT:next_state=AAAH_R;
                DIG_R:next_state=AAAH_R;
                default next_state=state;
            endcase
        end
        else begin
            // stop falling
            if(state==AAAH_R | state==AAAH_L) begin
                case(state)
                    AAAH_R:next_state=RIGHT;
                    AAAH_L:next_state=LEFT;
                endcase
            end
            else if(state==DIG_R | state==DIG_L) begin
                next_state=state;
            end
            else begin
                if(dig) begin
                    case(state)
                        LEFT:next_state=DIG_L;
                        RIGHT:next_state=DIG_R;
                    endcase
                end
                else begin
                	case({bump_left,bump_right})
            			2'b00:next_state=state;
            			2'b10:next_state=RIGHT;
            			2'b01:next_state=LEFT;
            			2'b11:next_state=!state;
        			endcase
           		end
            end
        end
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if(areset) begin
            state<=LEFT;
        end
        else begin
            state<=next_state;
        end
    end
           

    // Output logic
    assign walk_left=state==LEFT;
    assign walk_right=state==RIGHT;
    assign aaah=state==AAAH_R|state==AAAH_L;
	assign digging=state==DIG_R|state==DIG_L;
endmodule
