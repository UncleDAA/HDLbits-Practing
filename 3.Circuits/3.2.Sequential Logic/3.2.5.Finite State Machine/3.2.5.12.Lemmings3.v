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
            // start falling
            case(state)
                // slop walking / stop digging
                LEFT:next_state=AAAH_L;
                DIG_L:next_state=AAAH_L;
                RIGHT:next_state=AAAH_R;
                DIG_R:next_state=AAAH_R;
                // keep falling
                default next_state=state;
            endcase
        end
        else begin
            if(state!=RIGHT & state!=LEFT) begin
                case(state)
                    // stop falling
                    AAAH_R:next_state=RIGHT;
                    AAAH_L:next_state=LEFT;
                    // keep digging
                    default next_state=state;
                endcase
            end
            else begin
                //stop walking / start digging
                if(dig) begin
                    case(state)
                        LEFT:next_state=DIG_L;
                        RIGHT:next_state=DIG_R;
                    endcase
                end
                else begin
                    //start walking
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
