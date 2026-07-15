module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );
    parameter SEARCH=0,SHIFT=1,COUNTING=2,DONE=3;
    reg [3:0]state,next;
    reg [3:0]search_buffer;
    reg [1:0]counter;
    
    always @(*) begin
        case(state)
            SEARCH: begin
                if({search_buffer[2:0],data}==4'b1101) next=SHIFT;
                else next=SEARCH;
            end
   			SHIFT: begin
                if(counter==2'b11) next=COUNTING;
                else next=SHIFT;
            end
            COUNTING: begin
                if(!done_counting) next=COUNTING;
                else next=DONE;
            end
            DONE: begin
                if(ack) next=SEARCH;
                else next=DONE;
            end
        endcase
    end
    always @(posedge clk) begin
        if(reset) begin
            state<=SEARCH;
            search_buffer<=0;
            counter<=0;
        end
        else begin
            state<=next;
            case(state)
                SEARCH: search_buffer<={search_buffer[2:0],data};
                SHIFT: counter<=counter+1;
                DONE: begin
                    search_buffer<=0;
                    counter<=0;
                end
            endcase
        end
    end
    
    assign shift_ena = (state == SHIFT) ;
    assign counting = (state == COUNTING);
	assign done = (state == DONE);
endmodule

// REF //
module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );
    parameter SEARCH_1=0,SEARCH_11=1,SEARCH_110=2,SEARCH_1101=3,SHIFT_1=4,SHIFT_2=5,SHIFT_3=6,SHIFT_4=7,COUNTING=8,DONE=9;
    reg [3:0]state,next;
    
    always @(*) begin
        case(state)
            SEARCH_1: begin
                if(data) next=SEARCH_11;
                else next=SEARCH_1;
            end
            SEARCH_11: begin
                if(data) next=SEARCH_110;
                else next=SEARCH_1;
            end
            SEARCH_110: begin
                if(!data) next=SEARCH_1101;
                else next=SEARCH_110;
            end
            SEARCH_1101: begin
                if(data) next=SHIFT_1;
                else next=SEARCH_1;
            end
            SHIFT_1: next=SHIFT_2;
            SHIFT_2: next=SHIFT_3;
            SHIFT_3: next=SHIFT_4;
            SHIFT_4: next=COUNTING;
            COUNTING: begin
                if(!done_counting) next=COUNTING;
                else next=DONE;
            end
            DONE: begin
                if(ack) next=SEARCH_1;
                else next=DONE;
            end
        endcase
    end
    always @(posedge clk) begin
        if(reset) state<=SEARCH_1;
        else state<=next;
    end
    
    assign shift_ena = (state == SHIFT_1 || state == SHIFT_2 ||state == SHIFT_3 ||state == SHIFT_4) ;
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
                

endmodule
