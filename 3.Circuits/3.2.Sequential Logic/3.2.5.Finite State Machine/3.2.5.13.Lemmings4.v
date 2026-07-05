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
    output digging 
); 
    
    reg [2:0] state, next_state;
    reg [7:0] falling_time; 
    
    parameter LEFT=3'b000, RIGHT=3'b001, AAAH_L=3'b010, AAAH_R=3'b011, DIG_L=3'b100, DIG_R=3'b101, DEAD=3'b110;
    always @(*) begin
        case(state)
            LEFT: begin
                if(!ground) next_state=AAAH_L;
                else if(dig) next_state=DIG_L;
                else if(bump_left) next_state=RIGHT;
                else next_state=LEFT;
            end
            RIGHT: begin
                if(!ground) next_state=AAAH_R;
                else if(dig) next_state=DIG_R;
                else if(bump_right) next_state=LEFT;
                else next_state=RIGHT;
            end
            AAAH_L: begin
                if(!ground) next_state=AAAH_L;
            	else begin
                    if(falling_time>8'd20) next_state=DEAD;
                    else next_state=LEFT;
                end
            end
            AAAH_R: begin
                if(!ground) next_state=AAAH_R;
                else begin
                    if(falling_time>8'd20) next_state=DEAD;
                    else next_state=RIGHT;
                end
            end
            DIG_L: begin
                if(ground) next_state=DIG_L;
            	else next_state=AAAH_L;
            end
            DIG_R: begin
                if(ground) next_state=DIG_R;
            	else next_state=AAAH_R;
            end
            DEAD: next_state=DEAD;
        endcase
    end
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
            falling_time <= 8'b0;
        end
        else begin
            state <= next_state;
            if (next_state == AAAH_L || next_state == AAAH_R) begin
                if (falling_time != 8'hFF) begin
                    falling_time <= falling_time + 1'b1;
                end
            end
            else begin
                falling_time <= 8'b0; 
            end
        end
    end
    
    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == AAAH_R || state == AAAH_L);
    assign digging    = (state == DIG_R || state == DIG_L);
    
endmodule
